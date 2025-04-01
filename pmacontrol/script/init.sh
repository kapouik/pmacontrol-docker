#!/bin/bash

if [[ ! -f /configuration/init.lock ]]
	then
		echo "App/Webroot/index.php install webroot"
		/usr/local/bin/php App/Webroot/index.php install webroot /tmp/config.json
		echo "App/Webroot/index.php install index"
		/usr/local/bin/php App/Webroot/index.php install index /tmp/config.json
		echo "App/Webroot/index.php install createOrganisation"
		/usr/local/bin/php App/Webroot/index.php install createOrganisation /tmp/config.json
		echo "App/Webroot/index.php install createAdmin"
		/usr/local/bin/php App/Webroot/index.php install createAdmin /tmp/config.json
		echo "App/Webroot/index.php ldap updateFromInstall"
		/usr/local/bin/php App/Webroot/index.php ldap updateFromInstall /tmp/config.json
		echo "App/Webroot/index.php webservice addAccount"
		/usr/local/bin/php App/Webroot/index.php webservice addAccount /tmp/config.json
		echo "App/Webroot/index.php control createTsTable"
		/usr/local/bin/php App/Webroot/index.php control createTsTable 
		echo "App/Webroot/index.php agent updateServerList"
		/usr/local/bin/php App/Webroot/index.php agent updateServerList 
		echo "App/Webroot/index.php administration generate_model"
		/usr/local/bin/php App/Webroot/index.php administration generate_model 
		echo "App/Webroot/index.php administration admin_table"
		/usr/local/bin/php App/Webroot/index.php administration admin_table
		sed -ri -e 's!/pmacontrol/!/!' configuration/webroot.config.php
		touch /configuration/init.lock
fi

echo "glial agent check_daemon"
/usr/local/bin/php glial agent check_daemon
echo "glial control service"
/usr/local/bin/php glial control service

chown -R www-data:www-data tmp/log tmp/database

apache2-foreground
