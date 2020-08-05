# add peer script to wireguard by Eric Webb 8-3-2020 based on davidgross/wireguard-scripts
clear
if [ `whoami` != root ]; then
    echo Please run this script as root or using sudo
    exit
fi
echo
echo "Please provide the name of the user"
read -p 'Name: ' namevar
clear
echo "Creating client config for: $namevar"
mkdir -p clients/$namevar
wg genkey | tee clients/$namevar/$namevar.priv | wg pubkey > clients/$namevar/$namevar.pub
key=$(cat clients/$namevar/$namevar.priv)
ip="10.10.10."$(expr $(cat etc/last-ip.txt | tr "." " " | awk '{print $4}') + 1)
FQDN=$(hostname -f)
SERVER_PUB_KEY=$(cat /etc/wireguard/server_public_key)
cat etc/wg0-client.example.conf | sed -e 's/:CLIENT_IP:/'"$ip"'/' | sed -e 's|:CLIENT_KEY:|'"$key"'|' | sed -e 's|:SERVER_PUB_KEY:|'"$SERVER_PUB_KEY"'|' | sed -e 's|:SERVER_ADDRESS:|'"$FQD$
echo $ip > etc/last-ip.txt
echo "Created config!"
echo "Adding peer"
wg set wg0 peer $(cat clients/$namevar/$namevar.pub) allowed-ips $ip/32
wg show
echo "The key should be added"
read -p "Press any key to view conf file ..."
clear
echo "Please copy the following info into the clients conf file, then import"
echo
echo
cat  clients/$namevar/wg0.conf
