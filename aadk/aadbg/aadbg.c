
// By Proteas

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/sysctl.h>

#define PT_DENY_ATTACH  31

typedef struct interpose_s
{
    void *new_func;
    void *orig_func;
} interpose_t;

extern int ptrace(int, pid_t, caddr_t, int);
extern int sysctl(int *, u_int, void *, size_t *, void *, size_t);

int aadbg_ptrace(int _request, pid_t _pid, caddr_t _addr, int _data);
int aadbg_sysctl(int *name, u_int namelen, void *old, size_t *oldlen, void *newp, size_t newlen);

__attribute__((used))
static const interpose_t interposing_functions[] \
    __attribute__ ((section("__DATA, __interpose"))) = {
        { (void *)aadbg_ptrace, (void *)ptrace },
        { (void *)aadbg_sysctl, (void *)sysctl },
    };

int aadbg_ptrace(int _request, pid_t _pid, caddr_t _addr, int _data)
{
    printf("[aadbg]---> called ptrace\n");

    if (_request == PT_DENY_ATTACH) {
        printf("[aadbg]---> PT_DENY_ATTACH\n");
        return 0;
    }
    else {
        printf("[aadbg]---> return to original ptrace\n");
        return ptrace(_request, _pid, _addr, _data);
    }
}

int aadbg_sysctl(int *name, u_int namelen, void *old, size_t *oldlen, void *newp, size_t newlen)
{
    printf("[aadbg]---> call original sysctl\n");
    int ret = sysctl(name, namelen, old, oldlen, newp, newlen);
  
    if ((*(name) == CTL_KERN) && 
        (*(name + 1) == KERN_PROC) && 
        (*(name + 2) == KERN_PROC_PID)) {
        printf("[aadbg]---> clear P_TRACED bit\n");
        struct kinfo_proc *kinfo_ptr = (struct kinfo_proc *)old;
        kinfo_ptr->kp_proc.p_flag &= !P_TRACED;
    }
    
    return ret;
}
