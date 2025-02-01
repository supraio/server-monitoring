#!/bin/sh
JSON=$(/usr/bin/timeout --preserve-status -s SIGINT -k 2 2 /usr/bin/intel_gpu_top -J -s 1000)
# you may need to wrap the below ${JSON} in square brackets depending on your intel_gpu_top version
echo "${JSON}"
