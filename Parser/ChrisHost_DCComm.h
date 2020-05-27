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

#ifndef __ChrisHost_DCComm_H__
#define __ChrisHost_DCComm_H__

#define uint8_t unsigned char
#define uint16_t unsigned int


#define DEF_DCCOMM_STX    0x44       //'D'
#define DEF_DCCOMM_ETX    0x43       //'C'

#define DEF_DCCOMM_2NDSYNC_NORMAL   0
#define DEF_DCCOMM_2NDSYNC_DEBUG    1

#define DEF_DCCOMM_INDEX_2NDSYNC    0
#define DEF_DCCOMM_INDEX_LENGTH    1
#define DEF_DCCOMM_INDEX_DATA      2

#define DEF_INDEX_PACKET_DATA0    4


//MESSAGE NORMAL
#define DEF_MSG_NOR_DEBUG_ENABLE    1


//MESAGE DEBUG
#define DEF_MSG_DBG_DEBUG_ENABLE    1

#define UARTBUFFSIZE    30


enum{    
    ENUM_DCCOMM_STATE_STX,
    ENUM_DCCOMM_STATE_2NDSYNC,
    ENUM_DCCOMM_STATE_LENGTH,
    ENUM_DCCOMM_STATE_DATA,
    ENUM_DCCOMM_STATE_CSUM,
    ENUM_DCCOMM_STATE_ETX,
};

typedef struct{
    uint8_t     UCTMotorEnable:1;
    uint8_t     resreved1:2;
    uint8_t     resreved2:1;       //��������
    uint8_t     resreved3:1;       //��������

    uint8_t     resreved4:1;      //����������
    uint8_t     resreved5:1;      //����������
    uint8_t     resreved6:1;      //����������
    uint8_t     resreved7:1;      //����������   
}Flag_t;

typedef struct{
    uint8_t     bDCCommDBGEnable:1;     //Debug Mode Enable // 1일경우 CSUM 검사를 안함. 
    uint8_t     bRxFinish:1;            //If this flag is 1, Rx complete, 
    uint8_t     bRxTimeoutFlag:1;       //If this flag is 1, RX Timeout occur // 넣어야함 //200524
    uint8_t     resreved3:1;

    uint8_t     resreved4:1;
    uint8_t     resreved5:1;
    uint8_t     resreved6:1;
    uint8_t     resreved7:1;
}DCComm_Flag_t;


typedef struct{    
  uint8_t      u8RxDataCnt;           //Rx Data ���� üũ  
  DCComm_Flag_t Flag;
        

  uint16_t      u8RxBuffIndex;          //Uart Rx Recv Buff Index
  uint16_t      u8RxDataIndex;          //Uart Rx Recv Data Buff Index ( LENGTH 값을 받아온 이후로 길이값 )
                                        
  uint8_t       u8RxStateMachine;       //for reference Uart RX State Machine Enum 

  uint16_t      u16RxTimeoutCnt;         //RX Timeout Down Count // 넣어야함 //200524  

  uint8_t       u8RS485T_R_Timeindex;   //RX�� TX �Ҷ� 100ms �� �� 100ms �Ŀ� RE/DE ���
  
  uint8_t       u8RxBuff[UARTBUFFSIZE];
  uint8_t       u8TxBuff[UARTBUFFSIZE];    //Uart Tx Buffer  

  uint16_t      u16TxSetIndex;          //Uart �۽� ������ �߰��� ���� �ε���
  uint16_t      u16TxIndex;             //Uart �۽��� ���� ���� üũ�� �ε���
  uint16_t      u16TxLength;            //Uart �۽Ű���
  uint8_t       u8UartTxStartFlag;      //If this value is 1, UART is working, ���� �޽��� �۽� �Ұ���     

  uint8_t       u8RxReadyFlag;          //If this flag is 1, Rx Parsing is ready. if this flag is 0, Rx Parsing is not ready.   //485 용도임
  uint8_t       u8Rx485TimeCnt;         //RX 수신후 485 보내기 위한 타임아웃
  uint8_t       u8Rx485Transing;        //485 송신중

}DCComm_t;


extern void UCT_Set_TransBuff_Clear(void);  //LCD Send Buff Clear
extern void UCT_Tran_Print_Value(void);     //LCD Send Buff, �ӽ� 
extern void UART1_HAL_Init(void);
extern void UCT_Send_Uart_Tx(void);
extern void UCT_Set_Pump_On_Off(uint8_t u8Data);
extern void UCT_Recv_MSG_Parser(uint8_t u8Data);
extern void UCT_Set_Temp_Threshold(uint16_t u16Data);
extern void UCT_Get_Water_Level(void);
extern void UCT_Recv_State_Control(void);


extern int DCComm_Recv_MSG_Parser(uint8_t u8Data);
extern int DCComm_Recv_State_Control(void);
extern uint8_t DCComm_Chk_CSum(uint8_t *u8Data);

#endif
