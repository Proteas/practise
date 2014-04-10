#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/event.h>
#include <sys/time.h>

int main (int argc, char** argv)
{
    if (argc == 1) {
        printf("please indicate the pid.\n");
        return 1;
    }

    pid_t pid;
    int kq;
    int ret;
    int done;
    struct kevent ke;

    pid = atoi(argv[1]);
    kq = kqueue();
    if (kq == -1) {
        printf("fail to create queue.\n");
        return 2;
    }

    EV_SET(&ke, pid, EVFILT_PROC, EV_ADD, NOTE_EXIT | NOTE_FORK | NOTE_EXEC , 0, NULL);
    ret = kevent(kq, &ke, 1, NULL, 0, NULL);
    if (ret < 0) {
        printf("fail to monitor event.\n");
        return 3;
    }
    
    done = 0;
    while (!done) {
        memset(&ke, 0x0, sizeof (struct kevent));
        kevent(kq, NULL, 0, &ke, 1, NULL);
        if (ret < 0) {
            printf("fail to get event.\n");
            return 4;
        }

        if (ke.fflags & NOTE_FORK) {
            printf("PID %lu fork()ed\n", ke.ident);
        }

        if (ke.fflags & NOTE_EXEC) {
            printf("PID %lu exec()ed\n", ke.ident);
        }

        if (ke.fflags & NOTE_EXIT) {
            printf("PID %lu exited.\n", ke.ident);
            ++done;
        }
    }

    return 0;
}