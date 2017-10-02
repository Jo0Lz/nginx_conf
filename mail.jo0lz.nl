server {
        listen 80; listen [::]:80;
        server_name mail.jo0lz.nl autodiscover.jo0lz.nl autoconfig.jo0lz.nl;
        return 301 https://$host$request_uri;
}

server {
        listen 443 ssl http2; listen [::]:443 ssl http2;
        server_name mail.jo0lz.nl autodiscover.jo0lz.nl autoconfig.jo0lz.nl;

        ssl_certificate /etc/letsencrypt/live/jo0lz.nl-0001/fullchain.pem;
        ssl_certificate_key /etc/letsencrypt/live/jo0lz.nl-0001/privkey.pem;
        ssl_dhparam /etc/ssl/certs/dhparam.pem;
        ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
        ssl_prefer_server_ciphers on;
        ssl_session_cache shared:SSL:10m;
        ssl_ciphers EECDH+CHACHA20:EECDH+AES128:RSA+AES128:EECDH+AES256:RSA+AES256:EECDH+3DES:RSA+3DES:!MD5;

        access_log /var/log/nginx/mail_jo0lz_nl_access.log;
        error_log /var/log/nginx/mail_jo0lz_nl_error.log;
        error_page 404 /404.html;
        error_page 500 502 503 504 /50x.html;

        location / {
                proxy_pass https://192.168.178.102;
        }
}
