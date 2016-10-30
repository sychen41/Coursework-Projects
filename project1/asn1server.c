/* asn1server.c */
/* Programmed by Adarsh Sethi */
/* February 10, 2015 */
/* Illustrates basic server operations for receiving ASN.1 structures */
/* Receives an integer and a string from a client using UDP */
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

/* SERV_UDP_PORT is the port number on which the server listens for
   incoming messages from clients. You should change this to a different
   number to prevent conflicts with others in the class. */

#define SERV_UDP_PORT 65000

int main(void) {

   int sock_server;  /* Socket on which server listens to clients */

   struct sockaddr_in server_addr;  /* Internet address structure that
                                        stores server address */
   int server_port;  /* Port number used by server (local port) */

   struct sockaddr_in client_addr;  /* Internet address structure that
                                        stores client address */
   int client_addr_len;  /* Length of client address structure */

   Message_t * recv_int;         /* pointer to received integer */
   char * recv_str;              /* pointer to received string */
   MyType_t * recv_octet_str;    /* pointer to octet string that
                                         stores received string */
   asn_dec_rval_t decode_rtn;    /* return code of decode function */

   char recv_buffer[BUFFER_SIZE];  /* receive buffer */
   int recvlen;  /* no. of characters received */


   /* open a socket */
   if ((sock_server = socket(AF_INET, SOCK_DGRAM, 0)) < 0) {
      perror("Server: can't open datagram socket\n");
      exit(1);
   }

   /* initialize server address information */
   memset(&server_addr, 0, sizeof(server_addr));
   server_addr.sin_family = AF_INET;
   server_addr.sin_addr.s_addr = htonl (INADDR_ANY);  /* This allows choice of
                                        any host interface, if more than one
                                        are present */
   server_port = SERV_UDP_PORT; /* Server will listen on this port */
   server_addr.sin_port = htons(server_port);

   /* bind the socket to the local server port */
   if (bind(sock_server, (struct sockaddr *) &server_addr,
                                    sizeof (server_addr)) < 0) {
      perror("Server: can't bind to local address\n");
      close(sock_server);
      exit(1);
   }

   client_addr_len = sizeof (client_addr);

   /* wait for incoming message with integer */
   printf("Waiting for incoming message on port %d\n\n", 
                           server_addr.sin_port);

   memset(recv_buffer, 0, BUFFER_SIZE); /* clear buffer */
   if ( (recvlen = recvfrom(sock_server, recv_buffer, BUFFER_SIZE, 0, 
                            (struct sockaddr *) &client_addr,
                                &client_addr_len)) <= 0){
      printf("Error while receiving\n");
      exit(1);
   }

   /* decode received byte sequence in receive buffer to extract integer */
   recv_int = NULL;
   decode_rtn = ber_decode(0, &asn_DEF_Message, (void **)&recv_int,
                               recv_buffer, BUFFER_SIZE);

   if (decode_rtn.code != RC_OK){
      printf("Error while decoding\n");
      exit(1);
   }

   /* print received integer using asn1c's print function */
   asn_fprint(stdout, &asn_DEF_Message, recv_int);

   /* print received integer and free structure */
   printf("\n Received integer: %d\n", *recv_int);
   Message_free(&asn_DEF_Message, recv_int, 0);
      

   /* wait for incoming message with string */
   printf("Waiting for incoming message on port %d\n\n",
                           server_addr.sin_port);

   memset(recv_buffer, 0, BUFFER_SIZE);
   if ( (recvlen = recvfrom(sock_server, recv_buffer, BUFFER_SIZE, 0,
                            (struct sockaddr *) &client_addr,
                                &client_addr_len)) <= 0){
      printf("Error while receiving\n");
      exit(1);
   }

   /* decode received byte sequence in receive buffer 
            to extract OCTET STRING */
   recv_str = NULL;
   recv_octet_str = NULL;
   decode_rtn = ber_decode(0, &asn_DEF_MyType, (void **)&recv_octet_str,
                               recv_buffer, BUFFER_SIZE);

   if (decode_rtn.code != RC_OK){
      printf("Error while decoding\n");
      exit(1);
   }

   /* print received OCTET STRING using asn1c's print function */
   asn_fprint(stdout, &asn_DEF_MyType, recv_octet_str);

   /* convert received OCTET STRING to a C-style string */
   recv_str = malloc(sizeof(char) * ((*recv_octet_str).size + 1));
   memcpy(recv_str, (*recv_octet_str).buf, (*recv_octet_str).size);
   recv_str[(*recv_octet_str).size] = '\0';

   /* print string and free structures */
   printf("\n Received string: %s\n", recv_str);
   free(recv_str);
   MyType_free(&asn_DEF_MyType, recv_octet_str, 0);

   /* close the socket */
   close(sock_server);

}
