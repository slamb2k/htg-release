Param(
  [Parameter(Mandatory=$true)] 
  [string]$packagesToken,
  [Parameter(Mandatory=$false)] 
  [string]$server = "192.168.0.230",
  [Parameter(Mandatory=$false)] 
  [int]$port = 3030,
  [Parameter(Mandatory=$false)] 
  [int]$timeOffset = 4     
) 

# login to docker
Write-Output $packagesToken | docker login ghcr.io -u USERNAME --password-stdin

# Create docker compose directory (overwrite if exists)
New-Item -Path "c:\" -Name "htg-display" -ItemType "directory" -Force

# create docker-compose file (overwrite if exists)
New-Item -Path "C:\htg-display\" -Name "docker-compose.yml" -Force -ItemType File -Value @"
# Production docker compose [latest] used for production
version: '3'
services:
  api:
    image: ghcr.io/htcdevelopment/htg-display-server:latest
    restart: unless-stopped
    environment:
      LAS_API_IP: $server
      LAS_API_PORT: 9090
      GET_INTERVAL_MS: 2000
      REPAGE_INTERVAL_MIN: 2
      CONTINUOUS_ALARM_INTERVAL_MS: 5000
    ports:
      - "3030:3030"
    networks:
      - htg-net

  react:
    image: ghcr.io/htcdevelopment/htg-display-client:latest
    restart: unless-stopped
    environment:
      REACT_APP_SOCKET_SERVER: $server
      REACT_APP_SOCKET_SERVER_PORT: $port
      REACT_APP_TIME_OFFSET: $timeOffset
    ports:
      - "3000:3000"
    networks:
      - htg-net

networks:
  htg-net:
"@

# create update script
New-Item -Path "C:\htg-display\" -Name "docker-update.cmd" -Force -ItemType File -Value @"
cd c:\htg-display\
docker-compose down
docker pull ghcr.io/htcdevelopment/htg-display-server:latest
docker pull ghcr.io/htcdevelopment/htg-display-client:latest
docker-compose up -d
"@

# create restart script
New-Item -Path "C:\htg-display\" -Name "docker-start-or-restart.cmd" -Force -ItemType File -Value @"
cd c:\htg-display
docker-compose down
docker-compose up -d
"@

# create down script
New-Item -Path "C:\htg-display\" -Name "docker-stop.cmd" -Force -ItemType File -Value @"
cd c:\htg-display
docker-compose down
"@

Write-Host "`n"
Write-Host "To start or restart services, run => docker-start-or-restart.cmd in c:\htg-display\ folder." -ForegroundColor Green
Write-Host "To update then start services, run => docker-update.cmd in c:\htg-display\ folder." -ForegroundColor Green
Write-Host "To stop services, run => docker-stop.cmd in c:\htg-display\ folder." -ForegroundColor Green
Write-Host "`n"

# update containers
Write-Host "Updating containers..." -ForegroundColor Yellow
C:\htg-display\docker-update.cmd

Read-Host "Press [enter] to continue.."

