#!/bin/bash

(( EUID == 0 )) || { echo "This script needs to be run as root"; exit 1; }

pacman -S --noconfirm --needed nvidia

cat > /etc/systemd/system/overclock.service << 'SERVICE'
[Unit]
Description=Set NVIDIA overclocks

[Service]
ExecStart=/bin/bash -c '\
if [ ! -d /opt/nvml ]; then \
    python -m venv /opt/nvml; \
    chown -R user:user /opt/nvml; \
    runuser -u user -- /opt/nvml/bin/pip install --upgrade pip; \
    runuser -u user -- /opt/nvml/bin/pip install nvidia-ml-py; \
fi; \
runuser -u user -- /opt/nvml/bin/pip install --upgrade nvidia-ml-py; \
/opt/nvml/bin/python -c "from pynvml import *; nvmlInit(); myGPU=nvmlDeviceGetHandleByIndex(0); nvmlDeviceSetGpcClkVfOffset(myGPU,210); nvmlDeviceSetMemClkVfOffset(myGPU,3000)" \
'

[Install]
WantedBy=multi-user.target
SERVICE

systemctl enable $NOW overclock.service
