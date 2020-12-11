import string
import json

import tornado.web
from tornado.options import define, options
from py_zipkin.zipkin import create_http_headers_for_new_span

#当前服务监听的端口
define("port", default=8083, help="run on the given port", type=int)
#当前在eureka中注册的名称
define("appName", default='springbootService', help="app name in eureka", type=string)


class IndexHandler(tornado.web.RequestHandler):
    def get(self):
        self.write('[GET] python server...')


class Health(tornado.web.RequestHandler):
    def get(self):
        self.write({"status":"UP"})

class Hello(tornado.web.RequestHandler):
    def post(self):
        # name = self.get_body_argument('name')
        result = {
            "result": "Success",
            "data": "ServicePython:Welcome !",
            "cntPage": 0,
            "cntData": 0
        }
        
        self.write(result)

def eurekaclient():

    tornado.options.parse_command_line()
    #注册eureka服务
    # eureka_client.init(eureka_server="http://192.168.10.173:5000/eureka/",
    #                                    app_name=options.appName,
    #                                    instance_port=options.port,
    #                                    # 调用其他服务时的高可用策略，可选，默认为随机
    #                                    ha_strategy=eureka_client.HA_STRATEGY_RANDOM,
    #                    data_center_name='MyOwn'
    #                    )
    app = tornado.web.Application(handlers=[(r"/", IndexHandler), (r"/service/hello", Hello), (r"/health", Health)])
    http_server = tornado.httpserver.HTTPServer(app)
    http_server.listen(options.port)
    tornado.ioloop.IOLoop.instance().start()
    print("eureka exec")

if __name__ == "__main__":
    eurekaclient()