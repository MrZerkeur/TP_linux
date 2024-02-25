#!/bin/bash

CheckSSH() {
    if which sshd >/dev/null 2>&1; then
        # Check if sshd service is active and enabled
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

ModifyConfig() {
    # 5.2.5
    if grep "^LogLevel VERBOSE" /etc/ssh/sshd_config; then
        echo "Loglevel already set to verbose"
    elif ! grep "Loglevel" /etc/ssh/sshd_config; then
        echo "LogLevel VERBOSE" | tee -a /etc/ssh/sshd_config > /dev/null
    else
        sed -i "s/.*Loglevel.*/LogLevel VERBOSE/" /etc/ssh/sshd_config > /dev/null
    fi

    # 5.2.6
    

    # 5.2.4
    echo "Don't forget to add AllowUsers to the config file to set which user can connect"
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