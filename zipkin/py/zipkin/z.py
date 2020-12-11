import requests
from py_zipkin.zipkin import zipkin_span,create_http_headers_for_new_span
import time
from py_zipkin import Encoding
from py_zipkin import Kind
from py_zipkin.request_helpers import create_http_headers

def do_stuff():
    headers = create_http_headers()
    print(headers)
    res = requests.get('http://localhost:6000/service1/s1', headers=headers)
    # res = requests.get('http://localhost:6000/service1/s2', headers=headers)
    print(res.text)
    return 'OK'

def do_stuff2():
    headers = create_http_headers()
    print(headers)
    # res = requests.get('http://localhost:6000/service1/s1', headers=headers)
    # res = requests.get('http://localhost:6000/service1/s2', headers=headers)
    res = requests.get('http://192.168.10.104:7041/values/Get2/11', headers=headers)
    print(res.text)
    return 'OK'

def http_transport(encoded_span):
    print('http_transport')
    # print(encoded_span)
    # encoding prefix explained in https://github.com/Yelp/py_zipkin#transport
    #body = b"\x0c\x00\x00\x00\x01"+encoded_span
    body=encoded_span
    # zipkin_url="http://127.0.0.1:9411/api/v2/spans"
    zipkin_url="http://119.29.33.65:9411/api/v2/spans"
    #zipkin_url = "http://{host}:{port}/api/v1/spans".format(
     #   host=app.config["ZIPKIN_HOST"], port=app.config["ZIPKIN_PORT"])
    headers = {"Content-Type": "application/x-thrift"}

    # You'd probably want to wrap this in a try/except in case POSTing fails
    r=requests.post(zipkin_url, data=body, headers=headers)
    print(r.text)

with zipkin_span(
    service_name='webapp',
    span_name='index',
    transport_handler=http_transport,
    port=7000,
    # kind=Kind.CLIENT,
    sample_rate=100, #0.05, # Value between 0.0 and 100.0
    encoding=Encoding.V2_JSON,
    kind=Kind.SERVER
):
    with zipkin_span(service_name='webapp', span_name='/s1', encoding=Encoding.V2_JSON, kind=Kind.CLIENT):
        do_stuff()

    with zipkin_span(service_name='webapp', span_name='/s2', encoding=Encoding.V2_JSON, kind=Kind.CLIENT):
        do_stuff2()