#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<stdlib.h>
#include<string.h>

struct Sample {
	char samid[12];
	int sda, sdb, sdc, sf;
};

int MIDCNT = 0;
int* MIDCNTPTR = &MIDCNT;
char tmpc;
char usernameIn[12] = { 0 };
char passwordIn[12] = { 0 };
char username[12] = "dingzhaorui";
char password[12] = "0123456789";
struct Sample sample1={"000000001", 2540, 0, 0, 0 };
struct Sample* SAMPLEADD = &sample1;
struct Sample lowf[100000];
struct Sample midf[100000];
struct Sample highf[100000];
struct Sample* LOWPTR = lowf;
struct Sample* MIDPTR = midf;
struct Sample* HIGHPTR = highf;

int verify(void);
extern void STOREDATA(void);
void printMidf(void);
int main() {
	if (verify() == 0)
		return 0;
	for (int i = 0; i < 5; i++) {
		STOREDATA();
	}
	printMidf();
}

int verify() {
	
	for (int i = 0; i < 3; i++) {
		printf("Please input username:\n");
		scanf("%s", &usernameIn);
		printf("Please input password:\n");
		scanf("%s", &passwordIn);
		if (strcmp(usernameIn, username)==0 && strcmp(passwordIn, password)==0) {
			return 1;
		}
	}
	
	return 0;
}

void printMidf(void) {
	for (int i = 0; i < MIDCNT; i++) {
		printf("%s\n%d\n%d\n%d\n%d\n",midf[i].samid, midf[i].sda, midf[i].sdb, midf[i].sdc, midf[i].sf);
	}
}