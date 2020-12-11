'''
Author your name
Date 2020-11-05 104109
LastEditTime 2020-11-05 113811
LastEditors Please set LastEditors
Description In User Settings Edit
FilePath eurekapython3eureka.py
'''
#!usrbinenv python3
# -- coding UTF-8 --
import string
import json

import tornado.web
import py_eureka_client.eureka_client as eureka_client
from tornado.options import define, options

#当前服务监听的端口
define(port, default=83, help=run on the given port, type=int)
#当前在eureka中注册的名称
define(appName, default='springbootService', help=app name in eureka, type=string)


class IndexHandler(tornado.web.RequestHandler)
    def get(self)
        self.write('[GET] python server...')

class Hello(tornado.web.RequestHandler)
    def post(self)
        # name = self.get_body_argument('name')
        result = {
            result Success,
            data ServicePythonWelcome !,
            cntPage 0,
            cntData 0
        }
        
        self.write(result)

def eurekaclient()

    tornado.options.parse_command_line()
    #注册eureka服务
    eureka_client.init(eureka_server=http192.168.10.1735000eureka,
                                       app_name=options.appName,
                                       instance_port=options.port,
                                       # 调用其他服务时的高可用策略，可选，默认为随机
                                       ha_strategy=eureka_client.HA_STRATEGY_RANDOM,
                       data_center_name='MyOwn'
                       )
    app = tornado.web.Application(handlers=[(r, IndexHandler), (rservicehello, Hello)])
    http_server = tornado.httpserver.HTTPServer(app)
    http_server.listen(options.port)
    tornado.ioloop.IOLoop.instance().start()
    print(eureka exec)

if __name__ == __main__
    eurekaclient()