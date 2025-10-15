#!/bin/bash

## Extras should only be ran by zarchinstall

(( EUID == 0 )) || { echo "This script needs to be run as root"; exit 1; }

cat > /etc/systemd/system/overclock.service << 'SERVICE'
[Unit]
Description=Set NVIDIA overclocks

[Service]
ExecStart=/bin/bash -c '\
if [ ! -d /tmp/nvml ]; then \
    python -m venv /tmp/nvml; \
    chown -R user:user /tmp/nvml; \
    runuser -u user -- /tmp/nvml/bin/pip install --upgrade pip; \
    runuser -u user -- /tmp/nvml/bin/pip install nvidia-ml-py; \
fi; \
runuser -u user -- /tmp/nvml/bin/pip install --upgrade nvidia-ml-py; \
/tmp/nvml/bin/python -c "from pynvml import *; nvmlInit(); myGPU=nvmlDeviceGetHandleByIndex(0); nvmlDeviceSetGpcClkVfOffset(myGPU,210); nvmlDeviceSetMemClkVfOffset(myGPU,3000)" \
'

[Install]
WantedBy=multi-user.target
SERVICE

systemctl enable $NOW overclock
