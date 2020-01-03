FILENAME = consul.zip
DOWNLOAD_URL = https://releases.hashicorp.com/consul/1.6.2/consul_1.6.2_linux_amd64.zip
UNZIP_FILE = consul


rm -rf /Download/${UNZIP_FILE}
rm -rf /Download/${FILENAME} &&  mkdir -p  /Download
curl -L ${DOWNLOAD_URL} -o /Download/${FILENAME}
unzip /Download/${FILENAME}
mv consul /usr/local/bin/
consul -v