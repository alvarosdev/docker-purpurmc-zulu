PURPURMC_VERSION=$1
PURPURMC_DOWNLOAD_URL="https://api.purpurmc.org/v2/purpur/${PURPURMC_VERSION}/latest/download"
curl -s -o purpurmc.jar ${PURPURMC_DOWNLOAD_URL}
