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
5. Install rclone
`sudo apt install rclone -y`
6. Configure rclone
`rclone config`
7. Create cron job to synchronize backup folder
`*/30 * * * * rclone sync /path/to/local/folder drive:foldername`
8. Create cron job to run backup script
`0 2 * * * /path/to/backup/script.sh`