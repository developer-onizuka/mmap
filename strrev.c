#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <unistd.h>

#define INIT_BUFSIZE 4096

void strrev(char *str, int size) {
	for(int i=0;i<size/2;++i) {
		char t = str[i];
		str[i] = str[size-1-i];
		str[size-1-i] = t;
	}
}

int main(int argc, char *argv[])
{
	int fd;
	char *system_buf;
	int buf_size = INIT_BUFSIZE;
	system_buf = (char*)malloc(buf_size);

	fd = open(argv[1], O_RDWR);
	pread(fd, system_buf, buf_size, 0);
	strrev(system_buf, strlen(system_buf));

	printf("%s: %s\n", argv[1], system_buf);

	close(fd);
}
