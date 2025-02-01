#!/bin/bash

# Install Docker if not already installed
if ! [ -x "$(command -v docker)" ]; then
  echo "Docker is not installed. Installing Docker..."
  sudo apt-get update
  sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
  sudo apt-get update
  sudo sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  sudo usermod -aG docker ${USER}
  echo "Docker installed successfully."
else
  echo "Docker is already installed."
fi

LOCAL_IP_ADDRESS=$(hostname -I | awk '{print $1}')

# Install config files
mkdir -p $HOME/.config/
cp ./prometheus.yml $HOME/.config/prometheus.yml
cp ./process-exporter.yml $HOME/.config/process-exporter.yml
cp ./grafana.ini $HOME/.config/grafana.ini
cp ./telegraf.conf $HOME/.config/telegraf.conf
mkdir -p $HOME/.config/telegraf/
cp ./intel_gpu_top.sh $HOME/.config/telegraf/intel_gpu_top.sh

# Prepare data directory
sudo mkdir -p /data/

sudo mkdir -p /data/grafana/
sudo chown 472:472 /data/grafana/

sudo mkdir -p /data/prometheus/
sudo chown 65534:65534 /data/prometheus/

# Start all containers
docker compose up -d

echo "Sleeping for 5 seconds to start all containers..."
sleep 5

# Initial setup
docker compose exec telegraf sh -c "apt update && apt install -y intel-gpu-tools"

# Replace __USER__ placeholder with the actual user in process-exporter.yml
sed -i "s/__USER__/$USER/g" $HOME/.config/process-exporter.yml

# Let user paste grafana Admin token if not already provided
if [ cat $HOME/.config/telegraf.conf | grep "__GRAFANA_API_KEY__" ]; then
	echo "Please paste the Grafana Admin token for Telegraf (http://$LOCAL_IP_ADDRESS:3000/org/serviceaccounts/create)"
	read -p "Grafana Admin token: " GRAFANA_ADMIN_TOKEN
	# Replace __GRAFANA_API_KEY__ placeholder with the actual token in telegraf.conf
	sed -i "s/__GRAFANA_API_KEY__/$GRAFANA_ADMIN_TOKEN/g" $HOME/.config/telegraf.conf
	# Restart Telegraf to apply the changes
	docker compose restart telegraf
fi


echo "Setup complete. You can now access Grafana at http://$LOCAL_IP_ADDRESS:3000"