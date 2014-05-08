#include <string.h>
#include <stdio.h>

// gcc is_adjective.c -o is_adjective

int main (int argc, char *argv[])
{
	char* basepath=argv[0];// 
	char* adjectives_file="english.adjectives.list";
	char path[80];
	char search[80];
	strcpy (search,	argv[1]);
	strcat (search,"\n");
	strcpy (path,basepath);
	char *last_slash = strrchr(path, '/');
	*(last_slash + 1) = '\0';//  PRESERVE_LAST_SLASH
	strcat (path,adjectives_file);
	// printf(argv[1]);
	// printf("Opening File %s\n", path);
	FILE *infile;
	if ((infile = fopen(path, "r")) == NULL) {
		printf("Error opening file!!");
		perror("Error opening file");
		perror(path);
		// exit(1);
	}
	fseek(infile, 0L, SEEK_END);
		int size = ftell(infile);
	fseek(infile, 0L, SEEK_SET);
	
char adjective[1000];	
while (fgets(adjective, sizeof (adjective), infile) != NULL) {
	if(strcmp(search, adjective) == 0){
					printf(adjective);
		 return 1;
		}
}
return -1;
}