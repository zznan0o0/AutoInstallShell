# pip install apollo-client
from pyapollo.apollo_client import ApolloClient
import time

# ac = ApolloClient(app_id='bruce_test', config_server_url='http://106.54.227.205:8090')
# ac = ApolloClient(app_id='bruce_test', config_server_url='http://localhost:8080')
# ac = ApolloClient(app_id='SampleApp', config_server_url='http://192.168.10.89:8080')
ac = ApolloClient(app_id='bruce_test', config_server_url='http://192.168.10.89:8090', cache_file_path="./cache_data")
ac.start()
print(ac.get_value('a'))

while True:
    print(ac.get_value('a'))
    time.sleep(3)
