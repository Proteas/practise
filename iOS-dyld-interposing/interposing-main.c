#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>

int main (int argc, char** argv)
{
    int handle = open("test.txt", O_RDONLY);
    close(handle);

    return 0;
}