#!/bin/bash
# I'm using the "Jq" CLI library for this:
# https://stedolan.github.io/jq/ (brew install jq)

# print out all commands as they're run
#set -x

DOMAIN="$1"
echo "Requesting certificates for ${DOMAIN} ..."
# The "Origin CA Key"
AUTH_KEY="$2"
COUNTRY="$3"
STATE="$4"
CITY="$5"
COMPANY="$6"
DEPARTMENT="$7"

# Generate both the private key and the CSR
openssl req -new -newkey rsa:2048 -nodes -out ${DOMAIN}--csr.txt -keyout ${DOMAIN}--private.txt -subj "/C=${COUNTRY}/ST=${STATE}/L=${CITY}/O=${COMPANY}/OU=${DEPARTMENT}/CN=${DOMAIN}"

CSR=$(cat ${DOMAIN}--csr.txt)
CSRNEWLINES="${CSR//$'\n'/\n}"
DATA="{\"hostnames\":[\"${DOMAIN}\",\"*.${DOMAIN}\"],\"requested_validity\":5475,\"request_type\":\"origin-rsa\",\"csr\":\"${CSRNEWLINES}\"}"

echo "Sending request to CloudFlare: "

# Curl the CloudFlare API for 

curl -X POST https://api.cloudflare.com/client/v4/certificates/ \
-H "Content-Type: application/json" \
-H "Accept: application/json" \
-H "X-AUTH-USER-SERVICE-KEY: $AUTH_KEY" \
--data "$DATA" \
| jq '.' | jq -r '.result .certificate' > "${DOMAIN}--cert.txt"


echo -e "\nCloudFlare request complete."
