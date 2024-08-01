#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"

char* fmtname(char *path)  //这个函数实际上没用到 
{
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
    ;
  p++;

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}

void find(char *path,char* fileName)  //主函数获取两个参数 ,把ls改成find 
{
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){
    fprintf(2, "find: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
    fprintf(2, "find: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
  case T_FILE:
    fprintf(2,"usage:find <dictionary> <fileName>\n");
    return; 
    break;

  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
      printf("find: path too long\n");
      break;
    }
    strcpy(buf, path);
    p = buf+strlen(buf);
    *p++ = '/';
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
      if(de.inum == 0)
        continue;
      memmove(p, de.name, DIRSIZ);
      p[DIRSIZ] = 0;
      if(stat(buf, &st) < 0){
        printf("find: cannot stat %s\n", buf);
        continue;
      }
      if (st.type == T_DIR && strcmp(p, ".") != 0 && strcmp(p, "..") != 0)   //搜索文件路径 
	  {
		find(buf,fileName);
	  } 
	  else if (strcmp(fileName, p) == 0)
		printf("%s\n", buf);
    }
    break;
  }
  close(fd);
}

int main(int argc, char *argv[])
{
  if(argc < 2){   
    fprintf(2,"usage:find dirName fileName\n");
    exit(1);
  }

  find(argv[1],argv[2]);  //第一个参数为当前路径，第二个参数为要查找的文件名 
  exit(0);
}
