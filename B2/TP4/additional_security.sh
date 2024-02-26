#!/bin/sh

SystemFilePermissions() {
    file_list1=(
    "/etc/passwd"
    "/etc/passwd-"
    "/etc/group"
    "/etc/group-"
    )

    for file in "${file_list1[@]}"; do
        if [[ -f "$file" ]]; then
            if [[ $(stat -c "%a" "$file") != "644" ]]; then
                chmod 644 "$file"
                echo "Changed permissions of $file to 644"
            else
                echo "$file already has the correct permissions of 644 ✅"
            fi
            
            if [[ $(stat -c "%U:%G" "$file") != "root:root" ]]; then
                chown root:root "$file"
                echo "Changed owner and group of $file to root:root"
            else
                echo "$file already has the correct owner and group of root:root ✅"
            fi
        fi
    done

    file_list2=(
    "/etc/shadow"
    "/etc/shadow-"
    "/etc/gshadow"
    "/etc/gshadow-"
    )

    for file in "${file_list2[@]}"; do
        if [[ -f "$file" ]]; then
            if [[ $(stat -c "%a" "$file") != "0" ]]; then
                chmod 0000 "$file"
                echo "Changed permissions of $file to 000"
            else
                echo "$file already has the correct permissions of 000 ✅"
            fi
            
            if [[ $(stat -c "%U:%G" "$file") != "root:root" ]]; then
                chown root:root "$file"
                echo "Changed owner and group of $file to root:root"
            else
                echo "$file already has the correct owner and group of root:root ✅"
            fi
        fi
    done
}

VerifySystemFilePermissions() {
    for file in "${file_list1[@]}"; do
        if [[ $(stat -c "%a" "$file") == "644" ]] && [[ $(stat -c "%U:%G" "$file") == "root:root" ]]; then
            echo "Permissions and owner for $file set succesfully ✅"
        else
            echo "An error happened when trying to set permissions for $file ❌"
        fi
    done

    for file in "${file_list2[@]}"; do
        if [[ $(stat -c "%a" "$file") == "0" ]] && [[ $(stat -c "%U:%G" "$file") == "root:root" ]]; then
            echo "Permissions and owner for $file set succesfully ✅"
        else
            echo "An error happened when trying to set permissions for $file ❌"
        fi
    done
}

UserAccountAndEnvironment() {
    if grep "^PASS_MAX_DAYS" /etc/login.defs > /dev/null; then
        sed -i "s/^PASS_MAX_DAYS.*/PASS_MAX_DAYS 365/" /etc/login.defs > /dev/null
    else
        echo "PASS_MAX_DAYS 365" | tee -a /etc/login.defs > /dev/null
    fi

    if grep "^PASS_MIN_DAYS" /etc/login.defs > /dev/null; then
        sed -i "s/^PASS_MIN_DAYS.*/PASS_MIN_DAYS 1/" /etc/login.defs > /dev/null
    else
        echo "PASS_MIN_DAYS 1" | tee -a /etc/login.defs > /dev/null
    fi

    if grep "^PASS_WARN_AGE" /etc/login.defs > /dev/null; then
        sed -i "s/^PASS_WARN_AGE.*/PASS_WARN_AGE 7/" /etc/login.defs > /dev/null
    else
        echo "PASS_WARN_AGE 7" | tee -a /etc/login.defs > /dev/null
    fi

    if [ -e "/etc/profile.d/tmout.sh" ]; then
        echo "TMOUT already set ✅"
    else
        echo "readonly TMOUT=900 ; export TMOUT" | tee -a /etc/profile.d/tmout.sh > /dev/null
    fi

    if [ -e "/etc/profile.d/set_umask.sh" ]; then
        echo "umask 027 already set ✅"
    else
        echo "umask 027" | tee -a /etc/profile.d/set_umask.sh > /dev/null
    fi

    #Verif
    if [ -e "/etc/profile.d/tmout.sh" ] && [ -e "/etc/profile.d/set_umask.sh" ] && grep "^PASS_MAX_DAYS" /etc/login.defs > /dev/null && grep "^PASS_MIN_DAYS" /etc/login.defs > /dev/null &&  grep "^PASS_WARN_AGE" /etc/login.defs > /dev/null; then
        echo "All user account and environement parameters set succesfully ✅"
    else
        echo "An error happened when trying to set user account and environement parameters ❌"
        exit 1
    fi
}

SystemFilePermissions
VerifySystemFilePermissions

if [ -e "/etc/login.defs" ]; then
    UserAccountAndEnvironment
else
    echo "Can't find /etc/login.defs ❌"
    exit 1
fi