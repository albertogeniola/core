# Set variables
export HA_VERSION=2025.8.3
export BASE_IMAGE_FROM=ghcr.io/home-assistant/armv7-base-python:3.11-alpine3.17
export BASE_IMAGE_TARGET_NAME=armv7-homeassistant-base:$HA_VERSION-qnap
export HA_TARGET_IMAGE_NAME=armv7-homeassistant:$HA_VERSION-qnap

BASE_IMAGE_REPO=https://github.com/albertogeniola/homeassistant-armv7-base-image.git

# Ensure git is installed
opkg install git
opkg install git-http

# Prepare the local directory
cd /tmp
mkdir ha

# Clone git repo for base image
git clone $BASE_IMAGE_REPO
cd homeassistant-armv7-base-image
docker build --build-arg "BUILD_FROM=$BASE_IMAGE_FROM" --build-arg BUILD_ARCH=armv7 --build-arg SSOCR_VERSION=2.23.1 --build-arg LIBCEC_VERSION=6.0.2 --build-arg TELLDUS_COMMIT=2598bbed16ffd701f2a07c99582f057a3decbaf3 --build-arg PICOTTS_HASH=e3ba46009ee868911fa0b53db672a55f9cc13b1c --tag $BASE_IMAGE_TARGET_NAME .
cd ..

# Build image
git clone https://github.com/home-assistant/core.git
cd core
git checkout $HA_VERSION
docker build --build-arg "BUILD_FROM=$BASE_IMAGE_TARGET_NAME" -t $HA_TARGET_IMAGE_NAME .
