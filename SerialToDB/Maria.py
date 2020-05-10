import pymysql
 
con = pymysql.connect(host="angnai.duckdns.org", port=6082, user="root", password="1234",
                       db='test', charset='utf8')
 
 
cur = con.cursor()
 
#테이블 생성
#sql="create table sabjill(" \
#    "title varchar(100)," \
#    "content text," \
#    "primary key (title))"
 
#cur.execute(sql)
#con.commit()

#데이터 입력
#sql="insert into sabjill values ('제목1','내용1')"
#cur.execute(sql)
#con.commit()

#데이터 검색
#sql="select * from sabjill"
#num = cur.execute(sql)
#print(num)
 
#result = cur.fetchall()
#for v in result:
#    print("제목 : {} 내용 : {}".format(v[0],v[1]))
 
 #데이터 삭제
#sql = "delete from sabjill"
#cur.execute(sql)
#con.commit()
 
 
#데이터 검색 
sql = "select * from sabjill where title like %s"
cur.execute(sql,'제%')
result = cur.fetchall()
for v in result:
    print("날짜 : {} 데이터1 : {}".format(v[0],v[1]))
