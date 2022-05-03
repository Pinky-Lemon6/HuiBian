#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/*编写者：李石峪 U202015351
本程序由3个模块组成：1.main.c 2.Cal_F.asm 3.Copy_Data.asm
本模块为主函数模块 main.c，为程序主出入口，用于实现功能切换
本模块包含以下子程序：void judge()、void modify()、void print_F()、int f2()*/

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
int DATA_N = 100;
void copy_data(int*, int,int,int,int,int);
void cal_f(int, int, int, int*);
void modify();
void judge(int sda, int sdb, int sdc) {
	int SDF=0;
	cal_f(sda,sdb,sdc,&SDF);
	if (SDF < 100) {
		copy_data(&LOWF, LCOUNT,sda,sdb,sdc,SDF);
		LCOUNT++;
	}
	else if (SDF > 100) {
		copy_data(&HIGHF, HCOUNT,sda,sdb,sdc,SDF);
		HCOUNT++;
	}
	else {
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
			judge(SDA, SDB, SDC);
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
	printf("SDF of this data is:%d\n",f);
	if (f < 100) {
		copy_data(&LOWF, 0, a, b, c, f);
		printf("The first data in LOWF has changed.\n");
	}
	else if (f > 100) {
		copy_data(&HIGHF, 0, a, b, c, f);
		printf("The first data in HIGHF has changed.\n");
	}
	else {
		copy_data(&MIDF, 0, a, b, c, f);
		printf("The first data in MIDF has changed.\n");
	}

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