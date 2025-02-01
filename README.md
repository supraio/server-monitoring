# Supra Server Monitoring

This repo collects all resources needed for the Supra Server Monitoring project.

It's mostly for a on-demand (appliance) server that is running a supra-server-daemon`.

## Installation

```bash
./install.sh
```

## Docket Compose
It uses docker compose to run the server. The `docker-compose.yml` file is included in the repo.

You can control the server using standard commands:

```bash
docker compose up -d
docker compose down
```

## Configuration
Configuration is available in the `.config` directory of the current user's home directory.

## Prometheus
- `~/.config/prometheus.yml` - Prometheus configuration file

## Grafana
- `~/.config/grafana.ini` - Grafana configuration file

## Telegraf
- `~/.config/telegraf.conf` - Telegraf configuration file
- `~/.config/telegraf/intel_gpu_top.sh` - Intel GPU top script

## Process Exporter
- `/.config/process-exporter.yml` - Process prometheus exporter configuration file
