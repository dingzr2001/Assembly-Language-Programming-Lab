#include <stdio.h>
#include <stdlib.h>

int main()
{
    char s[11] = "qpsrutwvyx";
    for(int i=0; i<10; i++)
        s[i] = s[i] ^ 'A';
    printf("%s\n",s);
    return 0;
}
