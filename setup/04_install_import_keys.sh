#! /bin/bash

OURNAME=04_install_import_keys.sh

echo -e "\n-- Executing ${ORANGE}${OURNAME}${NC} subscript --"

# create user for running applications
useradd gmi-mail || echo "User gmi-mail already exists"

# remove old sudoers file
rm -rf /etc/sudoers.d/gmi-mail

# create user for deploying code
useradd deploy || echo "User deploy already exists"

mkdir -p /home/deploy/.ssh
# add your own key to the authorized_keys file
echo "# Add your public key here
" >> /home/deploy/.ssh/authorized_keys
chown -R deploy:deploy /home/deploy

export DEBIAN_FRONTEND=noninteractive

# nodejs
wget -qO- https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -
echo "deb https://deb.nodesource.com/$NODEREPO $CODENAME main" > /etc/apt/sources.list.d/nodesource.list
echo "deb-src https://deb.nodesource.com/$NODEREPO $CODENAME main" >> /etc/apt/sources.list.d/nodesource.list

# mongo keys
wget -qO- https://www.mongodb.org/static/pgp/server-${MONGODB}.asc | apt-key add
echo "deb [ arch=amd64 ] http://repo.mongodb.org/apt/ubuntu $CODENAME/mongodb-org/$MONGODB multiverse" > /etc/apt/sources.list.d/mongodb-org.list

# rspamd
wget -O- https://rspamd.com/apt-stable/gpg.key | apt-key add -
echo "deb http://rspamd.com/apt-stable/ $CODENAME main" > /etc/apt/sources.list.d/rspamd.list
echo "deb-src http://rspamd.com/apt-stable/ $CODENAME main" >> /etc/apt/sources.list.d/rspamd.list
apt-get update

# redis
apt-add-repository -y ppa:chris-lea/redis-server
