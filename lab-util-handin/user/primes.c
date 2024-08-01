#include "kernel/types.h"
#include "user.h"

const int Maxnum=36;
void prime(int readCont,int writeCont)  //�ݹ飬ÿ��Ѱ��һ������ 
{
	char numsforJudge[Maxnum];  //��Ŷ��ܵ�һ�˵����� 
	read(readCont,numsforJudge,Maxnum);  //numsforJudge��������
	int current=0;  //ʣ��δ�жϵ�����ĵ�һ��������Ȼ������ 
	for(int i=0;i<Maxnum;i++){
		if(numsforJudge[i]=='0')
		{
		    current=i;
		    break;
		}
	} 
	if(current==0)exit(0);  //�Ѿ�ȫ���ж����ˣ��㷨���� 
	printf("prime %d\n",current);
	for(int i=0;i<Maxnum;i++){  //�������ı�����Ȼ������������ʣ��δ�жϵ�����ȥ����Щ�� 
		if(i%current==0)
		    numsforJudge[i]='1';
	}
	int pid=fork();  //��������
	if(pid!=0)  //������ 
	{
		write(writeCont,numsforJudge,Maxnum);  //��δ�ж����������ӽ��� 
		wait(0);
	} 
	else  //�ӽ��� 
	{
		prime(readCont,writeCont);
		wait(0);
	}
}
int main()
{
	char nums[Maxnum];  //��ʾ�Ƿ����ж���� 
	for(int i=0;i<Maxnum;i++){
            nums[i]='0';
    }
	nums[0]='1';nums[1]='1';  //0��1���������������ڿ��Ƿ�Χ 
	int p[2];   //�����ܵ�
	pipe(p);
	int pid=fork();  //��������
	if(pid!=0)  //������ 
	{
		write(p[1],nums,Maxnum);  //��δ�ж����������ӽ��� 
		wait(0);
	} 
	else  //�ӽ��� 
	{
		prime(p[0],p[1]);
		wait(0);
	}
	exit(0);
}

