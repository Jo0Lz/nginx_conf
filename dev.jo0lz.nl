server {
	listen 80; listen [::]:80;
	server_name dev.jo0lz.nl;
	return 301 https://$host$request_uri;
}

server {
	listen 443 ssl http2; listen [::]:443 ssl http2;
	server_name dev.jo0lz.nl;
	root /var/www/dev;
	index index.php

	ssl_certificate /etc/letsencrypt/live/jo0lz.nl-0001/fullchain.pem;
	ssl_certificate_key /etc/letsencrypt/live/jo0lz.nl-0001/privkey.pem;
	ssl_dhparam /etc/ssl/certs/dhparam.pem;
	ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
	ssl_prefer_server_ciphers on;
	ssl_session_cache shared:SSL:10m;
	ssl_ciphers EECDH+CHACHA20:EECDH+AES128:RSA+AES128:EECDH+AES256:RSA+AES256:EECDH+3DES:RSA+3DES:!MD5;

	location = /favicon.ico {
                log_not_found off;
                access_log off;
        }

        location = /robots.txt {
                allow all;
                log_not_found off;
                access_log off;
        }

        location / {
                # This is cool because no php is touched for static content.
                # include the "?$args" part so non-default permalinks doesn't break when using query string
                try_files $uri $uri/ /index.php?$args;
        }

        location ~ \.php$ {
                #NOTE: You should have "cgi.fix_pathinfo = 0;" in php.ini
                include fastcgi.conf;
		fastcgi_pass unix:/var/run/php7.1-fpm.sock;
                fastcgi_intercept_errors on;
                fastcgi_pass php;
                fastcgi_buffers 16 16k;
                fastcgi_buffer_size 32k;
        }

        location ~* \.(js|css|png|jpg|jpeg|gif|ico)$ {
                expires max;
                log_not_found off;
        }
}


#	http2_idle_timeout 5m;

#        location ~ \.php$ {
#		try_files $uri $uri/ =404;
#               include snippets/fastcgi-php.conf;
#                fastcgi_pass unix:/run/php/php7.1-fpm.sock;
#	}
#

