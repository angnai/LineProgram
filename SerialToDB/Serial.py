import sys
import serial
import time
import signal
import threading
import pymysql
 

 

line = [] #라인 단위로 데이터 가져올 리스트 변수

port = 'COM6' # 시리얼 포트
baud = 9600 # 시리얼 보드레이트(통신속도)

exitThread = False   # 쓰레드 종료용 변수


#쓰레드 종료용 시그널 함수
def handler(signum, frame):
	extThread = True


#데이터 처리할 함수
def parsing_data(data):
	# 리스트 구조로 들어 왔기 때문에
	# 작업하기 편하게 스트링으로 합침
	tmp1 = ''.join(data[0:2])
	tmp2 = ''.join(data[2:10])

	#데이터 입력
	sql="insert into test values (\'" + tmp1 + "\',\'" + tmp2 + "\')"
	cur.execute(sql)
	con.commit()
	
	#출력!
	print(tmp1)
	print(tmp2)

#본 쓰레드
def readThread(ser):
	global line
	global exitThread
	global con 
	global cur
	
	con = pymysql.connect(host="angnai.duckdns.org", port=6082, user="root", password="1234",
                       db='test', charset='utf8')
	cur = con.cursor()

	stxFlag = False
	# 쓰레드 종료될때까지 계속 돌림
	while not exitThread:
		try:
			#데이터가 있있다면
			for c in ser.read():
				#line 변수에 차곡차곡 추가하여 넣는다.
				if stxFlag:
					line.append(chr(c))
				
				if c == 0x02: #라인의 시작을 만나면..
					stxFlag = True
					#line 변수 초기화
					del line[:]      

				if c == 0x03: #라인의 끝을 만나면..
					#데이터 처리 함수로 호출
					#print(line)
					parsing_data(line)

			time.sleep(0.01)          
				# 작업들
		except KeyboardInterrupt:
			# Ctrl+C 입력시 예외 발생
			print("angnai")
			sys.exit()

if __name__ == "__main__":
	#종료 시그널 등록
	#signal.signal(signal.SIGINT, handler)

	#시리얼 열기
	ser = serial.Serial(port, baud, timeout=0)

	#시리얼 읽을 쓰레드 생성
	thread = threading.Thread(target=readThread, args=(ser,))

	#시작!
	thread.start()