#!/bin/bash
cmdProxy='command'
command type sudo &> /dev/null && cmdProxy='sudo'

PATH=$PATH:/home/apprenant/Bureau/projet_script

user=$USER
echo $user
cd /home/$user/Bureau
mkdir dockerWordpress
cd dockerWordpress
touch dockerServer
${cmdProxy} cat <<END > dockerServer
FROM httpd:latest

WORKDIR /usr/local/apache2/htdocs

EXPOSE 80

RUN apt-get update && apt-get install -y mysql-client && apt-get install -y php5 php5-cli libapache2-mod-php5 && a2enmod php5 && service apache2 restart && wp-cli_scrip.sh
END

#Installation du docker mysql
IdDockMysql=$(${cmdProxy} docker run --name mysql -e MYSQL_ROOT_PASSWORD=0000 -d mysql:latest)
IdDockMysql=$(echo ${IdDockMysql}| cut -c1-12)
echo ${IdDockMysql}

#Installation du docker apache2
IdDockMysql= ps -aqf "name=mysql"
${cmdProxy} docker build -f dockerServer -t apache .
IdImageApache=$(${cmdProxy} docker images --filter=reference='apache' -q)
IdDockApache=$(${cmdProxy} docker run --name apache --link ${IdDockMysql} -p 4000:80 -d apache)
IdDockApache=$(echo ${IdDockApache}| cut -c1-12)
echo ${IdDockApache}

