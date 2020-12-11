from flask import request
import requests
from flask import Flask
from py_zipkin.zipkin import zipkin_span,ZipkinAttrs
import time


app = Flask(__name__)
app.config.update({
    "ZIPKIN_HOST":"127.0.0.1",
    "ZIPKIN_PORT":"9411",
    "APP_PORT":7002,
    # any other app config-y things
})


def do_stuff():
    print(1)
    return
    time.sleep(2)
    with zipkin_span(service_name='service2', span_name='service2_db_search'):
        db_search()
    return 'OK'


def db_search():
   
    print("Database version : 1" )

def http_transport(encoded_span):
    # encoding prefix explained in https://github.com/Yelp/py_zipkin#transport
    #body = b"\x0c\x00\x00\x00\x01" + encoded_span
    body=encoded_span
    zipkin_url="http://127.0.0.1:9411/api/v1/spans"
    #zipkin_url = "http://{host}:{port}/api/v1/spans".format(
    #    host=app.config["ZIPKIN_HOST"], port=app.config["ZIPKIN_PORT"])
    headers = {"Content-Type": "application/x-thrift"}

    # You'd probably want to wrap this in a try/except in case POSTing fails
    requests.post(zipkin_url, data=body, headers=headers)


@app.route('/service1/')
def index():
    print(request.headers)
    with zipkin_span(
        service_name='service2',
        zipkin_attrs=ZipkinAttrs(
            trace_id=request.headers['X-B3-TraceID'],
            span_id=request.headers['X-B3-SpanID'],
            parent_span_id=request.headers['X-B3-ParentSpanID'],
            flags=request.headers['X-B3-Flags'],
            is_sampled=request.headers['X-B3-Sampled'],
        ),
        span_name='index_service2',
        transport_handler=http_transport,
        port=7002,
        sample_rate=100, #0.05, # Value between 0.0 and 100.0
    ):
        do_stuff()
    return 'OK', 200

if __name__=='__main__':
    app.run(host="0.0.0.0",port=7002,debug=True)