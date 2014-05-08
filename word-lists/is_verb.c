#include <string.h>
#include <stdio.h>

// gcc is_verb.c -o is_verb

int main (int argc, char *argv[])
{
	char* basepath=argv[0];// 
	char* verbs_file="english.verbs.list";
	char path[80];
	char search[80];
	strcpy (search,	argv[1]);
	strcat (search,"\n");
	strcpy (path,basepath);
	char *last_slash = strrchr(path, '/');
	*(last_slash + 1) = '\0';//  PRESERVE_LAST_SLASH
	// strcat (path,"word-lists/");
	strcat (path,verbs_file);
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
	
char verb[1000];	
// char* verbs=malloc(size*sizeof(char)+10);
while (fgets(verb, sizeof (verb), infile) != NULL) {
	// sscanf(line, "%s", verb);

	if(strcmp(search, verb) == 0){
					printf(verb);
		// printf("1");
		 return 1;
		}
}
		// printf("NO VERB");
return -1;
}