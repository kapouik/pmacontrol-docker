#!/bin/bash

if [[ /configuration/init.lock ]]
	then
		sleep 15
		/usr/local/bin/php App/Webroot/index.php install webroot /tmp/config.json
		/usr/local/bin/php App/Webroot/index.php install index /tmp/config.json
		/usr/local/bin/php App/Webroot/index.php install createOrganisation /tmp/config.json
		/usr/local/bin/php App/Webroot/index.php install createAdmin /tmp/config.json
		/usr/local/bin/php App/Webroot/index.php ldap updateFromInstall /tmp/config.json
		/usr/local/bin/php App/Webroot/index.php webservice addAccount /tmp/config.json
		/usr/local/bin/php App/Webroot/index.php control createTsTable 
		/usr/local/bin/php App/Webroot/index.php agent updateServerList 
		/usr/local/bin/php App/Webroot/index.php administration generate_model 
		/usr/local/bin/php App/Webroot/index.php administration admin_table
		sed -ri -e 's!/pmacontrol/!/!' configuration/webroot.config.php
		touch /configuration/init.lock
fi

apache2-foreground
