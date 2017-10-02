server {
	listen 80; listen [::]:80;
	server_name monitoring.jo0lz.nl;
	return 301 https://$host$request_uri;
}

server {
	listen 443 ssl http2; listen [::]:443 ssl http2;
	server_name monitoring.jo0lz.nl;

	index index.php;

        ssl_certificate /etc/letsencrypt/live/jo0lz.nl-0001/fullchain.pem;
        ssl_certificate_key /etc/letsencrypt/live/jo0lz.nl-0001/privkey.pem;
        ssl_dhparam /etc/ssl/certs/dhparam.pem;
        ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
        ssl_prefer_server_ciphers on;
        ssl_session_cache shared:SSL:10m;
        ssl_ciphers EECDH+CHACHA20:EECDH+AES128:RSA+AES128:EECDH+AES256:RSA+AES256:EECDH+3DES:RSA+3DES:!MD5;

        http2_idle_timeout 5m; # up from 3m default

        root /opt/librenms/html;

        access_log /opt/librenms/logs/access_log;
        error_log /opt/librenms/logs/error_log;

        gzip on;
        gzip_types text/css application/x-javascript text/richtext image/svg+xml text/plain text/xsd text/xsl text/xml image/x-icon;

        location / {
                try_files $uri $uri/ @librenms;
        }
	location ~ \.php {
                include fastcgi.conf;
                fastcgi_split_path_info ^(.+\.php)(/.+)$;
		fastcgi_pass unix:/run/php/php7.1-fpm.sock;
               # fastcgi_pass 127.0.0.1:9000;
        }

        location ~ /\.ht {
                deny all;
        }

        location @librenms {
                rewrite api/v0(.*)$ /api_v0.php/$1 last;
                rewrite ^(.+)$ /index.php/$1 last;
        }
}
