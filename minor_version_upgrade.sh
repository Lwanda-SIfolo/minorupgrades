
#!/bin/bash

timestamp=$(date +%F-%T)

# Upgrade Ubuntu OS

sudo DEBIAN_FRONTEND=noninteractive apt-get -yq update
sudo DEBIAN_FRONTEND=noninteractive apt-get -yq upgrade

# Enable Moodle maintenance mode

sudo php /var/www/html/admin/cli/maintenance.php --enable

# Backup the Moodle software directory
# Remove existing backup tar file first

sudo find /var/www -type f -name 'moodle_backup_*.tar.gz' -exec rm {} +
sudo tar -czvf /var/www/moodle_backup_$timestamp.tar.gz  /var/www/html

# Upgrade Moodle software

cd /var/www/html
sudo git reset --hard
sudo git pull
sudo php admin/cli/upgrade.php --non-interactive

# Reset permissions

sudo chown -R www-data /var/moodledata
sudo chmod -R 750 /var/moodledata
sudo chmod -R 0755 /var/www/html

# Disable maintenance mode

sudo php /var/www/html/admin/cli/maintenance.php --disable

# Restart Apache

sudo systemctl restart apache2

# TODOS
