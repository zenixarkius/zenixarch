#include "/opt/cuda/targets/x86_64-linux/include/nvml.h"
#include <stdio.h>
#include <stdlib.h>

int check(nvmlReturn_t status) {
    if (status != NVML_SUCCESS) {
        printf("Error: %s\n", nvmlErrorString(status));
        exit(1);
    }
    else {
        return 0;
    }
}

int main() {
    nvmlDevice_t device;

    check(nvmlInit());
    check(nvmlDeviceGetHandleByIndex(0, &device));
    check(nvmlDeviceSetGpcClkVfOffset(device, 210));
    check(nvmlDeviceSetMemClkVfOffset(device, 3000));

    printf("Overclocks applied successfully!\n");
    return 0;
}
