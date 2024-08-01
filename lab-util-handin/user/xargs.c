#include"kernel/types.h"
#include"kernel/stat.h"
#include"user/user.h"
#include"kernel/fs.h"
#include"kernel/param.h"

#define MAXLEN 32

int main(int argc, char *argv[]) {
    char *path = "echo";   // 执行命令
    char buf[MAXLEN * MAXARG] = {0},*p;  // 存放参数的数组和指针
    char *params[MAXARG];  // 参数的指针数组
    int oriParamCnt = 0;  // xargs后命令所带的参数个数
    int paramIdx;  // 参数序号
    int paramLen;  // 参数长度
    int i;
    char ch;  // 临时记录读取字符
    int res;  // read读取长度, 用于判断是否输入结束
    if (argc > 1)  // 参数数量大于1
    {  
        path = argv[1];  // 提取指令
        for (i = 1; i < argc; i++) {  // 设置参数, 注意也需要带上指令的参数
            params[oriParamCnt++] = argv[i];
        }
    } else  //参数唯一,即只有xargs
    {    
        params[oriParamCnt++] = path;  // 即指令为echo
    }
    paramIdx = oriParamCnt;  // 后续参数起始序号
    p = buf;
    paramLen = 0;
    while (1) {
        res = read(0, p, 1);  //0表示标准输入，p表示读取内容存到p，1表示读取的长度
        ch = *p;
        
        if (res != 0 && ch != ' ' && ch != '\n')  // 若读取的为一般字符
        {
            ++paramLen;
            ++p;
            continue;
        }
        // 未读取成功, 或者读取的是空格或者回车
        params[paramIdx++] = p - paramLen;  // 计算参数起始位置
        // 参数长度置0
        paramLen = 0;
        // 设置字符结束符
        *p = 0;
        ++p;
        if (paramIdx == MAXARG && ch == ' ') // 若读取的参数超过上限
        {
            while ((res = read(0, &ch, 1)) != 0)  // 一直读到回车即下个命令为止
            {
                if (ch == '\n') break;
            }
        }
        if (ch != ' ')  // 若读取的不为空格, 即 res==0||ch=='\n'
        {
            if (fork() == 0)   // 创建子进程执行命令
            {
                exec(path, params);
                exit(0);
            } 
            else 
            {
                wait((int *) 0);  // 父进程等待子进程
                paramIdx = oriParamCnt;  // 重置参数序号和指针
                p = buf;
            }
        }
        // 若输入读取完毕则退出
        if (res == 0) 
        {
            break;
        }
    }
    exit(0);
}

