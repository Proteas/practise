
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include "ptrace.h"

int main(int argc, char **argv)
{
    ptrace(PT_DENY_ATTACH, 0, 0, 0);
	printf("----------------->Main\n");
	return 0;
}
