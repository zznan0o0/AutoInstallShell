# pip install apollo-client
# ac.get_value('xxxx)
from pyapollo.apollo_client import ApolloClient

apollo = None
def init(app_id, config_server_url='http://localhost:8090', cache_file_path='./cache_data', cycle_time=30):
    ac = ApolloClient(app_id=app_id, config_server_url=config_server_url, cache_file_path=cache_file_path, cycle_time=cycle_time)
    ac.start()
    global apollo
    apollo = ac
    
