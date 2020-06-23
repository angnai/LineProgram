import sys
import serial
import time
import signal
import threading
import pymysql
import datetime
import subprocess
import re

 

line = [] #라인 단위로 데이터 가져올 리스트 변수

port = '/dev/ttyUSB0' # 시리얼 포트
#port = 'COM2' # 시리얼 포트
baud = 115200 # 시리얼 보드레이트(통신속도)

exitThread = False   # 쓰레드 종료용 변수

sedD = []

setFlagT1 = False
setFlagT2 = False
setFlagT3 = False
valueT1 = 0
valueT2 = 0
valueT3 = 0

# 10ms 단위
MaximumTimeout = (5*60*100)

timeout_enable_flag = False
TimeoutCnt = MaximumTimeout

#쓰레드 종료용 시그널 함수
def handler(signum, frame):
	global extThread
	extThread = True

def data_count():
	sql = "SELECT COUNT(time) FROM data"
	num = cur.execute(sql)
	result = cur.fetchall()
	con.commit()
	
	trans_str = ("{}\r\n".format(result))
	numbers = re.findall("\d+", trans_str)
	trans_str = ("{}".format(numbers))
	# print("trans_str = ",trans_str)

	return trans_str[2:len(trans_str)-2]


def UpdateDBData():
	global setFlagT1
	global setFlagT2
	global setFlagT3
	global valueT1
	global valueT2
	global valueT3
	global timeout_enable_flag
	global TimeoutCnt
	
	nCount = data_count()
	t = time.localtime()
	timeA = (time.strftime('%Y-%m-%d %H:%M:%S', t))
	
	tmp1 = str(valueT1)
	tmp2 = str(valueT2)
	tmp3 = str(valueT3)
	count = str(nCount)

	#데이터 입력
	sql="insert into data values (\'" + timeA + "\',\'"  + tmp1 + "\',\'"  + tmp2 + "\',\'" + tmp3 + "\',\'"  + count + "\')"
	cur.execute(sql)
	con.commit()

	setFlagT1 = False
	valueT1 = 0
	setFlagT2 = False
	valueT2 = 0
	setFlagT3 = False
	valueT3 = 0

	timeout_enable_flag = False
	TimeoutCnt = MaximumTimeout


#데이터 처리할 함수
def parsing_data(data):
	global con 
	global cur
	global sedD
	global timeout_enable_flag
	global setFlagT1
	global setFlagT2
	global setFlagT3
	global valueT1
	global valueT2
	global valueT3
	

	nLen = data[1]
	nOp = data[2]

	sedD = []

	if nOp == bytes({0x30}):
		nT = int.from_bytes(data[3],'big',signed=False)
		#44 00 05 30 00 04 2c 60 43 	44 00 05 30 01 01 2c 5e 43 	44 00 05 30 02 06 2c 64 43 

		if nT == 0:
			if setFlagT1 == False:
				setFlagT1 = True
				timeout_enable_flag = True
				valueT1 = int.from_bytes(data[4],'big',signed=False) * 100
				valueT1 += int.from_bytes(data[5],'big',signed=False)
			else:
				UpdateDBData()
		elif nT == 1:
			if setFlagT2 == False:
				setFlagT2 = True
				timeout_enable_flag = True
				valueT2 = int.from_bytes(data[4],'big',signed=False) * 100
				valueT2 += int.from_bytes(data[5],'big',signed=False)
			else:
				UpdateDBData()
		elif nT == 2:
			if setFlagT3 == False:
				setFlagT3 = True
				timeout_enable_flag = True
				valueT3 = int.from_bytes(data[4],'big',signed=False) * 100
				valueT3 += int.from_bytes(data[5],'big',signed=False)
			else:
				UpdateDBData()
				
		

		if setFlagT1 == True and setFlagT2 == True and setFlagT3 == True:
			UpdateDBData()
		

#본 쓰레드
def readThread_U1(ser):
	global line
	global exitThread
	
	stxFlag = False
	# 쓰레드 종료될때까지 계속 돌림
	while not exitThread:
		try:
			#데이터가 있있다면
			for c in ser.read():
				#line 변수에 차곡차곡 추가하여 넣는다.
				if stxFlag:
					#line.append(chr(c))
					line.append(bytes({c}))

				if c == 0x44: #라인의 시작을 만나면..
					stxFlag = True
					#line 변수 초기화
					del line[:]      

				if c == 0x43: #라인의 끝을 만나면..
					#데이터 처리 함수로 호출
					#print(line)
					parsing_data(line)

			time.sleep(0.01)          
				# 작업들
		except KeyboardInterrupt:
			# Ctrl+C 입력시 예외 발생
			print("angnai")
			sys.exit()

def RequestThread(ser):
	global sedD
	global exitThread

	# 쓰레드 종료될때까지 계속 돌림
	while not exitThread:
		try:
			sedD = []
			sedD.append(0x44)
			sedD.append(0x00)
			sedD.append(0x02)
			sedD.append(0x01)
			sedD.append(0x01)
			sedD.append(0x43)
			
			sedD.append(0x44)
			sedD.append(0x00)
			sedD.append(0x02)
			sedD.append(0x02)
			sedD.append(0x02)
			sedD.append(0x43)
			
			sedD.append(0x44)
			sedD.append(0x00)
			sedD.append(0x02)
			sedD.append(0x03)
			sedD.append(0x03)
			sedD.append(0x43)
			
			ser.write(sedD)
			
			time.sleep(0.1)          
				# 작업들
		except KeyboardInterrupt:
			# Ctrl+C 입력시 예외 발생
			print("angnai")
			sys.exit()

def timeoutThread():
	global exitThread
	global con 
	global cur
	global timeout_enable_flag
	global TimeoutCnt

	
	# 쓰레드 종료될때까지 계속 돌림
	while not exitThread:
		try:
			if timeout_enable_flag == True:
				if TimeoutCnt == 0:
					UpdateDBData()
				else:
					TimeoutCnt = TimeoutCnt - 1



			time.sleep(0.01)
				# 작업들
		except KeyboardInterrupt:
			# Ctrl+C 입력시 예외 발생
			print("angnai")
			sys.exit()



if __name__ == "__main__":
	#종료 시그널 등록
	#signal.signal(signal.SIGINT, handler)

	#con = pymysql.connect(host="angnai.duckdns.org", port=6082, user="root", password="1234",
    #                   db='test', charset='utf8')
	con = pymysql.connect(host="localhost", user='root', password='1234', port=3306, db='test', charset='utf8')
	cur = con.cursor()

	#시리얼 열기
	ser = serial.Serial(port, baud, timeout=0)

	#시리얼 읽을 쓰레드 생성
	thread2 = threading.Thread(target=RequestThread, args=(ser,))
	thread3 = threading.Thread(target=timeoutThread, args=())
	thread = threading.Thread(target=readThread_U1, args=(ser,))

	#시작!
	thread.start()
