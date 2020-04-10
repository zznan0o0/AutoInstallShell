apt-get install php7.4-fpm -y
vim /etc/php/7.4/fpm/php.ini

# 找到 cgi.fix_pathinfo=0 去注释改0
# 或者service
systemctl restart php7.4-fpm

# cp /etc/nginx/sites-available/default /etc/nginx/sites-available/mysite.com
# vim /etc/nginx/sites-available/mysite.com

echo "server {
        listen 80;
        listen [::]:80;

        root /home/dever/project/juboPSS/public;

        index index.php;

        server_name mysite.com www.mysite.com;

        location / {
                try_files $uri $uri/ /index.php?$query_string;
        }

        # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
        #
        location ~ \.php$ {
                include snippets/fastcgi-php.conf;
                fastcgi_pass unix:/run/php/php7.4-fpm.sock;
        }

        # deny access to .htaccess files, if Apache's document root
        # concurs with nginx's one
        #
        location ~ /\.ht {
                deny all;
        }
}" > default.conf

ln -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/

# systemctl restart nginx
service nginx restart
