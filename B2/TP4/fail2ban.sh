#!/bin/sh

SetupFail2ban() {
    cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
    sed -i 's/^enabled = false/enabled = false/' /etc/fail2ban/jail.local
    systemctl restart fail2ban
    echo "Fail2ban is just up an running but with default config, if you wish to change it, modify /etc/fail2ban/jail.local"
}


VerifyFail2ban() {
    if [ -x "$(command -v fail2ban-server)" ]; then
        echo "Fail2Ban already installed ✅"
    else
        echo "Fail2Ban is not installed, installing ..."
        dnf install epel-release -y > /dev/null
        dnf install fail2ban -y > /dev/null
    fi

    if ! systemctl is-active --quiet fail2ban; then
        echo "Starting fail2ban ..."
        systemctl start fail2ban
    fi

    if ! systemctl is-enabled --quiet fail2ban; then
        echo "Enabling fail2ban ..."
        systemctl enable fail2ban
    fi

    if systemctl is-active --quiet fail2ban && systemctl is-enabled --quiet fail2ban; then
        echo "Fail2ban is installed, enabled and active ✅"
        SetupFail2ban
    else
        echo "An error happened when trying to start/enable fail2ban ❌"
        exit 1
    fi
}

VerifyFail2ban