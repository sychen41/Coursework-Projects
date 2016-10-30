/* asn1server.c */
/* Programmed by Shiyi Chen*/
/* April 12, 2015 */

#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <netdb.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>
#include <sys/wait.h>
#include <string.h>
#include <sys/mman.h>

#include "asn1/Message.h"
#include "asn1/MyType.h"
#include "asn1/SNMPMessage.h"
#include "asn1/PDUs.h"

#define MAX_SIZE 1024
#define BUFFER_SIZE 4096

/* SERV_UDP_PORT is the port number on which the server listens for
   incoming messages from clients. You should change this to a different
   number to prevent conflicts with others in the class. */

#define SERV_UDP_PORT 65168

#define PREFIX_LENGTH 10
int prefix[PREFIX_LENGTH] = {1, 3, 6, 1, 4, 1, 1277, 1, 3, 1};

//globals
union PingMibValue {
   INTEGER_t integer_value;
   Unsigned32_t int_value;
   OCTET_STRING_t *oct_value;
   TimeTicks_t time_value;
};

typedef struct PingMib {
   int access; // 0 for ReadOnly, 1 for ReadWrite
   int type; // IpAddress_t(1), Counter32_t(2), TimeTicks_t(3), Opaque_t(4), Unsigned32_t(5), INTEGER_t(6)
   union PingMibValue value; 
} pingMib;

pingMib pingMibArray[12];

typedef struct timeStructure {
   long int second;
   long int msecond;
} timeOfDay;
//start time
timeOfDay startTime;
//int pingDone;
static int *pingDone;
static int *pingError;
//static int *resultStatus;
int newResult;
int firstExpt;
//end of globals

int processMessage(SNMPMessage_t *recv_snmpmsg);
void processPDU(PDUs_t * msg_data);
void processGetRequest(GetRequest_PDU_t * pdus_choice_get_request);
int processSetRequest(SetRequest_PDU_t * pdus_choice_set_request);
void processGetVarBind(VarBind_t * varbind);
int* checkOID(ObjectName_t * varbindOID);
int processSetVarBind(VarBind_t * varbind); 
void executeSetVarBind(SetRequest_PDU_t * pdus_choice_set_request, int varBindCount, int indexes[]);

int main(void) {
   newResult = 0;
   pingDone = mmap(NULL, sizeof *pingDone, PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS, -1, 0);
   *pingDone = -1;
   pingError = mmap(NULL, sizeof *pingDone, PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS, -1, 0);
   *pingError = 0;
   //pingDone = -1;
   gettimeofday(&startTime, NULL);
   //printf("startTime.second: %d + startTime.msecond: %d\n", startTime.second, startTime.msecond);
   // default or initial value for mib vars
   long int defaultValue;
   int returnValue;
   //pingSysUpTime
   pingMibArray[0].access = 0; 
   pingMibArray[0].type = 3;
   defaultValue = 0;
   INTEGER_t temp0;
   returnValue = asn_long2INTEGER(&temp0, defaultValue);
   //pingMibArray[0].value.int_value = temp0; 
   pingMibArray[0].value.int_value = 0; 
   //printf("convert ok? : %d\n", returnValue);
   //pingSysName
   pingMibArray[1].access = 0;
   pingMibArray[1].type = 4;
   char * sysName = "Shiyi Chen";
   OCTET_STRING_t * sysNameOct;
   sysNameOct = OCTET_STRING_new_fromBuf(&asn_DEF_OCTET_STRING, sysName, -1);
   pingMibArray[1].value.oct_value = sysNameOct; 
   //pingSrcHostName 
   pingMibArray[2].access = 0;
   pingMibArray[2].type = 4;
   char * srcHostName = "mudskipper6";
   OCTET_STRING_t * srcHostNameOct;
   srcHostNameOct = OCTET_STRING_new_fromBuf(&asn_DEF_OCTET_STRING, srcHostName, -1);
   pingMibArray[2].value.oct_value = srcHostNameOct; 
   //pingTargetHostName
   pingMibArray[3].access = 1;
   pingMibArray[3].type = 4;
   char * targetHostName = "strauss.udel.edu";
   OCTET_STRING_t * targetHostNameOct;
   targetHostNameOct = OCTET_STRING_new_fromBuf(&asn_DEF_OCTET_STRING, targetHostName, -1);
   pingMibArray[3].value.oct_value = targetHostNameOct; 
   //pingProbeCount 
   pingMibArray[4].access = 1;
   pingMibArray[4].type = 5;
   defaultValue = 20; // 20 is default value
   INTEGER_t temp4;
   returnValue = asn_long2INTEGER(&temp4, defaultValue);
   pingMibArray[4].value.int_value = 20; 
   //pingMibArray[4].value.int_value = temp4; 
   //pingStartExpt
   pingMibArray[5].access = 1;
   pingMibArray[5].type = 5;
   defaultValue = 0; // 0 is default value
   INTEGER_t temp5;
   returnValue = asn_long2INTEGER(&temp5, defaultValue);
   pingMibArray[5].value.int_value = 0; 
   //pingMibArray[5].value.int_value = temp5; 
   //pingResultStatus 
   pingMibArray[6].access = 0;
   pingMibArray[6].type = 6;
   defaultValue = 6; // 0 is default value
   INTEGER_t temp6;
   returnValue = asn_long2INTEGER(&temp6, defaultValue);
   pingMibArray[6].value.integer_value = temp6; 
   //pingResponsesRecd
   pingMibArray[7].access = 0;
   pingMibArray[7].type = 5;
   defaultValue = 7; // 0 is default value
   INTEGER_t temp7;
   returnValue = asn_long2INTEGER(&temp7, defaultValue);
   //pingMibArray[7].value.int_value = temp7; 
   pingMibArray[7].value.int_value = 7; 
   //pingPercentLoss
   pingMibArray[8].access = 0;
   pingMibArray[8].type = 5;
   defaultValue = 444444; // 0 is default value
   INTEGER_t temp8;
   returnValue = asn_long2INTEGER(&temp8, defaultValue);
   pingMibArray[8].value.int_value = 8; 
   //pingMibArray[8].value.int_value = temp8; 
   //pingMinRTT
   pingMibArray[9].access = 0;
   pingMibArray[9].type = 5;
   defaultValue = 444444; // 0 is default value
   INTEGER_t temp9;
   returnValue = asn_long2INTEGER(&temp9, defaultValue);
   //pingMibArray[9].value.int_value = temp9; 
   pingMibArray[9].value.int_value = 9; 
   //pingMaxRTT
   pingMibArray[10].access = 0;
   pingMibArray[10].type = 5;
   defaultValue = 444444; // 0 is default value
   INTEGER_t temp10;
   returnValue = asn_long2INTEGER(&temp10, defaultValue);
   //pingMibArray[10].value.int_value = temp10; 
   pingMibArray[10].value.int_value = 10; 
   //pingAverageRTT
   pingMibArray[11].access = 0;
   pingMibArray[11].type = 5;
   defaultValue = 444444; // 0 is default value
   INTEGER_t temp11;
   returnValue = asn_long2INTEGER(&temp11, defaultValue);
   //pingMibArray[11].value.int_value = temp11; 
   pingMibArray[11].value.int_value = 11; 

   //check values
//   asn_fprint(stdout, &asn_DEF_Unsigned32, &(pingMibArray[0].value.int_value));
//   asn_fprint(stdout, &asn_DEF_OCTET_STRING, &(pingMibArray[1].value.oct_value));
//   asn_fprint(stdout, &asn_DEF_OCTET_STRING, &(pingMibArray[2].value.oct_value));
//   asn_fprint(stdout, &asn_DEF_OCTET_STRING, &(pingMibArray[3].value.oct_value));
//   asn_fprint(stdout, &asn_DEF_Unsigned32, &(pingMibArray[4].value.int_value));
//   asn_fprint(stdout, &asn_DEF_Unsigned32, &(pingMibArray[5].value.int_value));
   
   int sock_server;  /* Socket on which server listens to clients */

   struct sockaddr_in server_addr;  /* Internet address structure that
                                        stores server address */
   int server_port;  /* Port number used by server (local port) */

   struct sockaddr_in client_addr;  /* Internet address structure that
                                        stores client address */
   int client_addr_len;  /* Length of client address structure */

   SNMPMessage_t * recv_snmpmsg;

   asn_dec_rval_t decode_rtn;    /* return code of decode function */
   asn_enc_rval_t encode_rtn;

   char recv_buffer[BUFFER_SIZE];  /* receive buffer */
   char send_buffer[BUFFER_SIZE];
   int recvlen;  /* no. of characters received */
   int buffer_len;


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

//   int exp = 101;
//   int pid;
//  // int child_status;
//   int rc;
//   int data_pipe[2];
//
//   rc = pipe(data_pipe);
//   if (rc==-1) {
//      perror("pipe");
//      exit(1);
//   }
//   pid = fork();
//   switch (pid) {
//      case -1:
//      	 perror("fork"); 
//      	 exit(1);
//      case 0:
//      	 do_child(data_pipe, exp);
//      	 break;
////      	 printf("I am the child, Hello\n");
////      	 while(1){
////	    printf("I am the child, Looping\n");
////	    printf("child exp: %d\n", exp);
////	    if (exp == 1) {
////	       printf("I am the child, doing my job\n");
////	    }
////	    sleep(6);
////	 }
////      	 exit(0);
//      default:
//      	 do_parent(data_pipe);
//      	 break;
////      	 while(1){
////	    printf("I am the parent, Enter a value\n");
////	    exp = getchar() - 48;
////	    printf("parent exp: %d\n", exp);
////	    printf("\nYou Entered: ");
////	    putchar(exp);
////	    wait(&child_status);
////	    printf("\nI am the parent, child process %d exited with status %d\n", pid, child_status);
////	 }
//      	 //exit(0);
//   }

   firstExpt = 1;
   while(1){
      //int c;
      //int rc;
      //int data_pipe[2];
      //rc = pipe(data_pipe);
      //if (rc==-1) {
//	 perror("pipe");
//	 exit(1);
 //     }
      //code for child process
      //long int goPing;
      //asn_INTEGER2long(&(pingMibArray[5].value.int_value), &goPing);
      int goPing = pingMibArray[5].value.int_value;
      printf("\ngoPing? : %d\n", goPing);
      //if ((goPing == 1 && firstExpt == 1) || (goPing == 1 && *pingDone == 1)) {
      if (goPing) {
      	 if (firstExpt == 1) {
      	    firstExpt = 0;
	 }
      	 newResult = 1;
      	 //pingDone = 0;
      	 *pingDone = 0;
	 int pid;
	 pid = fork();
	 if (pid == 0) {
	    //get probe count
	    int probeCount = pingMibArray[4].value.int_value;
	    
	    //asn_INTEGER2long(&(pingMibArray[4].value.int_value), &probeCount);
	    printf("probeCount: %d\n", probeCount);

	    //get Target host name
	    printf("child executing\n");
	    printf("start Ping\n");
	    int size = (*(pingMibArray[3].value.oct_value)).size;
	    //printf("size: %d\n", size);
	    char *recv_str = NULL;
	    recv_str = malloc(sizeof(char) * ( size + 1 ) );
	    memcpy(recv_str, (*(pingMibArray[3].value.oct_value)).buf, size);
	    recv_str[size] = '\0';
	    printf("string: %s\n", recv_str);

	    //construct ping message
	    char pingMessage[80];
	    sprintf(pingMessage, "ping -s %s 56 %d > pingResult.txt", recv_str, probeCount);
	    printf("pingMessage: %s\n", pingMessage);
	    int returnV = system(pingMessage);
	    *pingError = returnV;
	    //printf("ping error? : %d\n", *pingError);
	    //system("ping -s www.yahoo.com 56 5 > result.txt");
	    free(recv_str);
	    printf("end Ping\n");
	    printf("end Child process\n");
	    *pingDone = 1;
	    //set a flag so parent process knows ping finished.
	    //int c;
	    //int rc;
	    //close(data_pipe[0]);
	    //c = 100;
	    //rc = write(data_pipe[1], &c, 1);
	    //if (rc == -1) {
	       //perror("child:write");
	       //close(data_pipe[1]);
	       //exit(1);
	    //}
	    exit(0);
	 }
	 //reset pingStartExpt to 0
	 goPing = 0;
	 //INTEGER_t resetExp;
	 //asn_long2INTEGER(&resetExp, goPing);
	 //pingMibArray[5].value.int_value = resetExp; 
	 pingMibArray[5].value.int_value = 0; 
	 //printf("reset exp\n");
	 //close(data_pipe[1]);
	 //if (rc = read(data_pipe[0], &c, 1) > 0) {
	     //printf("child process finished ping\n");
	     //pingDone = 1;
	 //}else {
	    //printf("child p still pinging\n");
	 //}
      }
      //end of code for child process
      memset(recv_buffer, 0, BUFFER_SIZE);
      memset(send_buffer, 0, BUFFER_SIZE);
      recv_snmpmsg = NULL;
      /* wait for incoming message with integer */
      printf("\n\n\nWaiting for incoming message on port %d\n\n", 
			      server_addr.sin_port);

      memset(recv_buffer, 0, BUFFER_SIZE); /* clear buffer */
      if ( (recvlen = recvfrom(sock_server, recv_buffer, BUFFER_SIZE, 0, 
			       (struct sockaddr *) &client_addr,
				   &client_addr_len)) <= 0){
	 printf("\nError while receiving\n");
	 //exit(1);
	 continue;
      }

      /* decode received byte sequence in receive buffer to extract integer */
      decode_rtn = ber_decode(0, &asn_DEF_SNMPMessage, (void **)&recv_snmpmsg,
				  recv_buffer, BUFFER_SIZE);

      if (decode_rtn.code != RC_OK){
	 printf("\nError while decoding\n");
	 //exit(1);
	 continue;
      }

      /* print received integer using asn1c's print function */
      //asn_fprint(stdout, &asn_DEF_Message, recv_int);
      //asn_fprint(stdout, &asn_DEF_SNMPMessage, recv_snmpmsg);

      
      printf("\nMessage decoded correctly, start processing...\n");
      int errorStatus = processMessage(recv_snmpmsg);
      if (errorStatus == 1) {
	 printf("\nMission Abort! \n");
      } else {
	 printf("\nProcessing finished \n");
	 //asn_fprint(stdout, &asn_DEF_SNMPMessage, recv_snmpmsg);

	 //Sending back response in SNMPMessage format
	 encode_rtn = der_encode_to_buffer(&asn_DEF_SNMPMessage, recv_snmpmsg, send_buffer, BUFFER_SIZE); 
	 if (encode_rtn.encoded == -1){
	    printf("\nEorror while encoding response\n");
	    //exit(1);
	    continue;
	 }
	 buffer_len = encode_rtn.encoded;
	 sendto(sock_server, send_buffer, buffer_len, 0, (struct sockaddr *) &client_addr, sizeof(client_addr));
	 printf("\nSent a response back\n");
      }
   } // end of while loop
   /* print received message and free structure */
   Message_free(&asn_DEF_SNMPMessage, recv_snmpmsg, 0);

   /* close the socket */
   close(sock_server);

}

int processMessage(SNMPMessage_t *recv_snmpmsg) {
   int error = 0;
   //printf("Processing Message\n");
   int version = (*recv_snmpmsg).version; 
   printf("\nVersion: %d (1 for v2)\n", version);
   int nameLength = (*recv_snmpmsg).community.size;
   //printf("string size: %d\n", nameLength);
   char * community_name = malloc(sizeof(char) * (nameLength + 1));
   memcpy(community_name, (*recv_snmpmsg).community.buf, nameLength);
   community_name[nameLength] = '\0';
   printf("\nCommunity: %s\n", community_name);
   if (version != 1) {
      printf("\nERROR: version invalid\n");
      error = 1;
   }
   if (strcmp(community_name, "public")!= 0) {
      printf("\nERROR: community name invalid\n");
      error = 1;
   }
   if (error == 0) {
      //asn_fprint(stdout, &asn_DEF_PDUs, &((*recv_snmpmsg).data));
      printf("\nVersion and Community checked, start processing PDU\n");
      processPDU(&((*recv_snmpmsg).data));
      return 0;
   } else {
      return 1; // 0 for no error, 1 for error.
   }
}

void processPDU(PDUs_t * msg_data){
   //printf("Processing PDU\n");
   int type = (*msg_data).present;
   //asn_fprint(stdout, &asn_DEF_PDUs, msg_data);
   long int *error_status;
   long int *error_index;
   if (type == 1){
      printf("\nOperation Type: GET. Start Execution\n");
      //printf("in processPDU before call processGetRequat\n");
      //asn_fprint(stdout, &asn_DEF_Unsigned32, &((*((*msg_data).choice.get_request.variable_bindings.list.array))[0].choice.choice.value.choice.application_wide.choice.unsigned_integer_value));
      //asn_fprint(stdout, &asn_DEF_OCTET_STRING, &((*((*msg_data).choice.get_request.variable_bindings.list.array))[0].choice.choice.value.choice.simple.choice.string_value));
      //asn_fprint(stdout, &asn_DEF_VarBind, &((*((*msg_data).choice.get_request.variable_bindings.list.array))[0]));
      processGetRequest(&((*msg_data).choice.get_request));   
      //printf("in processPDU after call processGetRequest\n");
      //asn_fprint(stdout, &asn_DEF_Unsigned32, &((*((*msg_data).choice.get_request.variable_bindings.list.array))[0].choice.choice.value.choice.application_wide.choice.unsigned_integer_value));
      //asn_fprint(stdout, &asn_DEF_OCTET_STRING, &((*((*msg_data).choice.get_request.variable_bindings.list.array))[0].choice.choice.value.choice.simple.choice.string_value));
      //asn_fprint(stdout, &asn_DEF_VarBind, &((*((*msg_data).choice.get_request.variable_bindings.list.array))[0]));
      printf("\nOperation executed. Constructing response\n");
   }
   else if (type == 5){
      printf("\nOperation Type: SET. Start Execution\n");
      processSetRequest(&(*msg_data).choice.set_request);   
      printf("\nOperation executed. Constructing response\n");
   }
   else if (type == 2 || type == 6 || type == 8 || type == 7){ //2 for getNext, 6 for inform_request, 8 for report, 7 for snmpV2_trap
      printf("\nERROR: Operation Type NOT Supported\n");
      error_status = &((*msg_data).choice.get_next_request.error_status);
      //printf("error status: %ld\n", *error_status);
      *(error_status) = 5; 
   }
   else if (type == 3){
      printf("\nERROR: Operation Type: GetBulk NOT supported\n");
      error_status = &((*msg_data).choice.get_bulk_request.non_repeaters);
      error_index = &((*msg_data).choice.get_bulk_request.max_repetitions);
      *(error_status) = 5; 
      *(error_index) = 0;
   }
   else {
      printf("\nERROR: Operation Type Error\n");
      //exit(1);
   }
   (*msg_data).present = 4;

}

void processGetRequest(GetRequest_PDU_t * pdus_choice_get_request) {
   int varBindCount = (*pdus_choice_get_request).variable_bindings.list.count; 
//   printf("varBindCount: %d\n", varBindCount);
   //printf("PingDone: %d\n", *pingDone);
   //printf("newResult: %d\n", newResult);
   printf("ping error? : %d\n", *pingError);
   if (*pingError != 0) {
      pingMibArray[6].value.int_value = 2;  //ping error
   }
   if (*pingDone == 1){
      if (newResult == 1 && *pingError == 0) {
	 long int results[7];
	 //analyse pingResult.txt and assign new value to mib variables
	 FILE *input_file = fopen("pingResult.txt", "r");
	 if (input_file == 0){
	    perror("Cannot open pingResult.txt\n");
	 }
	 else {
	    int startSearch = 0;
	    printf("processing file\n");
	    char line[256];
	    char * item;
	    int j = 0;
	    results[0] = -1;
	    results[1] = -1;
	    results[2] = -1;
	    results[3] = -1;
	    results[4] = -1;
	    results[5] = -1;
	    results[6] = -1;
	    while (fgets(line, sizeof(line), input_file)) {
	       //printf("%s", line); 
	       item = strtok(line, " ,/%-");
	       while (item != NULL) {
	       	  if (strcmp(item, "Statistics") == 0) {
	       	     //printf(":::::::::;%s\n", item);
		     startSearch = 1; 
		  }
		  if (startSearch) {
		     //int num = atoi(item);
		     float numFloat = atof(item) * 1000.0;
		     int numInt =  (int)numFloat;  
		     if (numInt != 0) {
			//printf("%s\n", item);
		     	results[j] = numInt;
		     	j = j + 1;
		     }
		     //printf("ffffffffffffffffff: %f\n", numFloat);
		     //printf("iiiiiiiiiiiiiiiiii: %i\n", numInt);
		  }
	       	  item = strtok(NULL, " ,/%-");
	       }
	    }
	 }
	 fclose(input_file);
	 //end of analyse
	 newResult = 0;
	 //printf("results[0]: %d\n", results[0]);
	 //printf("results[1]: %d\n", results[1]);
	 //printf("results[2]: %d\n", results[2]);
	 //printf("results[3]: %d\n", results[3]);
	 //printf("results[4]: %d\n", results[4]);
	 //printf("results[5]: %d\n", results[5]);
	 //printf("results[6]: %d\n", results[6]);
	 int returnValue;
	 //pingResponsesRecd
	 pingMibArray[7].value.int_value = results[1]/1000; 
	 if (results[1]/1000 == 0) {
	    pingMibArray[6].value.int_value = 1;  //destination unreachable
	 }
	 
//	 //pingPercentLoss
//	 INTEGER_t temp8;
	 if (results[6] == -1) {
	    pingMibArray[8].value.int_value = 0; 
	    pingMibArray[9].value.int_value = results[2]; 
	    pingMibArray[10].value.int_value = results[4]; 
	    pingMibArray[11].value.int_value = results[3]; 
	 }
	 else {
	    pingMibArray[8].value.int_value = results[2]/1000; 
	    pingMibArray[9].value.int_value = results[3]; 
	    pingMibArray[10].value.int_value = results[5]; 
	    pingMibArray[11].value.int_value = results[4]; 
	 }

      }
   }
   int i;
   for (i = 0; i < varBindCount; i++) {
      //printf("in processGetRequest before call getVarBind\n");
      //asn_fprint(stdout, &asn_DEF_Unsigned32, &((*((*pdus_choice_get_request).variable_bindings.list.array))[i].choice.choice.value.choice.application_wide.choice.unsigned_integer_value));
      //asn_fprint(stdout, &asn_DEF_OCTET_STRING, &((*((*pdus_choice_get_request).variable_bindings.list.array))[i].choice.choice.value.choice.simple.choice.string_value));

      processGetVarBind(((*pdus_choice_get_request).variable_bindings.list.array)[i]);
      //printf("in processGetRequest after call getVarBind\n");
      //asn_fprint(stdout, &asn_DEF_Unsigned32, &((*((*pdus_choice_get_request).variable_bindings.list.array))[i].choice.choice.value.choice.application_wide.choice.unsigned_integer_value));
      //asn_fprint(stdout, &asn_DEF_OCTET_STRING, &((*((*pdus_choice_get_request).variable_bindings.list.array))[i].choice.choice.value.choice.simple.choice.string_value));
   }
}

void processGetVarBind(VarBind_t * varbind) {
   //printf("print out the varbind\n");
   //asn_fprint(stdout, &asn_DEF_VarBind, varbind);
   int * checkOIDresult = checkOID(&((*varbind).name));
   int index = *(checkOIDresult+3);
   //printf("index again: %d\n", index);
   //printf("result[0] = %d\n", *checkOIDresult);
   //printf("result[1] = %d\n", *(checkOIDresult+1));
   //printf("result[2] = %d\n", *(checkOIDresult+2));
   int noSuchObject = *(checkOIDresult);  // 0 for no error, 1 for error
   int noSuchInstance = *(checkOIDresult+1); // 0 for error, 1 for error
   if (noSuchObject != 0){
      printf("\nERROR: noSuchObject!\n");
      (*varbind).choice.present = 3; // 3 for varbind -> choice_PR_noSuchObject
      return;
   }
   if (noSuchInstance != 0){
      printf("\nERROR: noSuchInstance!\n");
      (*varbind).choice.present = 4; // 4 for varbind -> choice_PR_noSuchInstance
      return;
   }
   // No need to check access type for GET operation

   if (index == 1 || index == 2 || index == 3 ) { // 1 for pingSysName, 2 for pingScrHostName, 3 for pingTargetHostName,
      //setup tag
      (*varbind).choice.present = 1; // 1 for varbind -> choice_PR_value 
      (*varbind).choice.choice.value.present = 1; // 1 for objectSystax -> objectSyntax_PR_simple 
      (*varbind).choice.choice.value.choice.simple.present = 2; // 2 for simpleSysntax_PR_string_value 
      //assign value
      (*varbind).choice.choice.value.choice.simple.choice.string_value = *(pingMibArray[index].value.oct_value); 
   }
   else if (index == 6 ) { //6 for pingResultStatus
      //printf("pingDOne? %d\n", pingDone);
      if (*pingDone != 1) {
	 printf("\nERROR: noSuchInstance! (because of Ping)\n");
	 (*varbind).choice.present = 4; // 4 for varbind -> choice_PR_noSuchInstance
	 return;
      }
      //setup tag
      (*varbind).choice.present = 1; // 1 for varbind -> choice_PR_value 
      (*varbind).choice.choice.value.present = 1; // 1 for objectSystax -> objectSyntax_PR_simple 
      (*varbind).choice.choice.value.choice.simple.present = 1; // 2 for simpleSysntax_PR_integer_value 
      //assign value
      long int tempLong;
      asn_INTEGER2long(&(pingMibArray[index].value.integer_value), &tempLong);
//      (*varbind).choice.choice.value.choice.simple.choice.integer_value = pingMibArray[index].value.integer_value; 
      (*varbind).choice.choice.value.choice.simple.choice.integer_value = tempLong; 
   }
   else if (index == 0) { // 0 for pingSysUpTime
      //setup tag
      (*varbind).choice.present = 1; // 1 for varbind -> choice_PR_value 
      (*varbind).choice.choice.value.present = 2; // 2 for objectSystax -> objectSyntax_PR_application_wide 
      (*varbind).choice.choice.value.choice.application_wide.present = 3; // 5 for applicationSysntax_PR_timeticks_value 
      //assign value
      timeOfDay currentTime;
      gettimeofday(&currentTime, NULL);
      //printf("currentTime.second: %d + currentTime.msecond: %d\n", currentTime.second, currentTime.msecond);
      long int second = currentTime.second - startTime.second;
      long int msecond = currentTime.msecond - startTime.msecond;
      //printf("secondElapsed: %d + msecondElapsed: %d\n", second, msecond);
      long int timeElapsed = second*100 + msecond/10000; // unit: 1/100 second
      //printf("timeElapsed: %d\n", timeElapsed);
      int returnValue = asn_long2INTEGER(&(pingMibArray[index].value.time_value), timeElapsed);
      (*varbind).choice.choice.value.choice.application_wide.choice.timeticks_value = pingMibArray[index].value.time_value; 
   }
   else if (index == 4 || index == 5) { // 4 for pingProbeCount, 5 for pingStartExpt
      //setup tag
      (*varbind).choice.present = 1; // 1 for varbind -> choice_PR_value 
      (*varbind).choice.choice.value.present = 2; // 2 for objectSystax -> objectSyntax_PR_application_wide 
      (*varbind).choice.choice.value.choice.application_wide.present = 5; // 5 for applicationSysntax_PR_unsigned_integer_value 
      //assign value
      if (index == 5 && *pingDone == 0) {
	 //long int tempStartExpt = 1;
	 //INTEGER_t tempInt; 
	 //asn_long2INTEGER(&tempInt, tempStartExpt);
	 (*varbind).choice.choice.value.choice.application_wide.choice.unsigned_integer_value = 1; 
      } else {
	 (*varbind).choice.choice.value.choice.application_wide.choice.unsigned_integer_value = pingMibArray[index].value.int_value; 
      }
   }
   else if (index == 7 || index == 8 || index == 9 || index == 10 || index == 11) { 
      if (*pingDone != 1) {
	 printf("\nERROR: noSuchInstance! (because of Ping)\n");
	 (*varbind).choice.present = 4; // 4 for varbind -> choice_PR_noSuchInstance
	 return;
      }
      //setup tag
      (*varbind).choice.present = 1; // 1 for varbind -> choice_PR_value 
      (*varbind).choice.choice.value.present = 2; // 2 for objectSystax -> objectSyntax_PR_application_wide 
      (*varbind).choice.choice.value.choice.application_wide.present = 5; // 5 for applicationSysntax_PR_unsigned_integer_value 
      //assign value
      (*varbind).choice.choice.value.choice.application_wide.choice.unsigned_integer_value = pingMibArray[index].value.int_value; 
   }

}

int* checkOID(ObjectName_t * varbindOID){
   int result[3];
   result[0] = 0;
   result[1] = 0;
   result[2] = 0;
   result[3] = 0;
   //result[0] for potiential noSuchObjec error; check prefix & oid length & object index: 0 for valid, 1 for invalid; 
   //result[1] for potiential noSuchInstance error; check OID instance: 0 for valid instance name, 1 for invalid;
   //result[2] for potiential noSuchObject error; check type of access: 0 for ReadOnly, 1 for ReadWrite;
   //result[3] for index of the mib var: index = *(oid_array+10) - 1;
   //printf("print out the OID\n");
   //asn_fprint(stdout, &asn_DEF_ObjectName, varbindOID);
   //convert the OID to an array of arcs:
   long arcs_size = OBJECT_IDENTIFIER_get_arcs(varbindOID, 0, sizeof(long), 0);
   long * oid_array = malloc(arcs_size * sizeof(*oid_array));
   OBJECT_IDENTIFIER_get_arcs(varbindOID, oid_array, sizeof(*oid_array), arcs_size);
   //printf("arcs_size: %ld\n", arcs_size);
   if (arcs_size != 12 && arcs_size != 11){
      result[0] = 1; // invalid oid, noSuchObject
      return result;
   }
   int i;
   for (i = 0; i < PREFIX_LENGTH; i++) {
      //printf("oid %ld\n", *(oid_array+i));
      //printf("prefix oid %ld\n", prefix[i]);
      if (*(oid_array+i) != prefix[i]) {
      	 result[0] = 1; // invalid prefix, noSuchObject
      	 return result;
      }
   }
   int objectIndex = *(oid_array+10);
   if (objectIndex < 1 || objectIndex > 12) { // should be 1 to 6
      result[0] = 1; // noSuchObject
      return result;
   }
   if (arcs_size == 11){
      result[1] = 1; // invalid instance nanme, noSuchInstance. Detect error oid like: pingSysName (without .0)
      return result;
   }
   if (*(oid_array+11) != 0) {
      //printf("oid last number is not 0\n");
      result[1] = 1; // invalid instance nanme, noSuchInstance
   }

   int indexInPingMibArray = objectIndex - 1;
   result[2] = pingMibArray[indexInPingMibArray].access; 
   result[3] = indexInPingMibArray;
   //printf("no error in OID checking; index of mib to fetch: %d\n", result[3]);
   return result;
}
 
int processSetRequest(SetRequest_PDU_t * pdus_choice_set_request) {
   int varBindCount = (*pdus_choice_set_request).variable_bindings.list.count; 
   //printf("varBindCount = %d\n", varBindCount);
   int i;
   int index;
   int indexes[varBindCount];
   for (i = 0; i < varBindCount; i++) {
      index = processSetVarBind(((*pdus_choice_set_request).variable_bindings.list.array)[i]);
      if (index == -4) {
      	 (*pdus_choice_set_request).error_status = 10; // 10 for wrongValue 
      }
      if (index == -1){
      	 (*pdus_choice_set_request).error_status = 17; // 17 for notWritable
      }
      else if (index == -2){
      	 (*pdus_choice_set_request).error_status = 18; // 12 for inconsistentName 
      }
      else if (index == -3){
      	 (*pdus_choice_set_request).error_status = 7; // 7 for inconsistentName 
      }
      if (index < 0) {
      	 // setup error_index
      	 (*pdus_choice_set_request).error_index = i+1; // error occured on the (i+1)th VarBind
      	 printf("\nERROR found in processSetVarBind, abort setting process\n");
      	 return -1;
      }
      indexes[i] = index;
      //printf("indexes[%d] = %d\n", i, indexes[i]);
   }
   printf("\nNo error found in any varBind, proceed to executeSetVarBind\n");
   executeSetVarBind(pdus_choice_set_request, varBindCount, indexes);
   return 0;

}

int processSetVarBind(VarBind_t * varbind) {
   // return value:
   //     errors: -1 for notWritable (-1 means negaive 1)
   //             -2 for inconsistentName
   //	          -3 for wrongType
   // if no error: return the accoording index of pingMibArray 

   //printf("present of varbind in SetMsg: %d\n", (*varbind).choice.present);
   //(*varbind).choice.present = 1;
   //printf("present of objectsyntax in SetMsg: %d\n", (*varbind).choice.choice.value.present);
   //printf("present of applicationSyntax in SetMsg: %d\n", (*varbind).choice.choice.value.choice.application_wide.present);
   //printf("present of simpleSyntax in SetMsg: %d\n", (*varbind).choice.choice.value.choice.simple.present);

   int * checkOIDresult = checkOID(&((*varbind).name));
   //printf("result[0] = %d\n", *checkOIDresult);
   //printf("result[1] = %d\n", *(checkOIDresult+1));
   //printf("result[2] = %d\n", *(checkOIDresult+2));

   int noSuchObject = *(checkOIDresult);  // 0 for no error, 1 for error
   int noSuchInstance = *(checkOIDresult+1); // 0 for error, 1 for error
   int accessLevel = *(checkOIDresult+2); // 0 for ReadOnly, 1 for ReadWrite
   int index = *(checkOIDresult+3); // according index of pingMibArray
   //printf("index again: %d\n", index);

   if (noSuchObject != 0 || accessLevel != 1){
      printf("\nERROR: notWritable error in Set\n");
      return -1;
   }
   if (noSuchInstance != 0){
      printf("\nERROR: inconsistentName error in Set\n");
      return -2;
   }
   // check if the value type 
   int typeOfSet;
   if (index == 3) { // 3 for pingTargetHostName. (1 for pingSysName, 2 for pingScrHostName will NEVER occur)
      typeOfSet = (*varbind).choice.choice.value.choice.simple.present; // 2 for simpleSysntax_PR_string_value 
      //printf("type: in simple: %d\n", typeOfSet);
      printf("firstExpt: %d\n", firstExpt);
      printf("pingDone: %d\n", *pingDone);

      //if (*pingDone == 0 && firstExpt != 1) {
      if (*pingDone == 0) {
	 printf("\nERROR: current ping is not over\n");
	 return -4;
      }
      if (typeOfSet != 2) {
	 printf("\nERROR: wrongType error in Set\n");
	 return -3;
      }
   }
//   else if (index == 0) { // 0 for pingSysUpTime, but this will NEVER occur, because notWritable error occurs first
//      typeOfSet = (*varbind).choice.choice.value.choice.application_wide.present; // 5 for applicationSysntax_PR_timeticks_value 
//      printf("type: in application: %d\n", typeOfSet);
//      if (typeOfSet != 5) {
//	 printf("wrongType error in Set\n");
//	 return -3;
//	 }
//   }
   else if (index == 4 || index == 5) { // 4 for pingProbeName, 5 for pingStartName
      typeOfSet = (*varbind).choice.choice.value.choice.application_wide.present; // 5 for applicationSysntax_PR_unsigned_integer_value 
      //printf("type: in appliaction: %d\n", typeOfSet);
      //if (*pingDone == 0 && firstExpt != 1) {
      if (*pingDone == 0) {
	 printf("\nERROR: current ping is not over\n");
	 return -4;
      }
      if (typeOfSet != 5) {
	 printf("\nERROR: wrongType error in Set\n");
	 return -3;
      }
   }
   // if no error, return index
   return index;
}

void executeSetVarBind(SetRequest_PDU_t * pdus_choice_set_request, int varBindCount, int indexes[]) {
   //asn_fprint(stdout, &asn_DEF_VarBind, ((*pdus_choice_set_request).variable_bindings.list.array)[0]);
   //asn_fprint(stdout, &asn_DEF_VarBind, ((*pdus_choice_set_request).variable_bindings.list.array)[1]);
   //asn_fprint(stdout, &asn_DEF_ObjectSyntax, &((*((*pdus_choice_set_request).variable_bindings.list.array)[1]).choice.choice.value));
   //asn_fprint(stdout, &asn_DEF_ApplicationSyntax, &((*((*pdus_choice_set_request).variable_bindings.list.array)[1]).choice.choice.value.choice.application_wide));
   //asn_fprint(stdout, &asn_DEF_TimeTicks, &((*((*pdus_choice_set_request).variable_bindings.list.array)[1]).choice.choice.value.choice.application_wide.choice.timeticks_value));
   //pingMibArray[0].value.time_value = (*((*pdus_choice_set_request).variable_bindings.list.array)[1]).choice.choice.value.choice.application_wide.choice.timeticks_value;
   int i; 
   for (i = 0; i < varBindCount; i++) {
      //printf("indexes[%d] = %d\n", i, indexes[i]);
      if (indexes[i] == 1 || indexes[i] == 2 || indexes[i] == 3){
	 pingMibArray[indexes[i]].value.oct_value = &((*((*pdus_choice_set_request).variable_bindings.list.array)[i]).choice.choice.value.choice.simple.choice.string_value);
      }
      else if (indexes[i] == 0){
	 pingMibArray[indexes[i]].value.time_value = (*((*pdus_choice_set_request).variable_bindings.list.array)[i]).choice.choice.value.choice.application_wide.choice.timeticks_value;
      }
      else if (indexes[i] == 4 || indexes[i] == 5) {
	 pingMibArray[indexes[i]].value.int_value = (*((*pdus_choice_set_request).variable_bindings.list.array)[i]).choice.choice.value.choice.application_wide.choice.unsigned_integer_value;
      }
   }
//   asn_fprint(stdout, &asn_DEF_Unsigned32, &(pingMibArray[0].value.int_value));
//   asn_fprint(stdout, &asn_DEF_OCTET_STRING, &(pingMibArray[1].value.oct_value));
//   asn_fprint(stdout, &asn_DEF_OCTET_STRING, &(pingMibArray[2].value.oct_value));
//   asn_fprint(stdout, &asn_DEF_OCTET_STRING, &(pingMibArray[3].value.oct_value));
//   asn_fprint(stdout, &asn_DEF_Unsigned32, &(pingMibArray[4].value.int_value));
//   asn_fprint(stdout, &asn_DEF_Unsigned32, &(pingMibArray[5].value.int_value));
}






