#include "kernel/param.h"
#include "kernel/types.h"
#include "user/user.h"

int main(int argc, char *argv[])  
{
    if(argc>0)  //检查输入参数 
    {
        sleep(atoi(argv[1]));
        exit(0);
    }
    else  //缺少输入参数：睡眠时间 
    {
        fprintf(2,"usage:sleep time\n");
        exit(1);
    }
}
