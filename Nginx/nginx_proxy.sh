echo "server {
        listen       80;
        server_name  www.b.com;
        client_max_body_size 10M;
        location / {
            proxy_pass http://127.0.0.1:8088;
            proxy_set_header Host $proxy_host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header Via "nginx";
        }   
}
" >> /etc/nginx/site-avaliable/default.conf