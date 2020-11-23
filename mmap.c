#include <stdio.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <unistd.h>

int main(int argc, char *argv[])
{
	int fd;
	char msg[] = "hello, world!\n";
	long page_size, map_size;
	char *map;

	fd = open(argv[1], O_RDWR|O_CREAT, 0777);
	pwrite(fd, &msg, strlen(msg), 0);

	page_size = getpagesize();
	map_size = (1024 / page_size + 1) * page_size;
	printf("page_size: %ld\n", page_size);
	printf("map_size: %ld\n", map_size);

	map = (char*)mmap(NULL, map_size, PROT_READ, MAP_SHARED, fd, 0);
	printf("%s: %s\n", argv[1], map);

	close(fd);
}
