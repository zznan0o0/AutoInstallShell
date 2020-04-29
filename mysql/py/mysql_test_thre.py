import pymysql
import datetime
import threading
import time

start_time = datetime.datetime.now()

def insert10w(j):
  data = []
  for i in range(10000):
    data.append(('name%s' % (i), 'position%s' % (i), 'expression%s' % (i)))

  sql = "insert into tb_team (name, position, expression) values (%s, %s, %s)"
  con = pymysql.connect(database='db_jubo', user='root', password='root', host='192.168.10.157', port=3306, cursorclass=pymysql.cursors.DictCursor,charset="utf8")
  cur = con.cursor()
  cur.executemany(sql, data)

  con.commit()
  cur.close()
  con.close()
  print(j)

thre_arr = []

for i in range(100):
  t = threading.Thread(target=insert10w, args=(i, ))
  thre_arr.append(t)

for v in thre_arr:
  v.start()

for v in thre_arr:
  v.join()

end_time = datetime.datetime.now()
print(end_time - start_time)
