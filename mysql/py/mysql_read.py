import pymysql
import datetime
import threading
import time

ip_arr = ['192.168.10.157', '192.168.10.178', '192.168.10.190']

start_time = datetime.datetime.now()
length = 0

sql = "select * from tb_team limit %s, 10000"

def read(i, index):
  global length
  con = pymysql.connect(database='db_jubo', user='root', password='root', host=ip_arr[index], port=3306, cursorclass=pymysql.cursors.DictCursor,charset="utf8")
  cur = con.cursor()
  cur.execute(sql % ( i*10000))
  data = cur.fetchall()
  length += len(data) 
  cur.close()
  con.close()


thre_arr = []
for i in range(100):
  t = threading.Thread(target=read, args=(i, i%3, ))
  thre_arr.append(t)

for v in thre_arr:
  v.start()

for v in thre_arr:
  v.join()

end_time = datetime.datetime.now()
print(end_time - start_time)
print(length)
  

