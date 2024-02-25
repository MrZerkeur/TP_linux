#!/bin/sh

# Functions
IPv6() {
    # Verify if IPv6 is enabled
    if [[ $(cat /sys/module/ipv6/parameters/disable) == "0" ]]; then
        echo "IPv6 is enabled ✅"
        ipv6=true
    elif [[ $(cat /sys/module/ipv6/parameters/disable) == "1" ]]; then
        echo "IPv6 is disabled ❌ Please activate it by modifying /sys/module/ipv6/parameters/disable to 0"
        ipv6=false
    else
        echo "An error happened when trying to read /sys/module/ipv6/parameters/disable ❌"
        exit 1
    fi
}

IPForwarding() {
    # Disable IP forwarding for IPv4 and also IPv6 if it's enabled
    # 3.2.1
    if grep -Fxq "net.ipv4.ip_forward = 0" /etc/sysctl.d/60-netipv4_sysctl.conf && ! $ipv6; then
        echo "IP forwarding already disabled ✅"
    elif grep -Fxq "net.ipv4.ip_forward = 0" /etc/sysctl.d/60-netipv4_sysctl.conf && grep -Fxq "net.ipv6.conf.all.forwarding = 0" /etc/sysctl.d/60-netipv6_sysctl.conf 2>/dev/null && $ipv6; then
        echo "IP forwarding already disabled ✅"
    else
        if grep -q "net.ipv4.ip_forward = 1" /etc/sysctl.d/60-netipv4_sysctl.conf 2>/dev/null; then
            sed -i 's/net.ipv4.ip_forward = 1/net.ipv4.ip_forward = 0/' /etc/sysctl.d/60-netipv4_sysctl.conf > /dev/null
            echo "Disabled  IP forwarding for IPv4"
        elif grep -q "net.ipv4.ip_forward = 0" /etc/sysctl.d/60-netipv4_sysctl.conf 2>/dev/null; then
            echo "IP forwarding already disabled for IPv4"
        else
            echo "net.ipv4.ip_forward = 0" | tee -a /etc/sysctl.d/60-netipv4_sysctl.conf > /dev/null
            echo "Disabled IP forwarding for IPv4"
        fi
        if $ipv6; then
            if grep -q "net.ipv6.conf.all.forwarding = 1" /etc/sysctl.d/60-netipv6_sysctl.conf 2>/dev/null; then
                sed -i 's/net.ipv6.conf.all.forwarding = 1/net.ipv6.conf.all.forwarding = 0/' /etc/sysctl.d/60-netipv6_sysctl.conf > /dev/null
                echo "Disabled IP forwarding for IPv6"
            elif grep -q "net.ipv6.conf.all.forwarding = 0" /etc/sysctl.d/60-netipv6_sysctl.conf 2>/dev/null; then
                echo "IP forwarding already disabled for IPv6"
            else
                echo "net.ipv6.conf.all.forwarding = 0" | tee -a /etc/sysctl.d/60-netipv6_sysctl.conf > /dev/null
                echo "Disabled IP forwarding for IPv6"
            fi
        fi
        if grep -q "net.ipv6.conf.all.forwarding = 0" /etc/sysctl.d/60-netipv6_sysctl.conf && grep -q "net.ipv4.ip_forward = 0" /etc/sysctl.d/60-netipv4_sysctl.conf && $ipv6; then
            echo "IP forwarding succesfully disabled ✅"
        elif grep -q "net.ipv4.ip_forward = 0" /etc/sysctl.d/60-netipv4_sysctl.conf && ! $ipv6; then
            echo "IP forwarding succesfully disabled ✅"
        else
            echo "An error happened when trying to disable IP forwarding ❌"
            exit 1
        fi
    fi
}

PacketRedirect() {
    # Disable packet redirect
    # 3.2.2
    if grep -Fxq "net.ipv4.conf.all.send_redirects = 0" /etc/sysctl.d/60-netipv4_sysctl.conf && grep -Fxq "net.ipv4.conf.default.send_redirects = 0" /etc/sysctl.d/60-netipv4_sysctl.conf; then
        echo "Packet redirect already disabled ✅"
    else
        if grep -Fxq "net.ipv4.conf.all.send_redirects = 1" /etc/sysctl.d/60-netipv4_sysctl.conf; then
            sed -i 's/net.ipv4.conf.all.send_redirects = 1/net.ipv4.conf.all.send_redirects = 0/' /etc/sysctl.d/60-netipv4_sysctl.conf > /dev/null
        elif grep -Fxq "net.ipv4.conf.all.send_redirects = 0" /etc/sysctl.d/60-netipv4_sysctl.conf; then
            echo "net.ipv4.conf.all.send_redirects already at 0"
        else
            echo "net.ipv4.conf.all.send_redirects = 0" | tee -a /etc/sysctl.d/60-netipv4_sysctl.conf > /dev/null
        fi

        if grep -Fxq "net.ipv4.conf.default.send_redirects = 1" /etc/sysctl.d/60-netipv4_sysctl.conf; then
            sed -i 's/net.ipv4.conf.default.send_redirects = 1/net.ipv4.conf.default.send_redirects = 0/' /etc/sysctl.d/60-netipv4_sysctl.conf > /dev/null
        elif grep -Fxq "net.ipv4.conf.default.send_redirects = 0" /etc/sysctl.d/60-netipv4_sysctl.conf; then
            echo "net.ipv4.conf.default.send_redirects already at 0"
        else
            echo "net.ipv4.conf.default.send_redirects = 0" | tee -a /etc/sysctl.d/60-netipv4_sysctl.conf > /dev/null
        fi

        if grep -Fxq "net.ipv4.conf.all.send_redirects = 0" /etc/sysctl.d/60-netipv4_sysctl.conf && grep -Fxq "net.ipv4.conf.default.send_redirects = 0" /etc/sysctl.d/60-netipv4_sysctl.conf; then
            echo "Packet redirect succesfully disabled ✅"
        else
            echo "An error happened when trying to disable packet redirect ❌"
            exit 1
        fi
    fi
}

SourceRoutedPackets() {
    # 3.3.1
    #IPv4
    if grep -q "net.ipv4.conf.all.accept_source_route = 0" /etc/sysctl.d/60-netipv4_sysctl.conf && grep -q "net.ipv4.conf.default.accept_source_route = 0" /etc/sysctl.d/60-netipv4_sysctl.conf; then
        echo "Source routed packets already not accepted (for IPv4) ✅"
    else
        if grep -q "net.ipv4.conf.all.accept_source_route = 1" /etc/sysctl.d/60-netipv4_sysctl.conf; then
            sed -i 's/net.ipv4.conf.all.accept_source_route = 1/net.ipv4.conf.all.accept_source_route = 0/' /etc/sysctl.d/60-netipv4_sysctl.conf > /dev/null
        elif grep -q "net.ipv4.conf.all.accept_source_route = 0" /etc/sysctl.d/60-netipv4_sysctl.conf; then
            echo "net.ipv4.conf.all.accept_source_route already at 0"
        else
            echo "net.ipv4.conf.all.accept_source_route = 0" | tee -a /etc/sysctl.d/60-netipv4_sysctl.conf > /dev/null
        fi

        if grep -q "net.ipv4.conf.default.accept_source_route = 1" /etc/sysctl.d/60-netipv4_sysctl.conf; then
            sed -i 's/net.ipv4.conf.default.accept_source_route = 1/net.ipv4.conf.default.accept_source_route = 0/' /etc/sysctl.d/60-netipv4_sysctl.conf > /dev/null
        elif grep -q "net.ipv4.conf.default.accept_source_route = 0" /etc/sysctl.d/60-netipv4_sysctl.conf; then
            echo "net.ipv4.conf.default.accept_source_route already at 0"
        else
            echo "net.ipv4.conf.default.accept_source_route = 0" | tee -a /etc/sysctl.d/60-netipv4_sysctl.conf > /dev/null
        fi
    fi
    #IPv6
    if $ipv6; then
        if grep -q "net.ipv6.conf.all.accept_source_route = 0" /etc/sysctl.d/60-netipv6_sysctl.conf && grep -q "net.ipv6.conf.default.accept_source_route = 0" /etc/sysctl.d/60-netipv6_sysctl.conf; then
            echo "Source routed packets already not accepted (for IPv6) ✅"
        else
            if grep -q "net.ipv6.conf.all.accept_source_route = 1" /etc/sysctl.d/60-netipv6_sysctl.conf; then
                sed -i 's/net.ipv6.conf.all.accept_source_route = 1/net.ipv6.conf.all.accept_source_route = 0/' /etc/sysctl.d/60-netipv6_sysctl.conf > /dev/null
            elif grep -q "net.ipv6.conf.all.accept_source_route = 0" /etc/sysctl.d/60-netipv6_sysctl.conf; then
                echo "net.ipv6.conf.all.accept_source_route already at 0"
            else
                echo "net.ipv6.conf.all.accept_source_route = 0" | tee -a /etc/sysctl.d/60-netipv6_sysctl.conf > /dev/null
            fi

            if grep -q "net.ipv6.conf.default.accept_source_route = 1" /etc/sysctl.d/60-netipv6_sysctl.conf; then
                sed -i 's/net.ipv6.conf.default.accept_source_route = 1/net.ipv6.conf.default.accept_source_route = 0/' /etc/sysctl.d/60-netipv6_sysctl.conf > /dev/null
            elif grep -q "net.ipv6.conf.default.accept_source_route = 0" /etc/sysctl.d/60-netipv6_sysctl.conf; then
                echo "net.ipv6.conf.default.accept_source_route already at 0"
            else
                echo "net.ipv6.conf.default.accept_source_route = 0" | tee -a /etc/sysctl.d/60-netipv6_sysctl.conf > /dev/null
            fi
        fi
    fi
    #Verification
    if grep -q "net.ipv4.conf.all.accept_source_route = 0" /etc/sysctl.d/60-netipv4_sysctl.conf && grep -q "net.ipv4.conf.default.accept_source_route = 0" /etc/sysctl.d/60-netipv4_sysctl.conf && ! $ipv6; then
        echo "Source routed packets succesfully set to refuse ✅"
    elif grep -q "net.ipv4.conf.all.accept_source_route = 0" /etc/sysctl.d/60-netipv4_sysctl.conf && grep -q "net.ipv4.conf.default.accept_source_route = 0" /etc/sysctl.d/60-netipv4_sysctl.conf && grep -q "net.ipv6.conf.all.accept_source_route = 0" /etc/sysctl.d/60-netipv6_sysctl.conf && grep -q "net.ipv6.conf.default.accept_source_route = 0" /etc/sysctl.d/60-netipv6_sysctl.conf && $ipv6; then
        echo "Source routed packets succesfully set to refuse ✅"
    else
        echo "An error happened when trying to modify source routed packets ❌"
        exit 1
    fi
}

ICMPRedirects() {
    # 3.3.2
    if grep -q "net.ipv4.conf.all.accept_redirects = 0" /etc/sysctl.d/60-netipv4_sysctl.conf && grep -q "net.ipv4.conf.default.accept_redirects = 0" /etc/sysctl.d/60-netipv4_sysctl.conf; then
        echo "ICMP redirects already not accepted (for IPv4) ✅"
    else
        if grep -q "net.ipv4.conf.all.accept_redirects = 1" /etc/sysctl.d/60-netipv4_sysctl.conf; then
            sed -i 's/net.ipv4.conf.all.accept_redirects = 1/net.ipv4.conf.all.accept_redirects = 0/' /etc/sysctl.d/60-netipv4_sysctl.conf > /dev/null
        elif grep -q "net.ipv4.conf.all.accept_redirects = 0" /etc/sysctl.d/60-netipv4_sysctl.conf; then
            echo "net.ipv4.conf.all.accept_redirects already at 0"
        else
            echo "net.ipv4.conf.all.accept_redirects = 0" | tee -a /etc/sysctl.d/60-netipv4_sysctl.conf > /dev/null
        fi

        if grep -q "net.ipv4.conf.default.accept_redirects = 1" /etc/sysctl.d/60-netipv4_sysctl.conf; then
            sed -i 's/net.ipv4.conf.default.accept_redirects = 1/net.ipv4.conf.default.accept_redirects = 0/' /etc/sysctl.d/60-netipv4_sysctl.conf > /dev/null
        elif grep -q "net.ipv4.conf.default.accept_redirects = 0" /etc/sysctl.d/60-netipv4_sysctl.conf; then
            echo "net.ipv4.conf.default.accept_redirects already at 0"
        else
            echo "net.ipv4.conf.default.accept_redirects = 0" | tee -a /etc/sysctl.d/60-netipv4_sysctl.conf > /dev/null
        fi
    fi
    #IPv6
    if $ipv6; then
        if grep -q "net.ipv6.conf.all.accept_redirects = 0" /etc/sysctl.d/60-netipv6_sysctl.conf && grep -q "net.ipv6.conf.default.accept_redirects = 0" /etc/sysctl.d/60-netipv6_sysctl.conf; then
            echo "ICMP redirects already not accepted (for IPv6) ✅"
        else
            if grep -q "net.ipv6.conf.all.accept_redirects = 1" /etc/sysctl.d/60-netipv6_sysctl.conf; then
                sed -i 's/net.ipv6.conf.all.accept_redirects = 1/net.ipv6.conf.all.accept_redirects = 0/' /etc/sysctl.d/60-netipv6_sysctl.conf > /dev/null
            elif grep -q "net.ipv6.conf.all.accept_redirects = 0" /etc/sysctl.d/60-netipv6_sysctl.conf; then
                echo "net.ipv6.conf.all.accept_redirects already at 0"
            else
                echo "net.ipv6.conf.all.accept_redirects = 0" | tee -a /etc/sysctl.d/60-netipv6_sysctl.conf > /dev/null
            fi

            if grep -q "net.ipv6.conf.default.accept_redirects = 1" /etc/sysctl.d/60-netipv6_sysctl.conf; then
                sed -i 's/net.ipv6.conf.default.accept_redirects = 1/net.ipv6.conf.default.accept_redirects = 0/' /etc/sysctl.d/60-netipv6_sysctl.conf > /dev/null
            elif grep -q "net.ipv6.conf.default.accept_redirects = 0" /etc/sysctl.d/60-netipv6_sysctl.conf; then
                echo "net.ipv6.conf.default.accept_redirects already at 0"
            else
                echo "net.ipv6.conf.default.accept_redirects = 0" | tee -a /etc/sysctl.d/60-netipv6_sysctl.conf > /dev/null
            fi
        fi
    fi
    #Verification
    if grep -q "net.ipv4.conf.all.accept_redirects = 0" /etc/sysctl.d/60-netipv4_sysctl.conf && grep -q "net.ipv4.conf.default.accept_redirects = 0" /etc/sysctl.d/60-netipv4_sysctl.conf && ! $ipv6; then
        echo "Source routed packets succesfully set to refuse ✅"
    elif grep -q "net.ipv4.conf.all.accept_redirects = 0" /etc/sysctl.d/60-netipv4_sysctl.conf && grep -q "net.ipv4.conf.default.accept_redirects = 0" /etc/sysctl.d/60-netipv4_sysctl.conf && grep -q "net.ipv6.conf.all.accept_redirects = 0" /etc/sysctl.d/60-netipv6_sysctl.conf && grep -q "net.ipv6.conf.default.accept_redirects = 0" /etc/sysctl.d/60-netipv6_sysctl.conf && $ipv6; then
        echo "ICMP redirects succesfully set to refuse ✅"
    else
        echo "An error happened when trying to disable ICMP redirects ❌"
        exit 1
    fi
}

ICMPSecureRedirects() {
    # 3.3.3
    if grep -q "net.ipv4.conf.all.secure_redirects = 0" /etc/sysctl.d/60-netipv4_sysctl.conf && grep -q "net.ipv4.conf.default.secure_redirects = 0" /etc/sysctl.d/60-netipv4_sysctl.conf; then
        echo "ICMP secure redirects already not accepted ✅"
    else
        if grep -q "net.ipv4.conf.all.secure_redirects = 1" /etc/sysctl.d/60-netipv4_sysctl.conf; then
            sed -i 's/net.ipv4.conf.all.secure_redirects = 1/net.ipv4.conf.all.secure_redirects = 0/' /etc/sysctl.d/60-netipv4_sysctl.conf > /dev/null
        elif grep -q "net.ipv4.conf.all.secure_redirects = 0" /etc/sysctl.d/60-netipv4_sysctl.conf; then
            echo "net.ipv4.conf.all.secure_redirects already at 0"
        else
            echo "net.ipv4.conf.all.secure_redirects = 0" | tee -a /etc/sysctl.d/60-netipv4_sysctl.conf > /dev/null
        fi

        if grep -q "net.ipv4.conf.default.secure_redirects = 1" /etc/sysctl.d/60-netipv4_sysctl.conf; then
            sed -i 's/net.ipv4.conf.default.secure_redirects = 1/net.ipv4.conf.default.secure_redirects = 0/' /etc/sysctl.d/60-netipv4_sysctl.conf > /dev/null
        elif grep -q "net.ipv4.conf.default.secure_redirects = 0" /etc/sysctl.d/60-netipv4_sysctl.conf; then
            echo "net.ipv4.conf.default.secure_redirects already at 0"
        else
            echo "net.ipv4.conf.default.secure_redirects = 0" | tee -a /etc/sysctl.d/60-netipv4_sysctl.conf > /dev/null
        fi

        # Verificatio 
        if grep -q "net.ipv4.conf.all.secure_redirects = 0" /etc/sysctl.d/60-netipv4_sysctl.conf && grep -q "net.ipv4.conf.default.secure_redirects = 0" /etc/sysctl.d/60-netipv4_sysctl.conf; then
            echo "ICMP secure redirects succesfully set to refuse ✅"
        else
            echo "An error happened when trying to disable ICMP secure redirects ❌"
            exit 1
        fi
    fi
}

LogSuspiciousPackets() {
    # 3.3.4
    if grep -q "net.ipv4.conf.all.log_martians = 1" /etc/sysctl.d/60-netipv4_sysctl.conf && grep -q "net.ipv4.conf.default.log_martians = 1" /etc/sysctl.d/60-netipv4_sysctl.conf; then
        echo "Log of suspicious packets already enabled ✅"
    else
        if grep -q "net.ipv4.conf.all.log_martians = 0" /etc/sysctl.d/60-netipv4_sysctl.conf; then
            sed -i 's/net.ipv4.conf.all.log_martians = 0/net.ipv4.conf.all.log_martians = 1/' /etc/sysctl.d/60-netipv4_sysctl.conf > /dev/null
        elif grep -q "net.ipv4.conf.all.log_martians = 1" /etc/sysctl.d/60-netipv4_sysctl.conf; then
            echo "net.ipv4.conf.all.log_martians already set to 1"
        else
            echo "net.ipv4.conf.all.log_martians = 1" | tee -a /etc/sysctl.d/60-netipv4_sysctl.conf > /dev/null
        fi

        if grep -q "net.ipv4.conf.default.log_martians = 0" /etc/sysctl.d/60-netipv4_sysctl.conf; then
            sed -i 's/net.ipv4.conf.default.log_martians = 0/net.ipv4.conf.default.log_martians = 1/' /etc/sysctl.d/60-netipv4_sysctl.conf > /dev/null
        elif grep -q "net.ipv4.conf.default.log_martians = 1" /etc/sysctl.d/60-netipv4_sysctl.conf; then
            echo "net.ipv4.conf.default.log_martians already set to 1"
        else
            echo "net.ipv4.conf.default.log_martians = 1" | tee -a /etc/sysctl.d/60-netipv4_sysctl.conf > /dev/null
        fi

        # Verification
        if grep -q "net.ipv4.conf.all.log_martians = 1" /etc/sysctl.d/60-netipv4_sysctl.conf && grep -q "net.ipv4.conf.default.log_martians = 1" /etc/sysctl.d/60-netipv4_sysctl.conf; then
            echo "Log of suspicious packets succesfully enabled ✅"
        else
            echo "An error happened when trying to enable the logging of suspicious packets ❌"
            exit 1
        fi
    fi
}

IgnoreBroadcastICMP() {
    # 3.3.5
    if grep -q "net.ipv4.icmp_echo_ignore_broadcasts = 1" /etc/sysctl.d/60-netipv4_sysctl.conf; then
        echo "Broadcast ICMP already ignored ✅"
    else
        if grep -q "net.ipv4.icmp_echo_ignore_broadcasts = 0" /etc/sysctl.d/60-netipv4_sysctl.conf; then
            sed -i 's/net.ipv4.icmp_echo_ignore_broadcasts = 0/net.ipv4.icmp_echo_ignore_broadcasts = 1/' /etc/sysctl.d/60-netipv4_sysctl.conf > /dev/null
        else
            echo "net.ipv4.icmp_echo_ignore_broadcasts = 1" | tee -a /etc/sysctl.d/60-netipv4_sysctl.conf > /dev/null
        fi

        # Verification
        if grep -q "net.ipv4.icmp_echo_ignore_broadcasts = 1" /etc/sysctl.d/60-netipv4_sysctl.conf; then
            echo "Broadcast ICMP succesfully set to ignore ✅"
        else
            echo "An error happened when trying to set ICMP broadcast to ignore ❌"
            exit 1
        fi
    fi
}

IgnoreBogusICMP() {
    # 3.3.6
    if grep -q "net.ipv4.icmp_ignore_bogus_error_responses = 1" /etc/sysctl.d/60-netipv4_sysctl.conf; then
        echo "Bogus ICMP already ignored ✅"
    else
        if grep -q "net.ipv4.icmp_ignore_bogus_error_responses = 0" /etc/sysctl.d/60-netipv4_sysctl.conf; then
            sed -i 's/net.ipv4.icmp_ignore_bogus_error_responses = 0/net.ipv4.icmp_ignore_bogus_error_responses = 1/' /etc/sysctl.d/60-netipv4_sysctl.conf > /dev/null
        else
            echo "net.ipv4.icmp_ignore_bogus_error_responses = 1" | tee -a /etc/sysctl.d/60-netipv4_sysctl.conf > /dev/null
        fi

        # Verification
        if grep -q "net.ipv4.icmp_ignore_bogus_error_responses = 1" /etc/sysctl.d/60-netipv4_sysctl.conf; then
            echo "Bogus ICMP succesfully set to ignore ✅"
        else
            echo "An error happened when trying to set bogus ICMP to ignore ❌"
            exit 1
        fi
    fi
}

ReversePathFiltering() {
    # 3.3.7
    if grep -q "net.ipv4.conf.all.rp_filter = 1" /etc/sysctl.d/60-netipv4_sysctl.conf && grep -q "net.ipv4.conf.default.rp_filter = 1" /etc/sysctl.d/60-netipv4_sysctl.conf; then
        echo "Reverse path filtering is already enabled ✅"
    else
        if grep -q "net.ipv4.conf.all.rp_filter = 0" /etc/sysctl.d/60-netipv4_sysctl.conf; then
            sed -i 's/net.ipv4.conf.all.rp_filter = 0/net.ipv4.conf.all.rp_filter = 1/' /etc/sysctl.d/60-netipv4_sysctl.conf > /dev/null
        elif grep -q "net.ipv4.conf.all.rp_filter = 1" /etc/sysctl.d/60-netipv4_sysctl.conf; then
            echo "net.ipv4.conf.all.rp_filter already set to 1"
        else
            echo "net.ipv4.conf.all.rp_filter = 1" | tee -a /etc/sysctl.d/60-netipv4_sysctl.conf > /dev/null
        fi

        if grep -q "net.ipv4.conf.default.rp_filter = 0" /etc/sysctl.d/60-netipv4_sysctl.conf; then
            sed -i 's/net.ipv4.conf.default.rp_filter = 0/net.ipv4.conf.default.rp_filter = 1/' /etc/sysctl.d/60-netipv4_sysctl.conf > /dev/null
        elif grep -q "net.ipv4.conf.default.rp_filter = 1" /etc/sysctl.d/60-netipv4_sysctl.conf; then
            echo "net.ipv4.conf.default.rp_filter already set to 1"
        else
            echo "net.ipv4.conf.default.rp_filter = 1" | tee -a /etc/sysctl.d/60-netipv4_sysctl.conf > /dev/null
        fi

        # Verification
        if grep -q "net.ipv4.conf.all.rp_filter = 1" /etc/sysctl.d/60-netipv4_sysctl.conf && grep -q "net.ipv4.conf.default.rp_filter = 1" /etc/sysctl.d/60-netipv4_sysctl.conf; then
            echo "Reverse path filtering succesfully enabled ✅"
        else
            echo "An error happened when trying to enable reverse path filtering ❌"
            exit 1
        fi
    fi
}

TCPSYNCookie() {
    # 3.3.8
    if grep -q "net.ipv4.tcp_syncookies = 1" /etc/sysctl.d/60-netipv4_sysctl.conf; then
        echo "TCP SYN cookies already set ✅"
    else
        if grep -q "net.ipv4.tcp_syncookies = 0" /etc/sysctl.d/60-netipv4_sysctl.conf; then
            sed -i 's/net.ipv4.tcp_syncookies = 0/net.ipv4.tcp_syncookies = 1/' /etc/sysctl.d/60-netipv4_sysctl.conf > /dev/null
        else
            echo "net.ipv4.tcp_syncookies = 1" | tee -a /etc/sysctl.d/60-netipv4_sysctl.conf > /dev/null
        fi

        # Verification
        if grep -q "net.ipv4.tcp_syncookies = 1" /etc/sysctl.d/60-netipv4_sysctl.conf; then
            echo "TCP SYN cookies succesfully set ✅"
        else
            echo "An error happened when trying to set TCP SYN cookies ❌"
            exit 1
        fi
    fi
}

IPv6RouterAdvertisement() {
    # 3.3.9
    if $ipv6; then
        if grep -q "net.ipv6.conf.all.accept_ra = 0" /etc/sysctl.d/60-netipv6_sysctl.conf && grep -q "net.ipv6.conf.default.accept_ra = 0" /etc/sysctl.d/60-netipv6_sysctl.conf; then
            echo "IPv6 route advertisement already refused ✅"
        else
            if grep -q "net.ipv6.conf.all.accept_ra = 1" /etc/sysctl.d/60-netipv6_sysctl.conf; then
                sed -i 's/net.ipv6.conf.all.accept_ra = 1/net.ipv6.conf.all.accept_ra = 0/' /etc/sysctl.d/60-netipv6_sysctl.conf > /dev/null
            elif grep -q "net.ipv6.conf.all.accept_ra = 0" /etc/sysctl.d/60-netipv6_sysctl.conf; then
                echo "net.ipv6.conf.all.accept_ra already set to 0"
            else
                echo "net.ipv6.conf.all.accept_ra = 0" | tee -a /etc/sysctl.d/60-netipv6_sysctl.conf > /dev/null
            fi

            if grep -q "net.ipv6.conf.default.accept_ra = 1" /etc/sysctl.d/60-netipv6_sysctl.conf; then
                sed -i 's/net.ipv6.conf.default.accept_ra = 1/net.ipv6.conf.default.accept_ra = 0/' /etc/sysctl.d/60-netipv6_sysctl.conf > /dev/null
            elif grep -q "net.ipv6.conf.default.accept_ra = 0" /etc/sysctl.d/60-netipv6_sysctl.conf; then
                echo "net.ipv6.conf.default.accept_ra already set to 0"
            else
                echo "net.ipv6.conf.default.accept_ra = 0" | tee -a /etc/sysctl.d/60-netipv6_sysctl.conf > /dev/null
            fi

            #Verification
            if grep -q "net.ipv6.conf.all.accept_ra = 0" /etc/sysctl.d/60-netipv6_sysctl.conf && grep -q "net.ipv6.conf.default.accept_ra = 0" /etc/sysctl.d/60-netipv6_sysctl.conf; then
                echo "IPv6 route advertisement succesfully set to refuse ✅"
            else
                echo "An error happened when trying to set  IPv6 route advertisement to refuse ❌"
            fi
        fi
    else
        echo "IPv6 disabled, skipping ..."
    fi
}

# Running the functions
IPv6
IPForwarding
PacketRedirect
SourceRoutedPackets
ICMPRedirects
ICMPSecureRedirects
LogSuspiciousPackets
IgnoreBroadcastICMP
IgnoreBogusICMP
ReversePathFiltering
TCPSYNCookie
IPv6RouterAdvertisement

echo "Now enabling all new modifications ..."

sysctl --system

echo "All network configuration done succesfully ✅"

if ! $ipv6; then
    echo "Suggestion : You should enable IPv6 to have a more complete system protection"
fi