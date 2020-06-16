#!/usr/bin/python3
import pymysql
import datetime
import time
from random import *
import os
import mmap
import socket, threading
import re


def binder(client_socket, addr):
	print('Connected by', addr);
	try:
		while True:
			data = client_socket.recv(4);

			length = int.from_bytes(data, "little");
			if length == 0:
				client_socket.close()
				return


			data = client_socket.recv(length);
			
			msg = data.decode();
			
			print('Received from', addr, msg);
			
			if msg == "scan1":
				trans_str = data_read()

				length = len(trans_str);

				client_socket.sendall(length.to_bytes(4, byteorder="little"));
				client_socket.sendall(trans_str.encode());
				print('read scan1 success')

			elif msg[0:5] == "scan2":
				trans_str = data_search(msg[5:21])
				
				length = len(trans_str);
				client_socket.sendall(length.to_bytes(4, byteorder="little"));
				client_socket.sendall(trans_str.encode());
				print('read scan2 success')
			elif msg == 'scan3':
				trans_str = data_count()
				
				length = len(trans_str);
				client_socket.sendall(length.to_bytes(4, byteorder="little"));
				client_socket.sendall(trans_str.encode());
				print('read scan3 success')

			else:
				continue
	except:
		print("except : " , addr);
	finally:
		client_socket.close();

def data_count():
	sql = "SELECT COUNT(time) FROM data"
	num = cur.execute(sql)
	result = cur.fetchall()
	conn.commit()
	
	trans_str = ("{}\r\n".format(result))
	numbers = re.findall("\d+", trans_str)
	trans_str = ("{}".format(numbers))
	print("trans_str = ",trans_str)

	return trans_str[2:len(trans_str)-2]


def data_search(data):
	sql = "SELECT * FROM data WHERE time > %s LIMIT 10"
	num = cur.execute(sql,data)
	if num < 0:
		print("Input range1 error")
		return
	
	result = cur.fetchall()
	conn.commit()
	
	sql = "SELECT * FROM data WHERE time < %s order by time desc LIMIT %s"
	num += cur.execute(sql,(data,20-num))

	if num < 0:
		print("Input range2 error")
		return

	result = result + cur.fetchall()
	result_sort = sorted(result)
	print("count=",num)
	trans_str = ("{}\r\n".format(num))
	for v in result_sort:
		trans_str += ("{}\t{}\t{}\r\n".format(v[0],v[1],v[2]))
	
	conn.commit()
	return trans_str

def data_read():
	sql="select * from data order by time desc limit 20"
	num = cur.execute(sql)
	
	result = cur.fetchall()
	result_sort = sorted(result)
	print("count=",num)
	trans_str = ("{}\r\n".format(num))
	for v in result_sort:
		trans_str += ("{}\t{}\t{}\r\n".format(v[0],v[1],v[2]))

	conn.commit()
	return trans_str

if __name__ == "__main__":
	global loopf
	global conn
	global cur
	
	loopf = False


	while True:
		conn = pymysql.connect(host="angnai.duckdns.org", user='root', password='1234', port=6082, db='test', charset='utf8')
		cur = conn.cursor()
		

		
		server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM);
		server_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1);
		server_socket.bind(('', 9999));
		server_socket.listen();

		try:
			while True:
				client_socket, addr = server_socket.accept();
				th = threading.Thread(target=binder, args = (client_socket,addr));
				th.start();
		except:
			print("server");
		finally:
			server_socket.close();

		conn.close()
