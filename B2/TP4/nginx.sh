#!/bin/sh

VerifyNginx() {
    if which nginx >/dev/null 2>&1; then
        if ! systemctl is-active --quiet nginx; then
            echo "Starting nginx ..."
            systemctl start nginx
        fi

        if ! systemctl is-enabled --quiet nginx; then
            echo "Enabling nginx ..."
            systemctl enable nginx
        fi

        if systemctl is-active --quiet nginx && systemctl is-enabled --quiet nginx; then
            echo "Nginx is installed, enabled and active ✅"
            NginxConfig
        else
            echo "An error happened when trying to start/enable nginx ❌"
            exit 1
        fi
    else
        echo "Nginx is not installed, please install it ❌"
        exit 1
    fi

}


NginxConfig() {
    read -p "Are you currently on a proxy server or a web server ? (p/s) " response
    case "$response" in
        [pP])
            cp proxy.conf.secure /etc/nginx/conf.d/proxy.conf
            ;;
        [sS])
            cp proxy.conf.secure /etc/nginx/conf.d/proxy.conf
            ;;
        *)
            echo "Invalid response. Please enter 'proxy' or 'server'."
            NginxConfig
            ;;
    esac

    #Generating certs
    openssl req -new -newkey rsa:2048 -days 365 -nodes -x509 -keyout server.key -out server.crt
    mv server.crt /etc/pki/tls/certs/server.crt
    mv server.key /etc/pki/tls/private/server.key
    if [ -e "/etc/pki/tls/certs/server.crt" ] && [ -e "/etc/pki/tls/private/server.key" ]; then
        echo "Certs generated successfully ✅"
    else
        echo "An error happened when generating certs ❌"
    fi

    echo "Now restarting nginx ..."
    systemctl restart nginx
    if systemctl is-active --quiet nginx && systemctl is-enabled --quiet nginx; then
        echo "NGINX restarted succesfully ✅"
    fi
}


NginxConfigAsk() {
    read -p "The new nginx config will create a new conf in /etc/nginx/conf.d, do you agree with that ? Make sure no other conf are conflicting with it (y/n) " response
    case "$response" in
        [yY])
            VerifyNginx
            ;;
        [nN])
            echo "You refused to create a new config file, exiting ..."
            exit 1
            ;;
        *)
            echo "Invalid response. Please enter 'y' for yes or 'n' for no."
            NginxConfigAsk
            ;;
    esac
}

NginxConfigAsk