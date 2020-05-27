/*******************************************************************************
1. Project Name     : 
2. Author	        : 
3. Company	        : 
4. A Drafter	    : Christopher, Lee ( DongSeok, Lee )
5. Homepage	        : 
6. Email	        : strchrislee@gmail.com
7. Phone Number     : 010-2464-0102
8. Filename	        : ChrisTimerEbd.c
9. Version	        : 1.0
10. CreatedDate     : 2020/01/26
11. ModifiedDate	: 
12. License	        : 
13. MCU Type	    :
14. Clock Frequency : 
15. Add Source Name :
16. Compiler	    : 
17. SubMenu	        :
18. Note            :
*******************************************************************************/
#include <stdio.h>
#include <string.h>
#include "ChrisHost_DCComm.h"

//extern System_t System;
DCComm_t DCComm;

#define DEF_DCCOMM_UART_DEBUG_ENABLE    1

#define SEND_USER_COMM_TEMP    UART2



//=============================================================================
// Function Name: DCComm_Chk_CSum
// Description: OPCODE <-> DN 까지의 단순 CSUM
// input: UART Recv 1byte
// output: none
// 본 함수는 10ms 이내의 주기로 지속적으로 호출 해주세요.
//=============================================================================
uint8_t DCComm_Chk_CSum(uint8_t *u8Data){
    uint8_t u8CSumtemp;
    uint8_t u8Length;
    u8CSumtemp=0;
    u8Data++;//2nd SYNC is not include csum
    u8Length = *u8Data++;    //Length

    do{
        u8CSumtemp += *u8Data++;
        u8Length--;
    }while(u8Length!=1); //Length 1까지 반복

    //if(DEF_DCCOMM_UART_DEBUG_ENABLE==1)return 1;
    if(DCComm.Flag.bDCCommDBGEnable)return 1;       //DEBUG Message로 Enable 한 후부터,

    if(*u8Data == u8CSumtemp)return 1;
    else return 0;
    
}


//=============================================================================
// Function Name: DCComm_Recv_MSG_Parser
// Description: 1바이트씩, Parser에 넣으면 정상 패킷일경우 DCComm.Flag.bRxFinish을 1로 켜줌.
// input: UART Recv 1byte
// output: none
// STX Data는 저장 안함.
//=============================================================================
int DCComm_Recv_MSG_Parser(uint8_t u8Data){
        if (DCComm.u8RxStateMachine==ENUM_DCCOMM_STATE_STX && u8Data==DEF_DCCOMM_STX) {                                    //STX            
            DCComm.u8RxBuffIndex=0;
            //DCComm.u8RxBuff[DCComm.u8RxBuffIndex++] = u8Data;   //STX IS NOT SAVE BECAUSE OF CHKSUM
            DCComm.u8RxStateMachine = ENUM_DCCOMM_STATE_2NDSYNC;
            //timeout enable if timeout use
        }else if(DCComm.u8RxStateMachine==ENUM_DCCOMM_STATE_2NDSYNC ){                                                     //2ndSync
            DCComm.u8RxStateMachine=ENUM_DCCOMM_STATE_LENGTH;
            DCComm.u8RxBuff[DCComm.u8RxBuffIndex++] = u8Data;                        
        }else if(DCComm.u8RxStateMachine==ENUM_DCCOMM_STATE_LENGTH){                                                     //LENGTH
            DCComm.u8RxStateMachine=ENUM_DCCOMM_STATE_DATA;
            DCComm.u8RxBuff[DCComm.u8RxBuffIndex++] = u8Data;                                          
            DCComm.u8RxDataIndex=u8Data;
        }else if (DCComm.u8RxStateMachine == ENUM_DCCOMM_STATE_DATA && DCComm.u8RxDataIndex != 1) {            //DATA START
            DCComm.u8RxBuff[DCComm.u8RxBuffIndex++] = u8Data;                
            DCComm.u8RxDataIndex--;
        }else if(DCComm.u8RxStateMachine==ENUM_DCCOMM_STATE_DATA && DCComm.u8RxDataIndex == 1){                //DATA FINISHED, CSUM HIGH 0
            DCComm.u8RxStateMachine=ENUM_DCCOMM_STATE_ETX;
            DCComm.u8RxBuff[DCComm.u8RxBuffIndex++]=u8Data;            
        }else if(DCComm.u8RxStateMachine==ENUM_DCCOMM_STATE_ETX && u8Data==DEF_DCCOMM_ETX){                //DATA LENGTH 0
            DCComm.u8RxBuff[DCComm.u8RxBuffIndex]=u8Data;
            DCComm.Flag.bRxFinish=1;                                      //UART RX Finish, Sucessful chksum start
            DCComm.u8RxStateMachine=ENUM_DCCOMM_STATE_STX;      
        }else{  //failed
			return -1;
            DCComm.u8RxStateMachine=ENUM_DCCOMM_STATE_STX;          
        }

		return 0;
}

//=============================================================================
// Function Name: DCComm_Recv_State_Control
// Description: UART Recv 가 정상적으로 수신됐을때, OPCODE에 맞춰 서브루틴을 호출하는 함수
// input: UART Recv 1byte
// output: none
// 본 함수는 10ms 이내의 주기로 지속적으로 호출 해주세요.
//=============================================================================
int DCComm_Recv_State_Control(void){  //Bypass �뵵
    uint8_t u8RxChksum[2];
    uint8_t u8BuffTemp[4];

    if (DCComm.Flag.bRxFinish) {
		DCComm.Flag.bRxFinish=0;    
    
        if (DCComm_Chk_CSum(DCComm.u8RxBuff)) {

            if(DCComm.u8RxBuff[DEF_DCCOMM_INDEX_2NDSYNC]==DEF_DCCOMM_2NDSYNC_NORMAL){

                switch (DCComm.u8RxBuff[DEF_DCCOMM_INDEX_DATA]) {
                case 0x01: //Pump On Off
                    printf("MSG 0x01\r\n");
					return 1;    
                    break;
                case 0x02:  //Gain �� ����
                    printf("MSG 0x02\r\n");
					return 2;                                
                    break;
                case 0x03:  //Graph �۽� ��û                
                    printf("MSG 0x03\r\n");
					return 3;
                    break;
                case 0x04: //Water Leven �۽� ���� ��û
                    printf("MSG 0x04\r\n");
					return 4;
                    break;
                case 0x05: //Get AI Value                
                    printf("MSG 0x05\r\n");
					return 5;
                    break;
                case 0x06: //Res AI Value
                    printf("MSG 0x06\r\n");
					return 6;
                    break;                
                }
            }
            else if(DCComm.u8RxBuff[DEF_DCCOMM_INDEX_2NDSYNC]==DEF_DCCOMM_2NDSYNC_DEBUG){
                switch (DCComm.u8RxBuff[DEF_DCCOMM_INDEX_DATA]) {
                case DEF_MSG_DBG_DEBUG_ENABLE: //
                    printf("DEBUG MSG 0x01\r\n");
                    if(DCComm.Flag.bDCCommDBGEnable==0)DCComm.Flag.bDCCommDBGEnable=1;
                    else DCComm.Flag.bDCCommDBGEnable=0;
					return 11;
                    break;               
                }                                
            }
        }else{
            return -3;
        }
		return -2;
    }
	return -4;
}

int main(int argc,void **argv)
{

	unsigned long i, framelen;
	unsigned char *n;

	framelen = atoi((char *)argv[1]);
	n = (unsigned char *)&argv[2][0];
	printf("data len = %d\r\n",framelen);
	DCComm_Recv_MSG_Parser(DEF_DCCOMM_STX);
	printf("%x ",DEF_DCCOMM_STX);
	
	for(i=0;i<framelen;i++)
	{
		printf("%x ",n[i]);
		if(DCComm_Recv_MSG_Parser(n[i]) < 0) return -1;
	}

	return DCComm_Recv_State_Control();

}