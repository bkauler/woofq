#include <arpa/inet.h>
#include <ifaddrs.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
int main(int argc, char *argv[])
{
 struct ifaddrs *addrs, *tmp;

 getifaddrs(&addrs);
 tmp = addrs;

 while (tmp) 
 {
    if (tmp->ifa_addr && tmp->ifa_addr->sa_family == AF_INET)
    {
        struct sockaddr_in *pAddr = (struct sockaddr_in *)tmp->ifa_addr;
        printf("%s: %s\n", tmp->ifa_name, inet_ntoa(pAddr->sin_addr));
    }

    tmp = tmp->ifa_next;
 }
 
 freeifaddrs(addrs);

 exit(EXIT_SUCCESS);
}
