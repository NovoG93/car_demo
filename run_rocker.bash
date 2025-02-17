#!/usr/bin/env bash

# Runs a docker container with the image created by build_demo.bash
# Requires
#   docker
#   nvidia-docker2
#   an X server
# Recommended
#   A joystick mounted to /dev/input/js0 or /dev/input/js1

until nvidia-docker ps
do
    echo "Waiting for docker server"
    sleep 1
done

if ! [ -x "$(command -v git)" ]; then
    echo "Rocker not found pulling from pip"
    mkdir -p /tmp/car_demo_rocker_venv
    python3 -m venv /tmp/car_demo_rocker_venv
    . /tmp/car_demo_rocker_venv/bin/activate
    pip install -U git+https://github.com/osrf/rocker.git
fi

rocker --nvidia --x11 --devices /dev/input/js0 /dev/input/js1 -- osrf/car_demo:$(git rev-parse --abbrev-ref HEAD)
