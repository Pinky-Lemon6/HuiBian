#include <stdio.h>
#include <string.h>
#include <stdlib.h>

extern function2();
int f1(char* SAVED_USERNAME, char *SAVED_PWD) {
	char IN_USERNAME[10] = {0}, IN_PWD[10] = {0};
	printf("Welcome to Use!Please Log in!\n");
	for (int i = 3; i > 0; i--) {
		printf("You have %d chances left!\n", i);
		printf("Please input your user name:(No more than 10 characters)\n");
		scanf_s("%s", &IN_USERNAME,10);
		printf("Please input your password:(No more than 10 characters)\n");
		scanf_s("%s", &IN_PWD,10);
		if (strcmp(IN_USERNAME, SAVED_USERNAME) == 0 && strcmp(IN_PWD, SAVED_PWD) == 0) {
			printf("Log in successfully!\n");
			__asm jmp function2
		}
		else {
			printf("Username or Password is wrong!\n");
		}
	}
	__asm jmp exit
}

