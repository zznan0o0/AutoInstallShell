from py_zipkin.zipkin import zipkin_span, create_http_headers_for_new_span
import requests

def http_transport(encoded_span):
    # encoding prefix explained in https://github.com/Yelp/py_zipkin#transport
    #body = b"\x0c\x00\x00\x00\x01"+encoded_span
    body=encoded_span
    zipkin_url="http://192.168.10.89:9411/api/v2/spans"
    #zipkin_url = "http://{host}:{port}/api/v1/spans".format(
     #   host=app.config["ZIPKIN_HOST"], port=app.config["ZIPKIN_PORT"])
    headers = {"Content-Type": "application/x-thrift"}

    # You'd probably want to wrap this in a try/except in case POSTing fails
    print(headers)
    r=requests.post(zipkin_url, data=body, headers=headers)
    print(type(encoded_span))
    print(encoded_span)
    print(body)
    print(r)
    print(r.content)

zipkin_span(service_name='pyservice', span_name='/client', transport_handler=http_transport, port=8084, sample_rate=0.05)

