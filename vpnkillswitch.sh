#!/bin/bash
 
# process arguments
while getopts ":edt:" opt; do
    case ${opt} in
        e)
            # ENABLE KILLSWITCH
            # Default policies
            ufw default deny incoming
            ufw default deny outgoing
             
            # Openvpn interface (adjust interface accordingly to your configuration)
            ufw allow out on tun0
 
            # Openvpn (adjust port accordingly to your vpn setup)
            ufw allow out to any port 1194
            ;;
        d)
            # DISABLE KILLSWITCH
            ufw --force reset
            ufw enable
 
            # delete backUP rules from reset
            rm /etc/ufw/*.rules.*
             
            # reset to defaults and enable
            ufw default deny incoming
            ufw default allow outgoing
            ;;
        t) 
            # ADD OUTGOING RULE
            echo "allow outgoing traffic to $OPTARG"
            ufw allow out to $OPTARG
            ;;
    esac
done
 
if (( $OPTIND == 1 )); then
    echo " "
    echo -e "Please provide at least one of the following options:\n    -e"
    echo "        enable killswitch"
    echo "    -d"
    echo "        disable killswitch"
    echo "    -t [CIDR]"
    echo -e "        open outgoing ufw rule to a specific CIDR (ip address or range)\n"
fi