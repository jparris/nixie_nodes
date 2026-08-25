sudo podman pull homeassistant/home-assistant:stable
sudo systemctl restart podman-hass.service
sudo podman pull pihole/pihole
sudo systemctl restart podman-pihole.service
sudo podman pull zwavejs/zwavejs2mqtt:latest
sudo systemctl restart podman-zwavejs.service
sudo podman pull zigbee2mqtt
sudo systemctl restart podman-zigbee2mqtt.service
