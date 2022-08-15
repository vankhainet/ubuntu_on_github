#!/bin/bash
curl https://raw.githubusercontent.com/usertest9872/ubuntu_on_github/main/config.txt > config.txt

list=$(cat << EOF
ngrok_authtoken
ngrok_region
password
EOF
)

printf "\n Read config.txt....\n"
while IFS= read -r var; do
    eval ${var}=$(cat ./config.txt | grep -w -a -m1 "${var}" | sed "s/:/ /g" | awk '{print $2}')
    if [[ ${!var} == "" ]] 2> /dev/null || [ -z ${!var} ] 2> /dev/null; then
        echo "Config error!"
        echo "Please edit the config.txt file in repo!"
        exit 1
    else
        echo "${var} OK"
    fi
done < <(printf '%s\n' "$list")

wget -O ngrok-stable-linux-amd64.zip https://raw.githubusercontent.com/usertest9872/ubuntu_on_github/main/ngrok-stable-linux-amd64.zip > /dev/null 2>&1
unzip ngrok-stable-linux-amd64.zip > /dev/null 2>&1
chmod 777 ./ngrok
./ngrok authtoken $ngrok_authtoken > /dev/null 2>&1

printf "\n\n Instaling.....\n"
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add - > /dev/null 2>&1
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list > /dev/null 2>&1
sudo apt update -y > /dev/null 2>&1
sudo apt install apt-transport-https sublime-text xfce4 xarchiver mesa-utils git xfce4-goodies pv nmap nano apt-utils dialog terminator autocutsel dbus-x11 dbus neofetch perl p7zip unzip zip curl tar git python3 python3-pip net-tools openssl tigervnc-standalone-server tigervnc-xorg-extension -y > /dev/null 2>&1
export HOME="$(cd ~/; pwd)"
export DISPLAY=":0"
mkdir ~/.vnc > /dev/null 2>&1
chmod -R 777 ~/.config > /dev/null 2>&1
printf '#!/bin/bash\ndbus-launch &> /dev/null\nautocutsel -fork\nxfce4-session\n' > ~/.vnc/xstartup 2> /dev/null
chmod 777 ~/.vnc/xstartup > /dev/null 2>&1

printf "\n\n Setting up VNC Ubuntu 22.04.....\n"
unset DBUS_LAUNCH
nohup sudo ./ngrok tcp --region ${ngrok_region} 127.0.0.1:5900 &> /dev/null &
vncserver -kill :0 &> /dev/null 2> /dev/null
sudo rm -rf /tmp/* 2> /dev/null
vncpasswd << EOF
${password}
${password}
y
${password}
${password}

EOF

printf "\n\n Starting VNC Ubuntu 22.04.....\n"
vncserver -localhost yes -geometry 1280x720 :0

printf "\n\n\n\nYour IP here: "
curl --silent --show-error http://127.0.0.1:4040/api/tunnels | sed -nE 's/.*public_url":"tcp:..([^"]*).*/\1/p'
printf "\n\n\n\n\n Use VNC Viewer to connect!\n\n"
sleep 9999999999999999999999999999999999999
