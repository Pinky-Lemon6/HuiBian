#include <stdio.h>
#include <stdlib.h>

struct source {
	char SAMID[10];
	int SDA;
	int SDB;
	int SDC;
	int SDF;
} ;

//extern struct source;
void print_F(struct source *MIDF, int MID_COUNT) {
	printf("The data in MIDF are as followed:\n");
	for (int i = 0; i < MID_COUNT; i++) {
		printf("------------------------\n");
		printf("SAMID:%d\n", MIDF[i].SAMID);
		printf("SDA:%d\n", MIDF[i].SDA);
		printf("SDB:%d\n", MIDF[i].SDB);
		printf("SDC:%d\n", MIDF[i].SDC);
		printf("SDF:%d\n", MIDF[i].SDF);
		
	}
	//__asm ret
}