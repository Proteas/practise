#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <stdarg.h>
#include <substrate.h>

#ifdef _DEBUG
#include <assert.h>
#endif

// function pointer
static int (*original_fprintf)(FILE * stream, const char * format, ...) = NULL;

extern "C" void log_fprintf(FILE * stream, const char *format, va_list arg)
{
    // fprintf("str=%s,num=%d","test",1234);
    // fprintf("fprintf(\"str=%%s,num=%%d\", %s, %d)", "test", 1234);
    size_t format_str_len = strlen(format);
    size_t holder_count = 0;
    for (int idx = 0; idx < format_str_len; ++idx) {
        if (*(format + idx) == '%') {
            ++holder_count;
        }
    }
    
    size_t buf_len = strlen("fprintf(\"\")\n") + format_str_len + holder_count * 5 + 1;
    
    char *buf = (char *)malloc(buf_len);
    memset(buf, 0x0, buf_len);
    
    // part 1
    const char *func_name = "fprintf(\"";
    memcpy(buf, func_name, strlen(func_name));
    
    // part 2
    size_t buf_location_start = strlen(func_name);
    size_t buf_location_middle = buf_location_start + format_str_len + holder_count;
    for (int idx = 0; idx < format_str_len; ++idx) {
        char temp = *(format + idx);
        if (temp == '%') {
            *(buf + buf_location_start) = '%';
            ++buf_location_start;
            // seperator
            memcpy(buf + buf_location_middle, ", ", 2);
            buf_location_middle += 2;
            // %s
            memcpy(buf + buf_location_middle, format + idx, 2);
            buf_location_middle += 2;
        }
        
        *(buf + buf_location_start) = temp;
        ++buf_location_start;
    }
    
    // part 3
    memcpy(buf + buf_location_middle, ")\"\n", 3);
#ifdef _DEBUG
    assert(buf_location_middle + 3 == buf_len - 1);
#endif
    
    vfprintf (stdout, buf, arg);
    
    free(buf); buf = NULL;
}

// replaced fprintf
extern "C" int replaced_fprintf(FILE * stream, const char * format, ...)
{
    int ret;
    va_list arg;
    va_start(arg, format);

    // log
    log_fprintf(stdout, format, arg);
    ret = vfprintf(stream, format, arg);
    
    va_end(arg);

    return ret;
}


__attribute__((constructor))
static void initialize() 
{
    NSLog(@"===============>varcfun loaded<===============");
    MSHookFunction(fprintf, replaced_fprintf, &original_fprintf);
    if (original_fprintf == NULL) {
        NSLog(@"===============>fail to hook fprintf<===============");
    }
}

__attribute__((destructor))
static void destroy()
{
     NSLog(@"===============>varcfun unloaded<===============");
     // reset hook
}
