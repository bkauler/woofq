/* 20190402 rewrite BaCon utility in C 
   (c) Copyright Barry Kauler, April 2019, bkhome.org
   License GPL V3 (refer: /usr/share/doc/legal)
*/

#include <string.h>
#include <libintl.h>
#include <locale.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <dirent.h>
#include <errno.h>

#include <linux/netlink.h>
//#include <linux/poll.h>
#include <linux/rtnetlink.h>
#include <net/if.h>
#include <poll.h>

#include <regex.h>

//'for reading contents of /tmp/pup_event_ipc...
//PROTO opendir, readdir, closedir
//DECLARE dir1 TYPE DIR*
//DECLARE ent1 TYPE struct dirent*
DIR* dir3;
struct dirent* ent1;
char *off1;

//'defined in linux/netlink.h and linux/rtnetlink.h
//DECLARE h TYPE struct nlmsghdr *
//DECLARE ifi TYPE struct ifinfomsg *
struct nlmsghdr *h;
struct ifinfomsg *ifi;

//'struct sockaddr_nl, defined in linux/netlink.h...
//RECORD nls
// LOCAL nl_family TYPE unsigned short
// LOCAL nl_pad TYPE unsigned short
// LOCAL nl_pid TYPE unsigned int
// LOCAL nl_groups TYPE unsigned int
//END RECORD
struct sockaddr_nl nls;
struct sockaddr_nl nls2;

//'struct pollfd, defined in asm-generic/poll.h...
//RECORD pfd
// LOCAL fd TYPE int
// LOCAL events TYPE short
// LOCAL revents TYPE short
//END RECORD
//struct pollfd pfd;
//'190212 want this immediately after pfd!...
//struct pollfd pfd2;
struct pollfd pfd[2];

//DECLARE buf TYPE char ARRAY 512
//DECLARE eventstatus TYPE int
//DECLARE bufin TYPE char*
char buf1[512];
int eventstatus;
char *bufin;

//DECLARE clientfile TYPE char*
//DECLARE outmsg TYPE char*
char clientfile[64];
char outmsg[512];

//'variables for network detection
//DECLARE net_ifs TYPE char*
//net_ifs_str$="/tmp/pup_event_backend/network_"
//net_ifs=net_ifs_str$
//'DECLARE line2 TYPE char*
//DECLARE netcnt TYPE int
//netcnt=0
int netcnt;

char xdisplay[4];
char ipc_prefix[64];
char netflag[8];
char netflagdata[8];
char devevent[64];
int len;

regex_t regex1;
regex_t regex2;
int reti;

int i;
int flag_block;
int flag_disk;
char devname[64];

int typeflg;
__u16 msgtype_old1=0;
__u16 msgtype_old2=0;
int blockflg=0;

void exit_func(int val) {
 regfree(&regex1);
 regfree(&regex2);
 exit(val);
}

//FUNCTION ipc_post_func(STRING zipc_prefix$,STRING zipc_event$)
void ipc_post_func(char* zipc_prefix,char* zipc_event) {
 //'look for any files named /tmp/pup_event_ipc/ipc_prefix$* ...
 //'ex: /tmp/pup_event_ipc/block_*
 dir3 = opendir("/tmp/pup_event_ipc");
 if (dir3 != NULL) {
  while(1) {
   ent1 = readdir(dir3);
   if (ent1==NULL) break;
   if (ent1->d_type == DT_REG) { //check that it is a file.
    off1 = strstr(ent1->d_name,zipc_prefix);
    if (off1 != NULL) {
     clientfile[0] = 0;
     strcat(clientfile,"/tmp/pup_event_ipc/");
     strcat(clientfile,ent1->d_name);
     outmsg[0] = 0;
     strcat(outmsg,zipc_event);
     strcat(outmsg,"\n");
     int clientdescr = open(clientfile, O_WRONLY | O_APPEND);
     if (clientdescr>0) {
      int wr = write(clientdescr,outmsg,strlen(outmsg));
      close(clientdescr);
     }
    }
   }
  }
  closedir(dir3);
 }
 return;
}





int main(int argc, char **argv) {
 DIR *dir1;
 int retval;
 FILE *fp;
 int cnt60;
 int cnt4;
 char diskevents[256];
 char buf2[512];

 
 //'initialization script... note, RETVAL has exit status.
 //SYSTEM "/usr/local/pup_event/frontend_startup"
 //IF RETVAL!=0 THEN END 9
 retval = system("/usr/local/pup_event/frontend_startup");
 if (retval != 0) exit(9);
 
 //'initialise the nls structure...
 nls.nl_family = AF_NETLINK;
 nls.nl_pad = 0;
 nls.nl_pid = getpid();
 nls.nl_groups = -1;
 //nls2
 nls2.nl_family = AF_NETLINK;
 nls2.nl_pad = 0;
 nls2.nl_pid = getpid();
 nls2.nl_groups = RTMGRP_LINK | RTMGRP_IPV4_IFADDR | RTMGRP_IPV6_IFADDR;

 //IF FILEEXISTS("/tmp/pup_event_backend")==0 THEN MAKEDIR "/tmp/pup_event_backend"
 dir1 = opendir("/tmp/pup_event_backend"); //test if folder exists.
 if (ENOENT == errno) {
  retval = mkdir("/tmp/pup_event_backend",ACCESSPERMS);
  if (retval != 0) exit(10);
 }
 else closedir(dir1);
 
 //IF FILEEXISTS("/tmp/pup_event_ipc")==0 THEN MAKEDIR "/tmp/pup_event_ipc"
 dir1 = opendir("/tmp/pup_event_ipc"); //test if folder exists.
 if (ENOENT == errno) {
  retval = mkdir("/tmp/pup_event_ipc",ACCESSPERMS);
 }
 else closedir(dir1);
 
 //SYSTEM "touch /tmp/pup_event_backend/network_"
 //SYSTEM "touch /tmp/pup_event_backend/x_"
 retval = system("touch /tmp/pup_event_backend/network_");
 retval = system("touch /tmp/pup_event_backend/x_");

 //IF FILEEXISTS("/tmp/pup_event_backend/.network_")==0 THEN
 // OPEN "/tmp/pup_event_backend/.network_" FOR WRITING AS netflagid
 // CLOSE FILE netflagid
 //ENDIF
 if( access("/tmp/pup_event_backend/.network_",F_OK) == -1 ) {
  fp = fopen("/tmp/pup_event_backend/.network_","w"); //create it.
  fclose(fp);
 }
 
 //'X is up...
 //xdisplay$=""
 //IF FILEEXISTS("/tmp/.X11-unix/X1")==1 THEN xdisplay$="X1"
 //IF FILEEXISTS("/tmp/.X11-unix/X0")==1 THEN xdisplay$="X0"
 xdisplay[0] = 0;
 if( access("/tmp/.X11-unix/X0",F_OK) != -1 ) strcpy(xdisplay,"X0");
 else if( access("/tmp/.X11-unix/X1",F_OK) != -1 ) strcpy(xdisplay,"X1");
 
 //OPEN "/tmp/pup_event_backend/x_" FOR WRITING AS xid
 //IF ERROR == 0 THEN
 // WRITELN xdisplay$ TO xid
 // CLOSE FILE xid
 //ENDIF
 fp = fopen("/tmp/pup_event_backend/x_","w");
 fputs(xdisplay,fp);
 fclose(fp);
 if (xdisplay[0]==0) exit(11);
 
 //'also post to any ipc clients...
 ipc_post_func("x_",xdisplay);
 
 //'Open hotplug event netlink socket...
 //pfd.events = POLLIN
 //pfd.fd = socket(PF_NETLINK, SOCK_DGRAM, NETLINK_KOBJECT_UEVENT)
 //IF pfd.fd == -1 THEN END 1
 pfd[0].events = POLLIN;
 pfd[0].fd = socket(PF_NETLINK, SOCK_DGRAM, NETLINK_KOBJECT_UEVENT);
 if (pfd[0].fd == -1) exit(1);

 //'listen to netlink socket...
 //retval=bind(pfd.fd, (void *)&nls.nl_family, size_nls)
 //IF retval==-1 THEN END 2
 retval = bind(pfd[0].fd, (void *)&nls.nl_family, sizeof(nls));
 if (retval == -1) exit(2);

 //'190212 network netlink socket...
 //pfd2.events = POLLIN
 //pfd2.fd = socket(AF_NETLINK, SOCK_RAW, NETLINK_ROUTE)
 //IF pfd2.fd == -1 THEN END 1
 //'listen to netlink socket...
 //retval=bind(pfd2.fd, (void *)&nls2.nl_family, size_nls)
 //IF retval==-1 THEN END 2
 pfd[1].events = POLLIN;
 pfd[1].fd = socket(AF_NETLINK, SOCK_RAW, NETLINK_ROUTE);
 if (pfd[1].fd == -1) exit(1);
 retval = bind(pfd[1].fd, (void *)&nls2.nl_family, sizeof(nls2));
 if (retval == -1) exit(2);

 cnt60=0;
 cnt4=0;
 diskevents[0]=0;
 buf2[0]=0;
 netcnt=0;
 
 //checking for network connection, compile...
 //'exclude all 127.* ip addresses...
 reti = regcomp(&regex1," \\|-- [123456789][13456789]",REG_EXTENDED|REG_NOSUB);
 if (reti != 0) exit(13);
 //checking for drive change, compile...
 reti = regcomp(&regex2,"^sd[a-z]$|^hd[a-z]$|^mmcblk[0-9]$|^sr[0-9]$|^nvme[0-9]n[1-9]$",REG_EXTENDED|REG_NOSUB);
 if (reti != 0) exit(14);

 while(1) {
  //'1000 milli-second timeout... note, -1 is wait indefinitely.
  //'190212 2nd param is 2, as array of pollfd structures: pfd pfd2
  //eventstatus=poll((struct pollfd *)&pfd.fd, 2, 1000);
  eventstatus=poll(pfd, 2, 1000);
  //printf("eventstatus: %d \n",eventstatus); //***TEST***
  if (eventstatus==-1) exit_func(3);
  
  if (eventstatus==0) {
   //'one-second timeout.
    
   //'graceful exit if shutdown X (see /usr/bin/restartwm,wmreboot,wmpoweroff)...
   //quit if this file exists...
   if( access("/tmp/wmexitmode.txt",F_OK) == 0) {
    xdisplay[0] = 0;
    fp = fopen("/tmp/pup_event_backend/x_","w");
    fputs(xdisplay,fp);
    fclose(fp);
    //'also post to any ipc clients...
    ipc_post_func("x_",xdisplay);
    exit_func(8);
   }
    
   //'190212 this is to reduce network events traffic...
   if (netcnt > 0) netcnt=netcnt-1;
   
   if (diskevents[0] != 0) {
    //'this will update the desktop icons...
    buf2[0] = 0;
    strcat(buf2,"/usr/local/pup_event/frontend_change ");
    strcat(buf2,diskevents);
    system(buf2);
    //'other clients can monitor, look for any files named /tmp/pup_event_ipc/block_* ...
    ipc_post_func("block_",diskevents);
    diskevents[0]=0;
   }
   
   //'do not call /usr/local/pup_event/frontend_timeout directly, use ipc...
   //'look for any files named /tmp/pup_event_ipc/timeout1_* ...
   //' except after 4 seconds, will post to "timeout4_" instead...
   //' and after 60 seconds, will post to "timeout60_" instead...
   cnt60 = cnt60+1;
   cnt4 = cnt4+1;
   ipc_prefix[0] = 0;
   if (cnt60 >= 60) { strcpy(ipc_prefix,"timeout60_"); cnt60=0; }
   else if (cnt4 >= 4) { strcpy(ipc_prefix,"timeout4_"); cnt4=0; }
   else strcpy(ipc_prefix,"timeout1_");
   ipc_post_func(ipc_prefix,"timeout");
   
   //'180224 check for network connection...
   //'read /proc/net/fib_trie for quick check...
   off1=0;
   netflag[0] = 0;
   strcpy(netflag,"dn");
   FILE *fibid = fopen("/proc/net/fib_trie","r");
   if (fibid == NULL) continue;
   while ( fgets(buf2, sizeof(buf2)-1, fibid) != NULL ) {
    //compare...
    reti = regexec(&regex1,buf2,0,NULL,0);
    if (reti == 0) {
     netflag[0] = 0;
     strcpy(netflag,"up");
     break;
    }
   }
   fclose(fibid);

   //'check if need to update network status file /tmp/pup_event_backend/network_
   FILE *netflagid = fopen("/tmp/pup_event_backend/.network_","r+");
   if (netflagid == NULL) continue;
   fgets(netflagdata, sizeof(netflagdata)-1, netflagid);
   retval = strcmp(netflag,netflagdata);
   if (retval != 0) {
    fseek(netflagid,0,SEEK_SET); //set file-pointer to beginning of file.
    fputs(netflag,netflagid);
    if (reti == 0) { //network is up.
     fp = popen("/usr/sbin/getlocalip | grep -o '^[^lt][^:]*' | tr '\n' ' '","r");
     if (fp == NULL) { fclose(netflagid); continue; }
     fgets(buf2, sizeof(buf2)-1, fp);
     pclose(fp);
    }
    else buf2[0]=0;
    FILE *netfileid = fopen("/tmp/pup_event_backend/network_","w");
    fputs(buf2,netfileid);
    fclose(netfileid);
    //'also post to any ipc clients...
    ipc_post_func("network_",buf2);
   }
   fclose(netflagid);
   //200521 code copied up from 190212 network cabling event...
   //50secs after a cabling event, is there any change?...
   if (netcnt == 0) {
    if (blockflg == 1) {
     blockflg=0;
     if (msgtype_old1 != msgtype_old2) {
      //'post to any ipc clients...
      ipc_post_func("netchg_","change");
      //'also, let us be proactive, call a script directly...
      if (access("/usr/local/pup_event/netchg",F_OK) == 0) {
       if (typeflg == 20) system("/usr/local/pup_event/netchg 20 &");
       if (typeflg == 21) system("/usr/local/pup_event/netchg 21 &");
       if (typeflg == 17) system("/usr/local/pup_event/netchg 17 &");
      }
      msgtype_old2=msgtype_old1;
     }
    }
   }
   continue;
  } //end one-second-timeout.
   
  //'##############################################
  //'190212 this will be non-zero if a network cabling event has occurred...
  //printf("pfd[1].revents: %d \n",pfd[1].revents); //***TEST*** 200521
  if (pfd[1].revents != 0) {
   //'PRINT "YES got a network event"
   if (pfd[1].revents != POLLIN) exit(15); //maybe should just continue?
   len = recv(pfd[1].fd, buf1, sizeof(buf1)-1, MSG_DONTWAIT);
   if (len == -1) exit_func(4);
   //'much black magic to parse this, but just doing something very simple here...
   struct nlmsghdr *h = (struct nlmsghdr *) buf1;
   //'PRINT "nlmsg_type=",h->nlmsg_type
   //printf("h->nlmsg_type: %d \n",h->nlmsg_type); //***TEST*** 200521
   //'can get several of these in rapid succession, reduce traffic...
   //'I think that RTM_NEWLINK=16, carrier-up is 20, carrier-down is 21, but just test for 16.
   //'also get 17 when plug and unplug usb wifi dongle.
   //'when get one of these, ignore any more in next 50 seconds...
   //200521 get lots of 16, ignore them. only respond to 20, 21, 17...
   typeflg=0;
   if (h->nlmsg_type == 20) typeflg=20;
   if (h->nlmsg_type == 21) typeflg=21;
   if (h->nlmsg_type == 17) typeflg=17;
   if (typeflg != 0) {
    msgtype_old1=h->nlmsg_type;
    if (blockflg == 0) {
     if (msgtype_old2 != msgtype_old1) {
      blockflg=1;
      msgtype_old2=msgtype_old1;
      netcnt = 50;
      //code block copied above.
      //'note, this is not a status flag, only a change, so don't write to /tmp/pup_event_backend
      //'post to any ipc clients...
      ipc_post_func("netchg_","change");
      //'also, let us be proactive, call a script directly...
      if (access("/usr/local/pup_event/netchg",F_OK) == 0) {
       if (typeflg == 20) system("/usr/local/pup_event/netchg 20 &");
       if (typeflg == 21) system("/usr/local/pup_event/netchg 21 &");
       if (typeflg == 17) system("/usr/local/pup_event/netchg 17 &");
      }
     }
    }
   }
  }
  
  //'190212 this will be non-zero if a hotplug event has occurred...
  //printf("pfd[0].revents: %d \n",pfd[0].revents); //***TEST***
  if (pfd[0].revents == 0) continue;
  //'get the uevent...
  if (pfd[0].revents != POLLIN) exit(15); //maybe should just continue?
  len = recv(pfd[0].fd, buf1, sizeof(buf1)-1, MSG_DONTWAIT);
  if (len == -1) exit_func(4);
  //printf("buf1: %s \n",buf1); //***TEST***
  //'process the uevent...
  //'only add@, remove@, change@ uevents...
  devevent[0]=0;
  if (buf1[0]=='a') {
   if (buf1[1]=='d') {
    if (buf1[2]=='d') strcpy(devevent,"add:");
   }
  }
  if (buf1[0]=='r') {
   if (buf1[1]=='e') {
    if (buf1[2]=='m') strcpy(devevent,"rem:");
   }
  }
  if (buf1[0]=='c') {
   if (buf1[1]=='h') {
    if (buf1[2]=='a') strcpy(devevent,"cha:");
   }
  }
  if (devevent[0]==0) continue;
  
  //'want uevents that have "SUBSYSTEM=block"...
  //'buf1 has a sequence of zero-delimited strings...
  //'certain order, ex: \00SUBSYSTEM=block\00DEVNAME=sdc\00DEVTYPE=disk\00
  i=0;
  flag_block=0;
  flag_disk=0;
  while (i < len) {
   bufin = buf1+i;
   if (flag_block == 1) {
    if (strstr(bufin,"DEVNAME") != NULL) {
     devname[0]=0;
     strcpy(devname,bufin+8); //get string past the "DEVAME="
     //printf("bufin: %s \n",bufin); //***TEST***
     //compare...
     reti = regexec(&regex2,devname,0,NULL,0);
     //printf("devname: %s reti: %d \n",devname,reti); //***TEST***
     if (reti == 0) {
      flag_disk = 1;
      break;
     }
    }
   }
   else {
    if (strcmp(bufin,"SUBSYSTEM=block") == 0) flag_block = 1;
   }
   i = i+strlen(bufin)+1;
  } //end while
  if (flag_disk == 0) continue;
  strcat(diskevents,devevent);
  strcat(diskevents,devname);
  strcat(diskevents," ");
  //printf("diskevents: %s \n",diskevents); //***TEST***
 
 } //end while
 exit_func(0); //return 0;
} //end main
