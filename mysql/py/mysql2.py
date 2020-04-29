import pymysql
import datetime

data = []
for i in range(10000):
  data.append(('name%s' % (i), 'position%s' % (i), 'expression%s' % (i)))

sql = "insert into tb_team (name, position, expression) values (%s, %s, %s)"

start_time = datetime.datetime.now()
con = pymysql.connect(database='db_jubo', user='root', password='root', host='192.168.10.157', port=3306, cursorclass=pymysql.cursors.DictCursor,charset="utf8")
cur = con.cursor()
for i in range(100):
  cur.executemany(sql, data)
  con.commit()
  
cur.close()
con.close()
end_time = datetime.datetime.now()
print(end_time - start_time)
