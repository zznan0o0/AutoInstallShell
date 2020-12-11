from flask import request
import requests
from flask import Flask
from py_zipkin.zipkin import zipkin_span,ZipkinAttrs, create_http_headers_for_new_span
import time
from py_zipkin import Encoding
from py_zipkin import Kind
from py_zipkin.request_helpers import create_http_headers

app = Flask(__name__)
app.config.update({
    "ZIPKIN_HOST":"127.0.0.1",
    "ZIPKIN_PORT":"9411",
    "APP_PORT":6000,
    # any other app config-y things
})

def do_stuff():
    headers = create_http_headers()
    # res = requests.get('http://localhost:6000/service1/s1', headers=headers)
    res = requests.get('http://localhost:6001/service2/s3', headers=headers)
    print(res.text)
    return 'OK'

# def do_stuff():
#     time.sleep(2)
#     with zipkin_span(service_name='service1', span_name='service1_db_search'):
#         db_search()
#     return 'OK'


def db_search():
   
    print("Database version : 1" )

def http_transport(encoded_span):
    # encoding prefix explained in https://github.com/Yelp/py_zipkin#transport
    #body = b"\x0c\x00\x00\x00\x01" + encoded_span
    body=encoded_span
    # zipkin_url="http://127.0.0.1:9411/api/v2/spans"
    zipkin_url="http://119.29.33.65:9411/api/v2/spans"

    #zipkin_url = "http://{host}:{port}/api/v1/spans".format(
    #    host=app.config["ZIPKIN_HOST"], port=app.config["ZIPKIN_PORT"])
    headers = {"Content-Type": "application/x-thrift"}

    # You'd probably want to wrap this in a try/except in case POSTing fails
    requests.post(zipkin_url, data=body, headers=headers)


@app.route('/service1/')
def index():
    print(request.headers)
    with zipkin_span(
        service_name='service1',
        zipkin_attrs=ZipkinAttrs(
            trace_id=request.headers['X-B3-TraceID'],
            span_id=request.headers['X-B3-SpanID'],
            parent_span_id=request.headers['X-B3-ParentSpanID'],
            flags=request.headers['X-B3-Flags'],
            is_sampled=request.headers['X-B3-Sampled'],
        ),
        span_name='/get',
        transport_handler=http_transport,
        port=6000,
        sample_rate=100, #0.05, # Value between 0.0 and 100.0
        encoding=Encoding.V2_JSON
    ):
        pass
        # with zipkin_span(service_name='service1', span_name='service1_do_stuff'):
        #     do_stuff()
    return 'OK', 200

@app.route('/service1/s2')
def index1():
    print(request.headers)
    with zipkin_span(
        service_name='service1',
        zipkin_attrs=ZipkinAttrs(
            trace_id=request.headers['X-B3-TraceID'],
            span_id=request.headers['X-B3-SpanID'],
            parent_span_id=request.headers['X-B3-ParentSpanID'],
            flags=request.headers['X-B3-Flags'],
            is_sampled=request.headers['X-B3-Sampled'],
        ),
        span_name='/s2',
        transport_handler=http_transport,
        port=6000,
        sample_rate=100, #0.05, # Value between 0.0 and 100.0
        encoding=Encoding.V2_JSON,
        kind=Kind.SERVER
    ):
        pass
        # with zipkin_span(service_name='service1', span_name='service1_do_stuff'):
        #     do_stuff()
    return 'OK', 200

@app.route('/service1/s1')
def index2():
    print(request.headers)
    with zipkin_span(
        service_name='service1',
        zipkin_attrs=ZipkinAttrs(
            trace_id=request.headers['X-B3-TraceID'],
            span_id=request.headers['X-B3-SpanID'],
            parent_span_id=request.headers['X-B3-ParentSpanID'],
            # flags=request.headers['X-B3-Flags'],
            flags='0',
            is_sampled=request.headers['X-B3-Sampled'],
        ),
        span_name='/s1',
        transport_handler=http_transport,
        port=6000,
        sample_rate=100, #0.05, # Value between 0.0 and 100.0
        encoding=Encoding.V2_JSON,
        kind=Kind.SERVER
    ):
        # do_stuff()
        with zipkin_span(service_name='service1', span_name='/s3', encoding=Encoding.V2_JSON, kind=Kind.CLIENT):
            do_stuff()
    return 'OK', 200

if __name__=='__main__':
    app.run(host="0.0.0.0",port=6000,debug=True)