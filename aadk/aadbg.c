
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <dlfcn.h>


//-- Begin: code from ptrace.h
#define PT_DENY_ATTACH  31
//-- End


//-- System Ptrace
// typedef int (*ptrace_ptr_t)(int request, pid_t pid, caddr_t addr, int data);
// ptrace_ptr_t sys_ptrace = NULL;
//-- End


//-- Decl
extern int ptrace(int request, pid_t pid, caddr_t addr, int data);
int re_ptrace(int request, pid_t pid, caddr_t addr, int data);
void aadbg_constructor(void) __attribute__((constructor));
//-- End


int re_ptrace(int request, pid_t pid, caddr_t addr, int data)
{
    return 0;
    // if (request == PT_DENY_ATTACH) {
    //     return 0;
    // }
    // else {
    //     return ptrace(request, pid, addr, data);
    // }
}


// void aadbg_constructor(void)
// {
//     const char *lib_path = "/usr/lib/system/libsystem_kernel.dylib";
//     void *handle = dlopen(lib_path, RTLD_NOW);
//     if (handle == NULL) {
//         return;
//     }
//     else {
//     }

//     sys_ptrace = dlsym(handle, "ptrace");
//     if (sys_ptrace == NULL) {
//         return;
//     }
// }
