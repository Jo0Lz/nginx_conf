server {
	listen 80; listen [::]:80;
	server_name grafana.jo0lz.nl;
	return 301 https://$host$request_uri;
}

server {
	listen 443 ssl http2; listen [::]:443 ssl http2;
	server_name grafana.jo0lz.nl;

	root /usr/share/nginx/www;
	index index.html index.htm;

	ssl_certificate /etc/letsencrypt/live/jo0lz.nl-0001/fullchain.pem;
	ssl_certificate_key /etc/letsencrypt/live/jo0lz.nl-0001/privkey.pem;
	ssl_dhparam /etc/ssl/certs/dhparam.pem;
	ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
	ssl_prefer_server_ciphers on;
	ssl_session_cache shared:SSL:10m;
	ssl_ciphers EECDH+CHACHA20:EECDH+AES128:RSA+AES128:EECDH+AES256:RSA+AES256:EECDH+3DES:RSA+3DES:!MD5;

	http2_idle_timeout 5m;

	location / {
		proxy_pass http://localhost:3000/;
	}
}
