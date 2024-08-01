#include "kernel/types.h"
#include "user.h"
 
int main()
{
    int p[2];  //create pipe for ping and pong written
    pipe(p);
    char readtext[10];  //to read the result
    int pid = fork();  //create pid
    if(pid==0){  //child pid
        read(p[0],readtext,10);
        printf("%d: received %s\n",getpid(),readtext);
        write(p[1],"pong",10);
        exit(0);
    }
    else{  //father pid
        write(p[1],"ping",10);
        wait(0);  //father stop and wait for child reading
        read(p[0],readtext,10);
        printf("%d: received %s\n",getpid(),readtext);
        exit(0);
    }
    return 0;
}
