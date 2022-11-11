#!/bin/sh

user=vilas
pass=Vilas500

gen_3proxy() {
    cat <<EOF
daemon
maxconn 500
nserver 1.1.1.1
nserver 1.0.0.1
nserver 2606:4700:4700::64
nserver 2606:4700:4700::6400
nscache 65536
timeouts 1 5 30 60 180 1800 15 60
setgid 65535
setuid 65535
stacksize 6291456
auth strong
users $user:CL:$pass
allow $user
$(awk -F "/" '{print "proxy -6 -n -a -p" $4 " -i" $3 " -e"$5""}' "${WORKDATA}")
flush
EOF
}

pkill -f 3proxy
sleep 5

echo "working folder = /home/proxy-installer"
WORKDIR="/home/proxy-installer"
WORKDATA="${WORKDIR}/data.txt"

gen_3proxy >/usr/local/etc/3proxy/3proxy.cfg

chmod +x $WORKDIR/*.sh
ulimit -n 65535
/usr/local/etc/3proxy/bin/3proxy /usr/local/etc/3proxy/3proxy.cfg &
history -c