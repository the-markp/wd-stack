# wd-stack
Containerized stack with Caddy, PHP, MySQL, PhpMyAdmin

1. Clone the repository
2. Update domain names and reverse proxy configuration from caddy/Caddyfile
3. Update usernames and password in docker-compose.yml
4. Run docker compose up -d

# ubuntu-host-setup
1. Install docker and docker-compose
2. Setup firewall to allow ports 80, 443, and 3306
`sudo ufw allow 80,443,3306/tcp`
3. Enable ufw
`sudo ufw enable`
4. Install zip
`sudo apt install zip -y`
5. Add cron job to run daily backup at 2AM
`sudo crontab -e`
`0 2 * * * /path/to/your/backup_script.sh`