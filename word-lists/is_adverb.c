#include <string.h>
#include <stdio.h>

// gcc is_adverb.c -o is_adverb

int main (int argc, char *argv[])
{
	char* basepath=argv[0];// 
	char* adverb_file="english.adverbs.list";
	char path[80];
	char search[80];
	strcpy (search,	argv[1]);
	strcat (search,"\n");
	strcpy (path,basepath);
	char *last_slash = strrchr(path, '/');
	*(last_slash + 1) = '\0';//  PRESERVE_LAST_SLASH
	strcat (path,adverb_file);
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
	
char adverb[1000];	
while (fgets(adverb, sizeof (adverb), infile) != NULL) {
	if(strcmp(search, adverb) == 0){
					printf(adverb);
		 return 1;
		}
}
return -1;
}