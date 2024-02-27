#!/bin/bash

CheckSSH() {
    if which sshd >/dev/null 2>&1; then
        if systemctl is-active --quiet sshd && systemctl is-enabled --quiet sshd; then
            echo "SSH is installed, enabled and active ✅"
        fi

        if ! systemctl is-active --quiet sshd; then
            echo "Starting SSH ..."
            systemctl start sshd
        fi

        if ! systemctl is-enabled --quiet sshd; then
            echo "Enabling SSH ..."
            systemctl enable sshd
        fi

        if systemctl is-active --quiet sshd && systemctl is-enabled --quiet sshd; then
            echo "SSH is installed, enabled and active ✅"
        else
            echo "An error happened when trying to start/enable SSH ❌"
            exit 1
        fi
    else
        echo "SSH is not installed on the system ❌"
        echo "Please install it and run this script again"
        exit 1
    fi
}

SSHPermissions() {
    # 5.2.1
    chown root:root /etc/ssh/sshd_config
    chmod u-x,go-rwx /etc/ssh/sshd_config

    #5.2.2
    for file in /etc/ssh/ssh_host_*; do
        if [[ -f "$file" && ! "$file" =~ \.pub$ ]]; then
            if [[ $(stat -c "%a" "$file") != "600" ]]; then
                chmod 600 "$file"
                echo "Changed permissions of $file to 600"
            else
                echo "$file already has the correct permissions of 600 ✅"
            fi
        fi
    done

    # 5.2.3
    for file in /etc/ssh/ssh_host_*; do
        if [[ -f "$file" && "$file" =~ \.pub$ ]]; then
            if [[ $(stat -c "%a" "$file") != "640" ]]; then
                chmod 640 "$file"
                echo "Changed permissions of $file to 640"
            else
                echo "$file already has the correct permissions of 640 ✅"
            fi
        fi
    done
}

CopyConfig() {
    cp sshd_config /etc/ssh/sshd_config
    if [ -e "sshd_config" ] && [ -e "/etc/ssh/sshd_config" ]; then
        if cmp -s "sshd_config" "/etc/ssh/sshd_config"; then
            echo "File updated succesfully ✅"
            echo "Make sure to modify the commented line to only allow the users that you want to log in"
        else
            echo "A problem happened when trying to update the file ❌"
        fi
    else
        echo "A problem happened when trying to update the file ❌"
    fi

}

SSHBackup() {
    cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup
    echo "Created a copy of the current config file at /etc/ssh/sshd_config.backup"
}

ModifyConfig() {
    SSHBackup
    # 5.2.5
    if grep "^LogLevel VERBOSE" /etc/ssh/sshd_config > /dev/null; then
        echo "LogLevel already set to verbose ✅"
    elif grep "^LogLevel" /etc/ssh/sshd_config > /dev/null; then
        sed -i "s/LogLevel.*/LogLevel VERBOSE/" /etc/ssh/sshd_config > /dev/null
        echo "LogLevel set to verbose"
    elif grep "^#LogLevel" /etc/ssh/sshd_config > /dev/null; then
        sed -i "s/#LogLevel.*/LogLevel VERBOSE/" /etc/ssh/sshd_config > /dev/null
        echo "LogLevel set to verbose"
    else
        echo "LogLevel VERBOSE" | tee -a /etc/ssh/sshd_config > /dev/null
        echo "LogLevel added"
    fi
    # 5.2.5 Verif
    if grep "^LogLevel VERBOSE" /etc/ssh/sshd_config > /dev/null; then
        echo "LogLevel succesfully set to verbose ✅"
    else
        echo "An error happened when trying to set the LogLevel ❌"
        exit 1
    fi

    # 5.2.6
    if grep "^UsePAM yes" /etc/ssh/sshd_config > /dev/null; then
        echo "UsePAM already set to yes ✅"
    elif grep "^UsePAM" /etc/ssh/sshd_config > /dev/null; then
        sed -i "s/UsePAM.*/UsePAM yes/" /etc/ssh/sshd_config > /dev/null
        echo "UsePAM set to yes"
    elif grep "^#UsePAM" /etc/ssh/sshd_config > /dev/null; then
        sed -i "s/#UsePAM.*/UsePAM yes/" /etc/ssh/sshd_config > /dev/null
        echo "UsePAM set to yes"
    else
        echo "UsePAM yes" | tee -a /etc/ssh/sshd_config > /dev/null
        echo "UsePAM added"
    fi
    # 5.2.6 Verif
    if grep "^UsePAM yes" /etc/ssh/sshd_config > /dev/null; then
        echo "UsePAM succesfully set to yes ✅"
    else
        echo "An error happened when trying to set the UsePAM ❌"
        exit 1
    fi

    # 5.2.7
    if grep "^PermitRootLogin no" /etc/ssh/sshd_config > /dev/null; then
        echo "PermitRootLogin already set to no ✅"
    elif grep "^PermitRootLogin" /etc/ssh/sshd_config > /dev/null; then
        sed -i "s/PermitRootLogin.*/PermitRootLogin no/" /etc/ssh/sshd_config > /dev/null
        echo "PermitRootLogin set to no"
    elif grep "^#PermitRootLogin" /etc/ssh/sshd_config > /dev/null; then
        sed -i "s/#PermitRootLogin.*/PermitRootLogin no/" /etc/ssh/sshd_config > /dev/null
        echo "PermitRootLogin set to no"
    else
        echo "PermitRootLogin no" | tee -a /etc/ssh/sshd_config > /dev/null
        echo "PermitRootLogin added"
    fi
    # 5.2.7 Verif
    if grep "^PermitRootLogin no" /etc/ssh/sshd_config > /dev/null; then
        echo "PermitRootLogin succesfully set to no ✅"
    else
        echo "An error happened when trying to set the PermitRootLogin ❌"
        exit 1
    fi

    # 5.2.8
    if grep "^HostbasedAuthentication no" /etc/ssh/sshd_config > /dev/null; then
        echo "HostbasedAuthentication already set to no ✅"
    elif grep "^HostbasedAuthentication" /etc/ssh/sshd_config > /dev/null; then
        sed -i "s/HostbasedAuthentication.*/HostbasedAuthentication no/" /etc/ssh/sshd_config > /dev/null
        echo "HostbasedAuthentication set to no"
    elif grep "^#HostbasedAuthentication" /etc/ssh/sshd_config > /dev/null; then
        sed -i "s/#HostbasedAuthentication.*/HostbasedAuthentication no/" /etc/ssh/sshd_config > /dev/null
        echo "HostbasedAuthentication set to no"
    else
        echo "HostbasedAuthentication no" | tee -a /etc/ssh/sshd_config > /dev/null
        echo "HostbasedAuthentication added"
    fi
    # 5.2.8 Verif
    if grep "^HostbasedAuthentication no" /etc/ssh/sshd_config > /dev/null; then
        echo "HostbasedAuthentication succesfully set to no ✅"
    else
        echo "An error happened when trying to set the HostbasedAuthentication ❌"
        exit 1
    fi

    # 5.2.9
    if grep "^PermitEmptyPasswords no" /etc/ssh/sshd_config > /dev/null; then
        echo "PermitEmptyPasswords already set to no ✅"
    elif grep "^PermitEmptyPasswords" /etc/ssh/sshd_config > /dev/null; then
        sed -i "s/PermitEmptyPasswords.*/PermitEmptyPasswords no/" /etc/ssh/sshd_config > /dev/null
        echo "PermitEmptyPasswords set to no"
    elif grep "^#PermitEmptyPasswords" /etc/ssh/sshd_config > /dev/null; then
        sed -i "s/#PermitEmptyPasswords.*/PermitEmptyPasswords no/" /etc/ssh/sshd_config > /dev/null
        echo "PermitEmptyPasswords set to no"
    else
        echo "PermitEmptyPasswords no" | tee -a /etc/ssh/sshd_config > /dev/null
        echo "PermitEmptyPasswords added"
    fi
    # 5.2.9 Verif
    if grep "^PermitEmptyPasswords no" /etc/ssh/sshd_config > /dev/null; then
        echo "PermitEmptyPasswords succesfully set to no ✅"
    else
        echo "An error happened when trying to set the PermitEmptyPasswords ❌"
        exit 1
    fi

    # 5.2.10
    if grep "^PermitUserEnvironment no" /etc/ssh/sshd_config > /dev/null; then
        echo "PermitUserEnvironment already set to no ✅"
    elif grep "^PermitUserEnvironment" /etc/ssh/sshd_config > /dev/null; then
        sed -i "s/PermitUserEnvironment.*/PermitUserEnvironment no/" /etc/ssh/sshd_config > /dev/null
        echo "PermitUserEnvironment set to no"
    elif grep "^#PermitUserEnvironment" /etc/ssh/sshd_config > /dev/null; then
        sed -i "s/#PermitUserEnvironment.*/PermitUserEnvironment no/" /etc/ssh/sshd_config > /dev/null
        echo "PermitUserEnvironment set to no"
    else
        echo "PermitUserEnvironment no" | tee -a /etc/ssh/sshd_config > /dev/null
        echo "PermitUserEnvironment added"
    fi
    # 5.2.10 Verif
    if grep "^PermitUserEnvironment no" /etc/ssh/sshd_config > /dev/null; then
        echo "PermitUserEnvironment succesfully set to no ✅"
    else
        echo "An error happened when trying to set the PermitUserEnvironment ❌"
        exit 1
    fi

    # 5.2.11
    if grep "^IgnoreRhosts yes" /etc/ssh/sshd_config > /dev/null; then
        echo "IgnoreRhosts already set to yes ✅"
    elif grep "^IgnoreRhosts" /etc/ssh/sshd_config > /dev/null; then
        sed -i "s/IgnoreRhosts.*/IgnoreRhosts yes/" /etc/ssh/sshd_config > /dev/null
        echo "IgnoreRhosts set to yes"
    elif grep "^#IgnoreRhosts" /etc/ssh/sshd_config > /dev/null; then
        sed -i "s/#IgnoreRhosts.*/IgnoreRhosts yes/" /etc/ssh/sshd_config > /dev/null
        echo "IgnoreRhosts set to yes"
    else
        echo "IgnoreRhosts yes" | tee -a /etc/ssh/sshd_config > /dev/null
        echo "IgnoreRhosts added"
    fi
    # 5.2.11 Verif
    if grep "^IgnoreRhosts yes" /etc/ssh/sshd_config > /dev/null; then
        echo "IgnoreRhosts succesfully set to yes ✅"
    else
        echo "An error happened when trying to set the IgnoreRhosts ❌"
        exit 1
    fi

    # 5.2.12
    if grep "^X11Forwarding no" /etc/ssh/sshd_config > /dev/null; then
        echo "X11Forwarding already set to no ✅"
    elif grep "^X11Forwarding" /etc/ssh/sshd_config > /dev/null; then
        sed -i "s/X11Forwarding.*/X11Forwarding no/" /etc/ssh/sshd_config > /dev/null
        echo "X11Forwarding set to no"
    elif grep "^#X11Forwarding" /etc/ssh/sshd_config > /dev/null; then
        sed -i "s/#X11Forwarding.*/X11Forwarding no/" /etc/ssh/sshd_config > /dev/null
        echo "X11Forwarding set to no"
    else
        echo "X11Forwarding no" | tee -a /etc/ssh/sshd_config > /dev/null
        echo "X11Forwarding added"
    fi
    # 5.2.12 Verif
    if grep "^X11Forwarding no" /etc/ssh/sshd_config > /dev/null; then
        echo "X11Forwarding succesfully set to no ✅"
    else
        echo "An error happened when trying to set the X11Forwarding ❌"
        exit 1
    fi

    # 5.2.13
    if grep "^AllowTcpForwarding no" /etc/ssh/sshd_config > /dev/null; then
        echo "AllowTcpForwarding already set to no ✅"
    elif grep "^AllowTcpForwarding" /etc/ssh/sshd_config > /dev/null; then
        sed -i "s/AllowTcpForwarding.*/AllowTcpForwarding no/" /etc/ssh/sshd_config > /dev/null
        echo "AllowTcpForwarding set to no"
    elif grep "^#AllowTcpForwarding" /etc/ssh/sshd_config > /dev/null; then
        sed -i "s/#AllowTcpForwarding.*/AllowTcpForwarding no/" /etc/ssh/sshd_config > /dev/null
        echo "AllowTcpForwarding set to no"
    else
        echo "AllowTcpForwarding no" | tee -a /etc/ssh/sshd_config > /dev/null
        echo "AllowTcpForwarding added"
    fi
    # 5.2.13 Verif
    if grep "^AllowTcpForwarding no" /etc/ssh/sshd_config > /dev/null; then
        echo "AllowTcpForwarding succesfully set to no ✅"
    else
        echo "An error happened when trying to set the AllowTcpForwarding ❌"
        exit 1
    fi

    # 5.2.15
    if grep "^Banner /etc/issue.net" /etc/ssh/sshd_config > /dev/null; then
        echo "Banner already set to /etc/issue.net ✅"
    elif grep "^Banner" /etc/ssh/sshd_config > /dev/null; then
        sed -i "s/Banner.*/Banner \/etc\/issue.net/" /etc/ssh/sshd_config > /dev/null
        echo "Banner set to /etc/issue.net"
    elif grep "^#Banner" /etc/ssh/sshd_config > /dev/null; then
        sed -i "s/#Banner.*/Banner \/etc\/issue.net/" /etc/ssh/sshd_config > /dev/null
        echo "Banner set to /etc/issue.net"
    else
        echo "Banner /etc/issue.net" | tee -a /etc/ssh/sshd_config > /dev/null
        echo "Banner added"
    fi
    # 5.2.15 Verif
    if grep "^Banner /etc/issue.net" /etc/ssh/sshd_config > /dev/null; then
        echo "Banner succesfully set to /etc/issue.net ✅"
    else
        echo "An error happened when trying to set the Banner ❌"
        exit 1
    fi

    # 5.2.16
    if grep "^MaxAuthTries 4" /etc/ssh/sshd_config > /dev/null; then
        echo "MaxAuthTries already set to 4 ✅"
    elif grep "^MaxAuthTries" /etc/ssh/sshd_config > /dev/null; then
        sed -i "s/MaxAuthTries.*/MaxAuthTries 4/" /etc/ssh/sshd_config > /dev/null
        echo "MaxAuthTries set to 4"
    elif grep "^#MaxAuthTries" /etc/ssh/sshd_config > /dev/null; then
        sed -i "s/#MaxAuthTries.*/MaxAuthTries 4/" /etc/ssh/sshd_config > /dev/null
        echo "MaxAuthTries set to 4"
    else
        echo "MaxAuthTries 4" | tee -a /etc/ssh/sshd_config > /dev/null
        echo "MaxAuthTries added"
    fi
    # 5.2.16 Verif
    if grep "^MaxAuthTries 4" /etc/ssh/sshd_config > /dev/null; then
        echo "MaxAuthTries succesfully set to 4 ✅"
    else
        echo "An error happened when trying to set the MaxAuthTries ❌"
        exit 1
    fi

    # 5.2.17
    if grep "^MaxStartups 10:30:60" /etc/ssh/sshd_config > /dev/null; then
        echo "MaxStartups already set to 10:30:60 ✅"
    elif grep "^MaxStartups" /etc/ssh/sshd_config > /dev/null; then
        sed -i "s/MaxStartups.*/MaxStartups 10:30:60/" /etc/ssh/sshd_config > /dev/null
        echo "MaxStartups set to 10:30:60"
    elif grep "^#MaxStartups" /etc/ssh/sshd_config > /dev/null; then
        sed -i "s/#MaxStartups.*/MaxStartups 10:30:60/" /etc/ssh/sshd_config > /dev/null
        echo "MaxStartups set to 10:30:60"
    else
        echo "MaxStartups 10:30:60" | tee -a /etc/ssh/sshd_config > /dev/null
        echo "MaxStartups added"
    fi
    # 5.2.17 Verif
    if grep "^MaxStartups 10:30:60" /etc/ssh/sshd_config > /dev/null; then
        echo "MaxStartups succesfully set to 10:30:60 ✅"
    else
        echo "An error happened when trying to set the MaxStartups ❌"
        exit 1
    fi

    # 5.2.18
    if grep "^MaxSessions 10" /etc/ssh/sshd_config > /dev/null; then
        echo "MaxSessions already set to 10 ✅"
    elif grep "^MaxSessions" /etc/ssh/sshd_config > /dev/null; then
        sed -i "s/MaxSessions.*/MaxSessions 10/" /etc/ssh/sshd_config > /dev/null
        echo "MaxSessions set to 10"
    elif grep "^#MaxSessions" /etc/ssh/sshd_config > /dev/null; then
        sed -i "s/#MaxSessions.*/MaxSessions 10/" /etc/ssh/sshd_config > /dev/null
        echo "MaxSessions set to 10"
    else
        echo "MaxSessions 10" | tee -a /etc/ssh/sshd_config > /dev/null
        echo "MaxSessions added"
    fi
    # 5.2.18 Verif
    if grep "^MaxSessions 10" /etc/ssh/sshd_config > /dev/null; then
        echo "MaxSessions succesfully set to 10 ✅"
    else
        echo "An error happened when trying to set the MaxSessions ❌"
        exit 1
    fi

    # 5.2.19
    if grep "^LoginGraceTime 60" /etc/ssh/sshd_config > /dev/null; then
        echo "LoginGraceTime already set to 60 ✅"
    elif grep "^LoginGraceTime" /etc/ssh/sshd_config > /dev/null; then
        sed -i "s/LoginGraceTime.*/LoginGraceTime 60/" /etc/ssh/sshd_config > /dev/null
        echo "LoginGraceTime set to 60"
    elif grep "^#LoginGraceTime" /etc/ssh/sshd_config > /dev/null; then
        sed -i "s/#LoginGraceTime.*/LoginGraceTime 60/" /etc/ssh/sshd_config > /dev/null
        echo "LoginGraceTime set to 60"
    else
        echo "LoginGraceTime 60" | tee -a /etc/ssh/sshd_config > /dev/null
        echo "LoginGraceTime added"
    fi
    # 5.2.19 Verif
    if grep "^LoginGraceTime 60" /etc/ssh/sshd_config > /dev/null; then
        echo "LoginGraceTime succesfully set to 60 ✅"
    else
        echo "An error happened when trying to set the LoginGraceTime ❌"
        exit 1
    fi

    # 5.2.20.1
    if grep "^ClientAliveInterval 15" /etc/ssh/sshd_config > /dev/null; then
        echo "ClientAliveInterval already set to 15 ✅"
    elif grep "^ClientAliveInterval" /etc/ssh/sshd_config > /dev/null; then
        sed -i "s/ClientAliveInterval.*/ClientAliveInterval 15/" /etc/ssh/sshd_config > /dev/null
        echo "ClientAliveInterval set to 15"
    elif grep "^#ClientAliveInterval" /etc/ssh/sshd_config > /dev/null; then
        sed -i "s/#ClientAliveInterval.*/ClientAliveInterval 15/" /etc/ssh/sshd_config > /dev/null
        echo "ClientAliveInterval set to 15"
    else
        echo "ClientAliveInterval 15" | tee -a /etc/ssh/sshd_config > /dev/null
        echo "ClientAliveInterval added"
    fi
    # 5.2.20.1 Verif
    if grep "^ClientAliveInterval 15" /etc/ssh/sshd_config > /dev/null; then
        echo "ClientAliveInterval succesfully set to 15 ✅"
    else
        echo "An error happened when trying to set the ClientAliveInterval ❌"
        exit 1
    fi

    # 5.2.20.2
    if grep "^ClientAliveCountMax 3" /etc/ssh/sshd_config > /dev/null; then
        echo "ClientAliveCountMax already set to 3 ✅"
    elif grep "^ClientAliveCountMax" /etc/ssh/sshd_config > /dev/null; then
        sed -i "s/ClientAliveCountMax.*/ClientAliveCountMax 3/" /etc/ssh/sshd_config > /dev/null
        echo "ClientAliveCountMax set to 3"
    elif grep "^#ClientAliveCountMax" /etc/ssh/sshd_config > /dev/null; then
        sed -i "s/#ClientAliveCountMax.*/ClientAliveCountMax 3/" /etc/ssh/sshd_config > /dev/null
        echo "ClientAliveCountMax set to 3"
    else
        echo "ClientAliveCountMax 3" | tee -a /etc/ssh/sshd_config > /dev/null
        echo "ClientAliveCountMax added"
    fi
    # 5.2.20.2 Verif
    if grep "^ClientAliveCountMax 3" /etc/ssh/sshd_config > /dev/null; then
        echo "ClientAliveCountMax succesfully set to 3 ✅"
    else
        echo "An error happened when trying to set the ClientAliveCountMax ❌"
        exit 1
    fi

    # 5.2.4
    echo "Don't forget to add AllowUsers to the config file to set which user can connect"

    echo "SSH will now restart"

    systemctl restart sshd

    if [ $? -eq 0 ]; then
        echo "SSH service restarted successfully ✅"
    else
        echo "Failed to restart SSH service ❌"
        exit 1
    fi
}

SSHConfig() {
    # 5.2.4 => 
    read -p "Do you wish to replace your current SSH config with the secure one? If you select no, only some modifications will be done to your current config file (y/n) : " response
    case "$response" in
        [yY])
            CopyConfig
            ;;
        [nN])
            ModifyConfig
            ;;
        *)
            echo "Invalid response. Please enter 'y' for yes or 'n' for no."
            SSHConfig
            ;;
    esac
}

CheckSSH
SSHPermissions
SSHConfig