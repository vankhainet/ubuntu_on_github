#!/bin/bash
curl https://raw.githubusercontent.com/KhanhNguyen9872/ubuntu_on_github/main/config.txt > config.txt

list=$(cat << EOF
ngrok_authtoken
ngrok_region
password
EOF
)

while IFS= read -r var; do
    eval ${var}=$(cat ./config.txt | grep -w -a -m1 "${var}" | sed "s/:/ /g" | awk '{print $2}')
    if [[ ${!var} == "" ]] 2> /dev/null || [ -z ${!var} ] 2> /dev/null; then
        echo "Config error!"
        echo "Please edit the config.txt file in repo!"
        exit 1
    fi
done < <(printf '%s\n' "$list")

wget -O ngrok-stable-linux-amd64.zip https://raw.githubusercontent.com/KhanhNguyen9872/ubuntu_on_github/main/ngrok-stable-linux-amd64.zip > /dev/null 2>&1
unzip ngrok-stable-linux-amd64.zip > /dev/null 2>&1
chmod 777 ./ngrok
./ngrok authtoken $ngrok_authtoken

wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt update -y
sudo apt install apt-transport-https sublime-text xfce4 xarchiver firefox-esr mesa-utils git xfce4-goodies pv nmap nano apt-utils dialog terminator autocutsel dbus-x11 dbus neofetch perl p7zip unzip zip curl tar git python3 python3-pip net-tools openssl tigervnc-standalone-server tigervnc-xorg-extension -y
export HOME="$(cd ~/; pwd)"
export DISPLAY=":0"
mkdir ~/.vnc 2> /dev/null
chmod -R 777 ~/.config
printf '#!/bin/bash\ndbus-launch &> /dev/null\nautocutsel -fork\nxfce4-session\n' > ~/.vnc/xstartup
chmod 777 ~/.vnc/xstartup

unset DBUS_LAUNCH
nohup sudo ./ngrok tcp --region ${ngrok_region} 127.0.0.1:5900 &> /dev/null &
vncserver -kill :0 &> /dev/null 2> /dev/null
sudo rm -rf /tmp/* 2> /dev/null
vncserver :0 << EOF
${password}
${password}
y
${password}
${password}

EOF

printf "\n\n\n\nYour IP here: "
curl --silent --show-error http://127.0.0.1:4040/api/tunnels | sed -nE 's/.*public_url":"tcp:..([^"]*).*/\1/p'
printf "\n\n\n\n\n"
seq 1 9999999999999 | while read i; do echo -en "\r Running .     $i s /9999999999999 s";sleep 0.1;echo -en "\r Running ..    $i s /9999999999999 s";sleep 0.1;echo -en "\r Running ...   $i s /9999999999999 s";sleep 0.1;echo -en "\r Running ....  $i s /9999999999999 s";sleep 0.1;echo -en "\r Running ..... $i s /9999999999999 s";sleep 0.1;echo -en "\r Running     . $i s /9999999999999 s";sleep 0.1;echo -en "\r Running  .... $i s /9999999999999 s";sleep 0.1;echo -en "\r Running   ... $i s /9999999999999 s";sleep 0.1;echo -en "\r Running    .. $i s /9999999999999 s";sleep 0.1;echo -en "\r Running     . $i s /9999999999999 s";sleep 0.1; done
