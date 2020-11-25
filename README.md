# FastDownload Pterodactyl v1.0
Automatic script what detects the creation & deletion of a server, and detect if the server is a Valve Game (Source/SRCDS)
AppID | Game | Supported
------------ | ------------- | :--:
~ | If you test a game and see it's working contact me to add to the list | ⚠️
~ | All HL1/HL2 games and mods | ✅ 
440 | [Team Fortress 2](http://store.steampowered.com/app/440/) | ✅ 
500 | [Left 4 Dead](http://store.steampowered.com/app/500/) | ✅ 
550 | [Left 4 Dead 2](http://store.steampowered.com/app/550/) | ✅ 
730 | [Counter-Strike: Global Offensive](http://store.steampowered.com/app/730/) | ✅ 
4000 | [Garry's Mod](http://store.steampowered.com/app/4000/) | ✅ 
225840 | [Sven Coop](http://store.steampowered.com/app/225840/) | ✅


## Requirements
* Pterodactyl Wings 1.0
* Pterodactyl Panel - __API Key__ - Used to retrieve the game
![Admin -> Application API](https://media.discordapp.net/attachments/771623753536110602/781149554044960768/unknown.png?width=1442&height=456)
![Create New API Key with (Nodes - read/Servers - read/Eggs - read)](https://media.discordapp.net/attachments/771623753536110602/781150522576994304/unknown.png?width=1442&height=456)
* Web Server (LiteSpeed/Apache/Nginx or others)

## Installation

```bash
sudo apt-get install -y inotify-tools curl
```

1. Run the command below to assign user www-data to group pterodactyl
  * ``` gpasswd -a www-data pterodactyl ```
2. Run the commands below to set group permissions for read and exec
  * ``` chmod 755 /var/lib/pterodactyl/ && chmod 755 /var/lib/pterodactyl/volumes/ ```
3. Add the command below in the last line of Eggs "Install script"
  * ``` chmod -R 750 /mnt/server/ ```
4. If you currently have servers installed, you can reinstall to set the new permissions or set manually running the command below (change UUID for your game server UUID):
  * ``` chmod -R 750 /var/lib/pterodactyl/volumes/UUID/ ```
   <br>Example: ``` chmod -R 750 /var/lib/pterodactyl/volumes/5267701d-8aa0-4071-a3f7-953a5a8e0a79/ ```
5. Put the scripts in their folders.
  * fastdl.sh - /etc/pterodactyl/fastdl.sh
  * fastdl.service - /etc/systemd/system/fastdl.service
6. Change the values below with yours details
   ```#!/bin/bash
    HOME_URL="https://node.pterodactyl.io" 
    API_KEY="YOUR_GENERATED_API_KEY"
    FASTDL="/var/www/fastdl" 
7. Enable the FastDL Service
  * ```systemctl enable fastdl```

## Nginx Configuration

### Without SSL:
```
server {
    listen 80;
    listen [::]:80;

	root /var/lib/pterodactyl/volumes;
	index index.html;

	server_name <domain>;

	location / {
		# First attempt to serve request as file, then
		# as directory, then fall back to displaying a 404.
		try_files $uri $uri/ =404;
		# Comment this line if dont want to list files (only after checking that your fastdl works)
		autoindex on;
	}
}
```
### With SSL:
```
server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    ssl on;
    ssl_certificate         /etc/ssl/certs/serverscstrike.com-cert.pem;
    ssl_certificate_key     /etc/ssl/private/serverscstrike.com-key.pem;

	root /var/lib/pterodactyl/volumes;
	index index.html;

	server_name <domain>;

	location / {
		# First attempt to serve request as file, then
		# as directory, then fall back to displaying a 404.
		try_files $uri $uri/ =404;
		# Comment this line if dont want to list files (only after checking that your fastdl works)
		autoindex on;
	}

	location ~\.(sma|amxx|sp|smx|cfg|ini|log|bak|dat|sql|sq3|so|dll|php|zip|rar|jar|sh)$ {
		return 403;
	}
}
```
### If you only want to add fastdl to a current nginx config, only add this, your fastdl will be: <domain>/fastdl 
```
  location ^~ /fastdl {
	alias /var/www/pterodactyl-fastdl;

	# First attempt to serve request as file, then
	# as directory, then fall back to displaying a 404.
	try_files $uri $uri/ =404;
	# Comment this line if dont want to list files (only after checking that your fastdl works)
	autoindex on;

	location ~\.(sma|amxx|sp|smx|cfg|ini|log|bak|dat|sql|sq3|so|dll|php|zip|rar|jar|sh)$ {
		return 403;
	}
}
```
## FastDL URL Link
* http://DomainOrIPv4/UUID/
* https://DomainOrIPv4/UUID/

## Contact
* Discord: Scai#8477

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.
Please make sure to update tests as appropriate.

## License
[GNU General Public License v3.0](https://choosealicense.com/licenses/gpl-3.0/)
