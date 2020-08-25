## Guacamole Install
#### Ubuntu 18.04 base
apt update && apt upgrade -y
apt install -y software-properties-common
<!-- add-apt-repository ppa:guacamole/stable -->
apt-get install guacamole-tomcat
apt-get install libguac-client-ssh0 libguac-client-rdp0

ln -s /var/lib/guacamole/guacamole.war /var/lib/tomcat8/webapps
mkdir /usr/share/tomcat8/.guacamole
ln -s /etc/guacamole/guacamole.properties /usr/share/tomcat8/.guacamole/

/etc/init.d/tomcat8 restart
/etc/init.d/guacd start



----
apt-get update -y
apt-get upgrade -y
apt-get install gcc-6 g++-6 libossp-uuid-dev libavcodec-dev libpango1.0-dev libssh2-1-dev libcairo2-dev libjpeg-turbo8-dev libpng-dev libavutil-dev libswscale-dev libfreerdp-dev libvncserver-dev libssl-dev libvorbis-dev libwebp-dev -y
wget https://downloads.apache.org/guacamole/1.1.0/source/guacamole-server-1.1.0.tar.gz
tar xzf guacamole-server-1.1.0.tar.gz
cd guacamole-server-1.1.0
./configure --with-init-dir=/etc/init.d
make
make install
ldconfig

systemctl enable guacd
systemctl start guacd

apt install tomcat9 tomcat9-admin tomcat9-common tomcat9-user -y
mkdir /etc/guacamole
wget https://downloads.apache.org/guacamole/1.1.0/binary/guacamole-1.1.0.war -O /etc/guacamole/guacamole.war
ln -s /etc/guacamole/guacamole.war /var/lib/tomcat9/webapps/
systemctl restart tomcat9
systemctl restart guacd

mkdir /etc/guacamole/{extensions,lib}
echo "GUACAMOLE_HOME=/etc/guacamole" >> /etc/default/tomcat9

add below to /etc/guacamole/guacamole.properties:
guacd-hostname: localhost
guacd-port:     4822
user-mapping:   /etc/guacamole/user-mapping.xml
auth-provider:  net.sourceforge.guacamole.net.basic.BasicFileAuthenticationProvider

ln -s /etc/guacamole /usr/share/tomcat9/.guacamole

Get password hash with:
echo -n password | openssl md5

add below to /etc/guacamole/user-mapping.xml:
<user-mapping>
    <authorize
            username="abc"
            password="900150983cd24fb0d6963f7d28e17f72"
            encoding="md5">
        <protocol>rdp</protocol>
        <param name="hostname">127.0.0.1</param>
        <param name="port">3389</param>
        <param name="color-depth">16</param>
        <param name="ignore-cert">true</param>
        <param name="username">abc</param>
        <param name="password">abc</param>
    </authorize>
</user-mapping>


systemctl restart tomcat9 guacd

--- VNC
sudo apt install xfce4 xfce4-goodies
sudo apt install tightvncserver
vncserver  --> then configure

vncserver -kill :1
edit ~/.vnc/xstartup:
    #!/bin/sh

    xrdb $HOME/.Xresources
    startxfce4 &

chmod +x ~/.vnc/xstartup
vncserver

Changed /etc/guacamole/user-mapping.xml to:
<user-mapping>
    <authorize
            username="matt"
            password="5f4dcc3b5aa765d61d8327deb882cf99"
            encoding="md5">
        <protocol>vnc</protocol>
        <param name="hostname">127.0.0.1</param>
        <param name="port">5901</param>
        <param name="color-depth">16</param>
        <param name="ignore-cert">true</param>
        <param name="username">root</param>
        <param name="password">**********</param>
    </authorize>
</user-mapping>
