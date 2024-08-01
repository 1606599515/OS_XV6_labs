#include "kernel/types.h"
#include "user.h"

const int Maxnum=36;
void prime(int readCont,int writeCont)  //递归，每次寻找一个素数 
{
	char numsforJudge[Maxnum];  //存放读管道一端的数据 
	read(readCont,numsforJudge,Maxnum);  //numsforJudge读得数组
	int current=0;  //剩余未判断的数里的第一个数，必然是质数 
	for(int i=0;i<Maxnum;i++){
		if(numsforJudge[i]=='0')
		{
		    current=i;
		    break;
		}
	} 
	if(current==0)exit(0);  //已经全部判断完了，算法结束 
	printf("prime %d\n",current);
	for(int i=0;i<Maxnum;i++){  //该质数的倍数必然不是质数，从剩余未判断的数里去掉这些数 
		if(i%current==0)
		    numsforJudge[i]='1';
	}
	int pid=fork();  //创建进程
	if(pid!=0)  //父进程 
	{
		write(writeCont,numsforJudge,Maxnum);  //把未判断完的数输给子进程 
		wait(0);
	} 
	else  //子进程 
	{
		prime(readCont,writeCont);
		wait(0);
	}
}
int main()
{
	char nums[Maxnum];  //表示是否已判断完毕 
	for(int i=0;i<Maxnum;i++){
            nums[i]='0';
    }
	nums[0]='1';nums[1]='1';  //0和1都不是质数，不在考虑范围 
	int p[2];   //创建管道
	pipe(p);
	int pid=fork();  //创建进程
	if(pid!=0)  //父进程 
	{
		write(p[1],nums,Maxnum);  //把未判断完的数输给子进程 
		wait(0);
	} 
	else  //子进程 
	{
		prime(p[0],p[1]);
		wait(0);
	}
	exit(0);
}

