#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <sys/sysctl.h>
#include <sys/types.h>
#include <errno.h>
#include <fsevents.h> // from xnu-v2422.1.72


//-- Begin: copied from "bsd/vfs/vfs_events.c"
#pragma pack(1)

typedef struct kfs_event_a {
    uint16_t type;
    uint16_t refcount;
    pid_t    pid;
} kfs_event_a;

typedef struct kfs_event_arg {
    uint16_t type;
    uint16_t pathlen;
    char data[0];
} kfs_event_arg;

#pragma pack()
//-- End


// define buffer size
#define BUFSIZE 64 * 1024


const char* EvenTypeToString(uint32_t  type);
char* GetProcName(long pid);
int doArg(char *arg);


int main (int argc, char* argv[])
{
    if (geteuid() != 0) {
        fprintf(stderr,"Opening /dev/fsevents requires root permissions\n");
        exit (1);
    }

    // Open the device
    int fsed = 0;
    fsed = open ("/dev/fsevents", O_RDONLY);

    if (fsed < 0) {
        perror ("open");
        exit(2);
    }

    int8_t  events[FSE_MAX_EVENTS];
    for (int i = 0; i < FSE_MAX_EVENTS; i++) {
        events[i] = FSE_REPORT; 
    }

    fsevent_clone_args clone_args;
    memset(&clone_args, '\0', sizeof(clone_args));

    int cloned_fsed;
    clone_args.fd = &cloned_fsed;
    clone_args.event_queue_depth = 10;
    clone_args.event_list = events;
    clone_args.num_events = FSE_MAX_EVENTS;
    
    // Do it.
    int rc = ioctl (fsed, FSEVENTS_CLONE, &clone_args);
    if (rc < 0) { 
        perror ("ioctl");
        exit(3);
    }

    close (fsed);

    //unsigned short *arg_type;
    char buf[BUFSIZE];
    while ((rc = read (cloned_fsed, buf, BUFSIZE)) || 1) {
        if (rc <= 0) {
            printf("***Warning: haven't read data, continue\n");
            continue;
        }
        // rc returns the count of bytes for one or more events:
        int offInBuf = 0;
        while (offInBuf < rc) {
            struct kfs_event_a *fse = (struct kfs_event_a *)(buf + offInBuf);
            struct kfs_event_arg *fse_arg = NULL;
            if (offInBuf) { 
                printf ("Next event: %d\n", offInBuf);
            };

            printf ("%s (PID:%d) %s ", GetProcName(fse->pid), fse->pid , EvenTypeToString(fse->type) );

            offInBuf += sizeof(struct kfs_event_a);
            fse_arg = (struct kfs_event_arg *) &buf[offInBuf];
            printf ("%s\n", fse_arg->data);

            offInBuf += sizeof(kfs_event_arg) + fse_arg->pathlen;

            int arg_len = doArg(buf + offInBuf);
            offInBuf += arg_len;
            while (arg_len > 2) {
                arg_len = doArg(buf + offInBuf);
                offInBuf += arg_len;
            }
        } // end while (offInBuf < rc)

        if (rc > offInBuf) { 
            printf ("***Warning: Some events may be lost\n");
        }
    }

    return 0;
}


//-- Begin: Utils Function
const char* EvenTypeToString(uint32_t type)
{
    switch (type) {
        case FSE_CREATE_FILE: return ("Created ");
        case FSE_DELETE: return ("Deleted ");
        case FSE_STAT_CHANGED: return ("Stat changed ");
        case FSE_RENAME:    return ("Renamed ");
        case FSE_CONTENT_MODIFIED:  return ("Modified ");
        case FSE_CREATE_DIR:    return ("Created dir ");
        case FSE_CHOWN: return ("Chowned ");

        case FSE_EXCHANGE: return ("Exchanged "); /* 5 */
        case FSE_FINDER_INFO_CHANGED: return ("Finder Info changed for "); /* 6 */
        case FSE_XATTR_MODIFIED: return ("Extended attributes changed for "); /* 9 */
        case FSE_XATTR_REMOVED: return ("Extended attributesremoved for "); /* 10 */
        default : return ("Unknown Event");

    }
}

char* GetProcName(long pid)
{
    static char procName[4096];
    size_t len = 1000;
    int rc;
    int mib[4];
    memset(procName, '\0', 4096);

    mib[0] = CTL_KERN;
    mib[1] = KERN_PROC;
    mib[2] = KERN_PROC_PID;
    mib[3] = pid;

    if ((rc = sysctl(mib, 4, procName, &len, NULL, 0)) < 0) {
        perror("trace facility failure, KERN_PROC_PID\n");
        exit(1);
    }

    // printf ("GOT PID: %d and rc: %d -  %s\n", mib[3], rc, ((struct kinfo_proc *)procName)->kp_proc.p_comm);

    return (((struct kinfo_proc *)procName)->kp_proc.p_comm);
}

int doArg(char *arg)
{
    unsigned short  *argType  = (unsigned short *) arg;
    if (*argType == 0) {
        return 0;
    }

    unsigned short  *argLen   = (unsigned short *) (arg + 2);
    uint32_t        *argVal   = (uint32_t *) (arg + 4);
    uint64_t        *argVal64 = (uint64_t *) (arg + 4);
    dev_t           *dev;
    char            *str;

    switch (*argType) {
            case FSE_ARG_INT64: // This is a timestamp field on the FSEvent
                printf ("Arg64: %lld\n", *argVal64);
                break;
            case FSE_ARG_STRING: // This is a filename, for move/rename (Type 3)
                str = (char *)argVal;
                printf("%s ", str);
                break;
            case FSE_ARG_DEV: // Device, corresponding to block device on which fs is mounted
                dev = (dev_t *) argVal;
                printf ("DEV: %d,%d ", major(*dev), minor(*dev)); break;
            case FSE_ARG_MODE: // mode bits, etc
                printf("MODE: %x ", *argVal); break;
            case FSE_ARG_PATH: // Not really used... Implement this later..
                printf ("PATH: " ); break;
            case FSE_ARG_INO: // Inode number (unique up to device)
                printf ("INODE: %d ", *argVal); break;
            case FSE_ARG_UID: // UID of operation performer
                printf ("UID: %d ", *argVal); break;
            case FSE_ARG_GID: // Ditto, GID
                printf ("GID: %d ", *argVal); break;
            case FSE_ARG_FINFO: // Not handling this yet.. Not really used, either..
                printf ("FINFO\n"); break;
            case FSE_ARG_DONE:  printf("\n");return 2;

            default:
                printf ("(ARG of type %hd, len %hd)\n", *argType, *argLen);
        }

    return (4 + *argLen);
}
//-- End

