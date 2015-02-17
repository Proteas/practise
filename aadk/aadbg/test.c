
#include <stdio.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/sysctl.h>
#include <dlfcn.h>

extern int ptrace(int, pid_t, caddr_t, int);
extern int sysctl(int *, u_int, void *, size_t *, void *, size_t);

typedef int (*ptrace_ptr)(int, pid_t, caddr_t, int);

#define PT_DENY_ATTACH  31

int is_debugger_present(void);

int main(int argc, char **argv)
{
    printf("[test]---> call ptrace 1\n");
    ptrace(PT_DENY_ATTACH, 0, 0, 0);

    printf("[test]---> call ptrace 2\n");
    void *handle = dlopen("/usr/lib/system/libsystem_kernel.dylib", RTLD_GLOBAL | RTLD_NOW);
    ptrace_ptr pptrace = dlsym(handle, "ptrace");
    pptrace(PT_DENY_ATTACH, 0, 0, 0);
    dlclose(handle);

    if (is_debugger_present()) {
        printf("[test]---> debugger presented\n");
    }
    else {
        printf("[test]---> debugger not presented\n");
    }

    return 0;
}

int is_debugger_present(void)
{
    int name[4];
    struct kinfo_proc info;
    size_t info_size = sizeof(info);
  
    info.kp_proc.p_flag = 0;
  
    name[0] = CTL_KERN;
    name[1] = KERN_PROC;
    name[2] = KERN_PROC_PID;
    name[3] = getpid();
  
    if (sysctl(name, 4, &info, &info_size, NULL, 0) == -1) {
        perror("sysctl");
        exit(-1);
    }

    return ((info.kp_proc.p_flag & P_TRACED) != 0);
}
