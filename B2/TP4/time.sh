#!/bin/sh

# Functions
chronyInstall() {
    # Check if chrony is installed, install it if it's not
    if rpm -q chrony | grep 'not installed' > /dev/null; then
        echo "Chrony is not installed, installing ..."
        dnf install chrony -y > /dev/null
        if rpm -q chrony | grep '^chrony' > /dev/null; then
            echo "Chrony installed succesfully ✅"
        else
            echo "An error happened when trying to install chrony ❌"
            exit 1
        fi
    elif rpm -q chrony | grep '^chrony' > /dev/null; then
        echo "Chrony is already installed ✅"
    else
        echo "An error happened when checking for chrony ❌"
        exit 1
    fi
}

chronyPool() {
    # Check if a pool is set in the conf file and add it if it's not
    if [ -z "$(cat /etc/chrony.conf | grep "pool" | grep -v '^#')" ]; then
        echo "No pool set in /etc/chrony.conf, adding it"
        echo "pool 2.rocky.pool.ntp.org iburst" | tee -a /etc/chrony.conf > /dev/null
        if [ -z "$(cat /etc/chrony.conf | grep "pool" | grep -v '^#')" ]; then
            echo "An error happened when adding a pool to /etc/chrony.conf ❌"
            exit 1
        else
            echo "Pool added succesfully ✅"
        fi
    else
        echo "A pool is already set in /etc/chrony.conf ✅"
    fi
}

chronyOptions() {
    # Check chrony options and update them
    if [[ $(grep ^OPTIONS /etc/sysconfig/chronyd | cut -d'"' -f2) == "-u chrony" ]]; then
        echo "Chrony options already set correctly ✅"
    else
        echo "Chrony options have to be modifed, modifying ..."
        sed -i 's/^OPTIONS=.*/OPTIONS="-u chrony"/' /etc/sysconfig/chronyd
        if [[ $(grep ^OPTIONS /etc/sysconfig/chronyd | cut -d'"' -f2) == "-u chrony" ]]; then
            echo "Chrony options updated succesfully ✅"
        else
            echo "An error happened when trying to modify the options in /etc/sysconfig/chronyd ❌"
            exit 1
        fi    
    fi
}

# Running the functions
chronyInstall

if [ -e "/etc/chrony.conf" ]; then
    chronyPool
else
    echo "An error happened, can't find /etc/chrony.conf ❌"
    exit 1
fi

if [ -e "/etc/sysconfig/chronyd" ]; then
    chronyOptions
else
    echo "An error happened, can't find /etc/sysconfig/chronyd ❌"
    exit 1
fi

systemctl restart chronyd

echo "All chrony configuration done succesfully ✅"