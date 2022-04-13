#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char* SAVED_USERNAME = "LISHIYU", * SAVED_PWD = "U202015351";
struct source {
	// char SAMID[10];
	int SDA;
	int SDB;
	int SDC;
	int SDF;
};
struct source LOWF[10000], MIDF[10000], HIGHF[10000],*first;
int ID=0, SDA, SDB, SDC;
int LCOUNT, MCOUNT, HCOUNT;
int DATA_N = 10;
void copy_data(int*, int,int,int,int,int);
void cal_f(int, int, int, int*);
void modify();
void judge(int sda, int sdb, int sdc,int n1) {
	int SDF=0;
	cal_f(sda,sdb,sdc,&SDF);
	if (SDF < 100) {
		if(!n1) first = &LOWF[0];
		copy_data(&LOWF, LCOUNT,sda,sdb,sdc,SDF);
		LCOUNT++;
	}
	else if (SDF > 100) {
		if (!n1) first = &HIGHF[0];
		copy_data(&HIGHF, HCOUNT,sda,sdb,sdc,SDF);
		HCOUNT++;
	}
	else {
		if (!n1) first = &MIDF[0];
		copy_data(&MIDF, MCOUNT,sda,sdb,sdc,SDF);
		MCOUNT++;
	}

};
void print_F(struct source *f,int d_n) {
	printf("The data is as fllowed:\n");
	for (int i = 0; i < d_n; i++) {
		printf("-------------\n");
		printf("SDA:%d\n", f[i].SDA);
		printf("SDB:%d\n", f[i].SDB);
		printf("SDC:%d\n", f[i].SDC);
		printf("SDF:%d\n", f[i].SDF);
	}
}


int f2() {
	printf("Please input 100 sets of data:\n");
	int flag=1;
	char choice = '0';
	while (flag) {
		int i=0;
		for(i = 0; i < DATA_N; i++) {
			scanf_s("%d%d%d", &SDA, &SDB, &SDC);
			judge(SDA, SDB, SDC,i);
		}
		print_F(MIDF,MCOUNT);
again2:	printf("Please press 'R' to input again or press 'Q' to exit or press 'M' to modify the first set of data:\n");
		scanf_s("%c", &choice, 1); //处理printf产生的多余的'\n'
		scanf_s("%c", &choice,1);
		switch (choice) {
		case 'R':
			printf("Please input 100 sets of data again:\n");
			continue;
		case 'M':
			modify();
			goto again2;
		case 'Q':
			flag= 0;
			break;
		}
		
	}
	return 0;
}

void modify() {
	printf("Please input a set of data:\n");
	int a, b, c,f=0;
	scanf_s("%d%d%d", &a, &b, &c);
	cal_f(a, b, c, &f);
	copy_data(first, 0, a, b, c, f);
}

int main() {
	char IN_USERNAME[10] = { 0 }, IN_PWD[11] = { 0 };
	int i = 0;
	printf("Welcome to Use!Please Log in!\n");
	for (i = 3; i > 0; i--) {
		printf("You have %d chances left!\n", i);
		printf("Please input your user name:(No more than 10 characters)\n");
		scanf_s("%s", &IN_USERNAME, 10);
		printf("Please input your password:(No more than 10 characters)\n");
		scanf_s("%s", &IN_PWD, 11);
		if (strcmp(IN_USERNAME, SAVED_USERNAME) == 0 && strcmp(IN_PWD, SAVED_PWD) == 0) {
			printf("Log in successfully!\n");
			break;
		}
		else {
			printf("Username or Password is wrong!\n");
		}
	}
	if (!i) return 0;
	f2();
	
	return 0;
}