#include "kernel/param.h"
#include "kernel/types.h"
#include "user/user.h"

int main(int argc, char *argv[])  
{
    if(argc>0)  //���������� 
    {
        sleep(atoi(argv[1]));
        exit(0);
    }
    else  //ȱ�����������˯��ʱ�� 
    {
        fprintf(2,"usage:sleep time\n");
        exit(1);
    }
}
