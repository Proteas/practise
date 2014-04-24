#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <dyld-interposing.h> // from dyld.239.3

static int log_open(const char* path, int flags, mode_t mode)
{
	printf("Open File: %s\n", path);
	return open(path, flags, mode);
}

DYLD_INTERPOSE(log_open, open);
