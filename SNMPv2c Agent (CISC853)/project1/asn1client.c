/* asn1client.c */ 
/* Programmed by Adarsh Sethi */
/* February 10, 2015 */
/* Illustrates basic client operations for sending ASN.1 structures */
/* Sends an integer and a string to a server using UDP */
/* NOTE: This program does very little error checking */


#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <netdb.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>

#include "asn1/Message.h"
#include "asn1/MyType.h"

#define MAX_SIZE 1024
#define BUFFER_SIZE 4096

int main(void) {

   int sock_client;  /* Socket used by client */ 

   struct sockaddr_in client_addr;  /* Internet address structure that
                                        stores client address */
   int client_port;  /* Port number used by client (local port) */

   struct sockaddr_in server_addr;  /* Internet address structure that
                                        stores server address */
   struct hostent * server_hp;      /* Structure to store server's IP
                                        address */
   char server_hostname[MAX_SIZE]; /* Server's hostname */
   int server_port;  /* Port number used by server (remote port) */

   Message_t sending_int;          /* integer to be sent */
   char sending_str[80];           /* string to be sent */
   MyType_t * sending_octet_str;     /* pointer to octet string that stores
                                         string to be sent */
   asn_enc_rval_t encode_rtn;      /* return code of encode function */

   int buffer_len;   /* number of bytes in send buffer */
   char send_buffer[BUFFER_SIZE];  /* sending buffer */

  
   /* open a socket */
   if ((sock_client = socket(AF_INET, SOCK_DGRAM, 0)) < 0) {
      perror("Client: can't open datagram socket\n");
      exit(1);
   }

   /* initialize client address information */
   client_port = 0;   /* This allows choice of any available local port */

   /* Uncomment these lines if you want to specify a particular local port: */
   /*
   printf("Enter port number for client: ");
   scanf("%d", &client_port);
   if (client_port < 0) {
      printf("client: invalid client port number\n");
      close(sock_client);
      exit(1);
   }
   */

   /* clear client address structure and initialize with client address */
   memset(&client_addr, 0, sizeof(client_addr));
   client_addr.sin_family = AF_INET;
   client_addr.sin_addr.s_addr = htonl(INADDR_ANY); /* This allows choice of
                                        any host interface, if more than one 
                                        are present */
   client_addr.sin_port = htons((in_port_t) client_port);

   /* bind the socket to the local client port */
   if (bind(sock_client, (struct sockaddr *) &client_addr,
                                    sizeof (client_addr)) < 0) {
      perror("Client: can't bind to local address\n");
      close(sock_client);
      exit(1);
   }

   /* initialize server address information */
   printf("Enter hostname of server: ");
   scanf("%s", server_hostname);
   if ((server_hp = gethostbyname(server_hostname)) == NULL) {
      perror("Client: invalid server hostname\n");
      close(sock_client);
      exit(1);
   }
   printf("Enter port number for server: ");
   scanf("%d", &server_port);
   if (server_port < 0) {
      printf("Client: invalid server port number\n");
      close(sock_client);
      exit(1);
   }

   /* Clear server address structure and initialize with server address */
   memset(&server_addr, 0, sizeof(server_addr));
   server_addr.sin_family = AF_INET;
   memcpy((char *)&server_addr.sin_addr, server_hp->h_addr,
                                    server_hp->h_length);
   server_addr.sin_port = htons((in_port_t) server_port);
   printf("address = %s\n", inet_ntoa(server_hp->h_addr));

   /* prepare integer for sending */
   sending_int = 24;
   printf("Sending integer: %d \n", sending_int);

   /* encode integer using BER to a serial sequence of bytes
         and store in the send buffer */
   memset(send_buffer, 0, BUFFER_SIZE);
   encode_rtn = der_encode_to_buffer(&asn_DEF_Message, &sending_int,
                           send_buffer, BUFFER_SIZE);

  /* encode_rtn.encoded contains the no. of bytes encoded */
  /* and has the value -1 if there is an error */
   if (encode_rtn.encoded == -1){
      printf("Error while encoding\n");
      exit(1);
   }

   /* send message from send buffer with integer */
   buffer_len = encode_rtn.encoded;
   sendto(sock_client, send_buffer, buffer_len, 0,
            (struct sockaddr *) &server_addr, sizeof (server_addr));
   printf("Sent message with integer\n");


   /* prepare string for sending */
   printf("\nType a string: ");
   scanf("%s", &sending_str);
   printf("Sending string: %s \n", sending_str);

   /* First convert C-style string to an OCTET STRING */
   sending_octet_str = OCTET_STRING_new_fromBuf(&asn_DEF_MyType,
                               sending_str, -1);
   
   /* Now encode OCTET STRING using BER to a serial sequence of
        bytes and store in send buffer */
   memset(send_buffer, 0, BUFFER_SIZE);
   encode_rtn = der_encode_to_buffer(&asn_DEF_MyType, sending_octet_str,
                           send_buffer, BUFFER_SIZE);
   if (encode_rtn.encoded == -1){
      printf("Error while encoding\n");
      exit(1);
   }

   /* send message from send buffer with string */
   buffer_len = encode_rtn.encoded;
   sendto(sock_client, send_buffer, buffer_len, 0,
            (struct sockaddr *) &server_addr, sizeof (server_addr));
   printf("Sent message with string\n");

   /* free OCTET STRING */
   OCTET_STRING_free(&asn_DEF_MyType, sending_octet_str, 0);

   /* close the socket */
   close (sock_client);
}
