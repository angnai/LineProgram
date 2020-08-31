import sys 
import serial 
import time 
import signal 
import threading 
import pymysql 
from datetime import datetime
import subprocess 
import re
import os
			

line = [] #라인 단위로 데이터 가져올 리스트 변수
BLEline = []

port = '/dev/ttyUSB0' # 시리얼 포트 Zigbee
#port = 'COM3' # 시리얼 포트
port1 = '/dev/ttyUSB1' # 시리얼 포트 BLE 연결
#port1 = 'COM1' # 시리얼 포트

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
	global ser1
	
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
	
	
	sedD = []
	sedD.append(0x44)
	sedD.append(0x00)

	sedD.append(15)

	sedD.append(0x21)
	
	
	
	sedD.append(int(t.tm_year/256))
	sedD.append(int(t.tm_year%256))
	sedD.append(int(t.tm_mon))
	sedD.append(int(t.tm_mday))
	sedD.append(int(t.tm_hour))
	sedD.append(int(t.tm_min))
	sedD.append(int(t.tm_sec))
	
	sedD.append(int(valueT1/100))
	sedD.append(int(valueT1%100))

	sedD.append(int(valueT2/100))
	sedD.append(int(valueT2%100))

	sedD.append(int(valueT3/100))
	sedD.append(int(valueT3%100))
	
	sedD.append(0x43)
	
	ser1.write(sedD)

	setFlagT1 = False
	valueT1 = 0
	setFlagT2 = False
	valueT2 = 0
	setFlagT3 = False
	valueT3 = 0

	timeout_enable_flag = False
	TimeoutCnt = MaximumTimeout
	print("input finish")


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
	#print(data)

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



#본 쓰레드
def BLEreadThread_U1():
	global BLEline
	global exitThread
	global ser1
	
	BLEstxFlag = False
	# 쓰레드 종료될때까지 계속 돌림
	while not exitThread:
		try:
			#데이터가 있있다면
			for c in ser1.read():
				#line 변수에 차곡차곡 추가하여 넣는다.
				if BLEstxFlag:
					#line.append(chr(c))
					BLEline.append(bytes({c}))

				if c == 0x44: #라인의 시작을 만나면..
					BLEstxFlag = True
					#line 변수 초기화
					del BLEline[:]      

				if c == 0x43: #라인의 끝을 만나면..
					#데이터 처리 함수로 호출
					#print(line)
					BLEparsing_data(BLEline)

			time.sleep(0.01)          
				# 작업들
		except KeyboardInterrupt:
			# Ctrl+C 입력시 예외 발생
			print("angnai")
			sys.exit()


global BLEresult
global BLEnum
global Phonenum
global BLEFlag
global setTimeYMD
global setTimeHMS

BLEFlag = False
BLEnum = 0
Phonenum = 0
setTimeYMD = ""
setTimeHMS = ""

#데이터 처리할 함수
def BLEparsing_data(data):
	global con 
	global cur
	global sedD
	global ser1
	global BLEresult
	global Phonenum
	global BLEnum
	global BLEFlag
	global setTimeYMD
	global setTimeHMS

	if len(data) < 3:
		return


	nLen = data[1]
	nOp = data[2]

	sedD = []
	
	print(data)

	if (((nOp == bytes({0x01})) or (nOp == bytes({0x02}))) or (nOp == bytes({0x03}))):	
		if nOp == bytes({0x01}):
			BLEFlag = False
		elif nOp == bytes({0x02}):
			
			valueT1A = int.from_bytes(data[3],'big',signed=False) * 1000
			valueT1A += int.from_bytes(data[4],'big',signed=False) * 100
			valueT1A += int.from_bytes(data[5],'big',signed=False) * 10
			valueT1A += int.from_bytes(data[6],'big',signed=False) * 1
			
			valueT2A = int.from_bytes(data[7],'big',signed=False) * 10
			valueT2A += int.from_bytes(data[8],'big',signed=False) * 1
			
			valueT3A = int.from_bytes(data[9],'big',signed=False) * 10
			valueT3A += int.from_bytes(data[10],'big',signed=False) * 1

			setTimeYMD = ("{}-{}-{}".format(valueT1A,valueT2A,valueT3A))
			print(setTimeYMD)
		elif nOp == bytes({0x03}):
			valueT1A = int.from_bytes(data[3],'big',signed=False) * 10
			valueT1A += int.from_bytes(data[4],'big',signed=False) * 1
			
			valueT2A = int.from_bytes(data[5],'big',signed=False) * 10
			valueT2A += int.from_bytes(data[6],'big',signed=False) * 1
			
			valueT3A = int.from_bytes(data[7],'big',signed=False) * 10
			valueT3A += int.from_bytes(data[8],'big',signed=False) * 1

			setTimeYMD = ("{} {}:{}:{}".format(setTimeYMD,valueT1A,valueT2A,valueT3A))
			print(setTimeYMD)
			os.system('timedatectl set-ntp 0')
			os.system('/home/pi/LineProgram/SetTimeS.sh '+setTimeYMD)

		

		sedD.append(0x44)
		sedD.append(0x00)
		sedD.append(0x02)
		sedD.append(nOp[0])
		sedD.append(0x00)
		sedD.append(0x43)
		
		ser1.write(sedD)
	elif nOp == bytes({0x04}):

		sql="select * from data order by indexA"
		num = cur.execute(sql)
		
		nd1 = int.from_bytes(data[3],'big',signed=False)
		nd2 = int.from_bytes(data[4],'big',signed=False)
		nd3 = int.from_bytes(data[5],'big',signed=False)
		
		
		Phonenum = (nd1*(256*256)) + (nd2*256) + (nd3)

		print("======== Recv ========")
		print("MyNum = ",num)
		print("PhoneNum = ",Phonenum)

		if num < Phonenum:
			BLEnum = 0
		else: 
			BLEnum = num - Phonenum 

		print("======== Send ========")
		print("BLEnum = ",BLEnum)

		BLEresult = cur.fetchall()
		
		sedD.append(0x44)
		sedD.append(0x00)
		sedD.append(0x05)
		sedD.append(nOp[0])
		if BLEFlag == True:
			scnt00 = 0
		else:
			scnt00 = BLEnum

		#sedD.append(int(BLEnum/(256*256)))
		#sedD.append(int((BLEnum/256)%256))
		#sedD.append(int(BLEnum%256))
		sedD.append(int(scnt00/(256*256)))
		sedD.append(int((scnt00/256)%256))
		sedD.append(int(scnt00%256))
		sedD.append(0x00)
		sedD.append(0x43)

		ser1.write(sedD)
		
	elif nOp == bytes({0x05}):
		#sedD.append(0x44)
		#sedD.append(0x00)
		#sedD.append(15)
		#sedD.append(nOp[0])
		
		passCnt = 0

		if (BLEnum == 0) or (BLEFlag == True):
			return
			

		for v in BLEresult:
			if passCnt >= Phonenum:
				# Phonenum = 2 , 5 => 3,4,5
				# BLEnum = 3
				Phonenum = Phonenum+1

				sedD = []
				sedD.append(0x44)
				sedD.append(0x00)
				sedD.append(15)
				sedD.append(0x21)
				
				print(passCnt)
				print(v[0])
				t1 = datetime.strptime(str(v[0]),'%Y-%m-%d %H:%M:%S')
				
				sedD.append(int(t1.year/256))
				sedD.append(int(t1.year%256))
				sedD.append(int(t1.month%256))
				sedD.append(int(t1.day%256))
				sedD.append(int(t1.hour%256))
				sedD.append(int(t1.minute%256))
				sedD.append(int(t1.second%256))
				
				sedD.append(int(int(v[1])/100))
				sedD.append(int(int(v[1])%100))
				sedD.append(int(int(v[2])/100))
				sedD.append(int(int(v[2])%100))
				sedD.append(int(int(v[3])/100))
				sedD.append(int(int(v[3])%100))
				sedD.append(0x00)
				sedD.append(0x43)
				ser1.write(sedD)

				
				time.sleep(0.1)          
			

				#break

			passCnt = passCnt + 1

		BLEFlag = True
		#sedD.append(0x00)
		#sedD.append(0x43)
		#ser1.write(sedD)

	elif nOp == bytes({0x06}):
		if data[3] == bytes({0x01}):
			sedD.append(0x44)
			sedD.append(0x00)
			sedD.append(0x02)
			sedD.append(nOp[0])
			sedD.append(0x00)
			sedD.append(0x43)
		else:
			
			sedD.append(0x44)
			sedD.append(0x00)
			sedD.append(15)
			sedD.append(nOp[0])

			passCnt = 0
				
			for v in BLEresult:
				if passCnt >= Phonenum:
					# Phonenum = 2 , 5 => 3,4,5
					# BLEnum = 3
					Phonenum = Phonenum+1
					
					print(passCnt)
					print(v[0])
					t1 = datetime.strptime(str(v[0]),'%Y-%m-%d %H:%M:%S')
					
					sedD.append(int(t1.year/256))
					sedD.append(int(t1.year%256))
					sedD.append(int(t1.month%256))
					sedD.append(int(t1.day%256))
					sedD.append(int(t1.hour%256))
					sedD.append(int(t1.minute%256))
					sedD.append(int(t1.second%256))
					
					sedD.append(int(int(v[1])/100))
					sedD.append(int(int(v[1])%100))
					sedD.append(int(int(v[2])/100))
					sedD.append(int(int(v[2])%100))
					sedD.append(int(int(v[3])/100))
					sedD.append(int(int(v[3])%100))
					break

				passCnt = passCnt + 1

			sedD.append(0x00)
			sedD.append(0x43)
			ser1.write(sedD)

	print(sedD)

if __name__ == "__main__":
	global ser1
	#종료 시그널 등록
	#signal.signal(signal.SIGINT, handler)

	#con = pymysql.connect(host="angnai.duckdns.org", port=6082, user="root", password="1234",
    #                   db='test', charset='utf8')
	con = pymysql.connect(host="localhost", user='root', password='1234', port=3306, db='test', charset='utf8')
	cur = con.cursor()

	#시리얼 열기
	ser = serial.Serial(port, baud, timeout=0)
	ser1 = serial.Serial(port1, baud, timeout=0)



	#시리얼 읽을 쓰레드 생성
	thread2 = threading.Thread(target=RequestThread, args=(ser,))
	thread3 = threading.Thread(target=timeoutThread, args=())
	thread = threading.Thread(target=readThread_U1, args=(ser,))

	
	thread4 = threading.Thread(target=BLEreadThread_U1, args=())

	#시작!
	thread.start()
	thread4.start()
