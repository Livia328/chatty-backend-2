#!/bin/bash

function program_is_installed {
  local return_=1

  type $1 >/dev/null 2>&1 || { local return_=0; }
  echo "$return_"
}

if [ $(program_is_installed zip) == 0 ]; then
  apk update
  apk add zip
fi

# aws s3 sync s3://liviachatapp-env-files/develop .
aws s3 sync s3://liviachatapp-env-files/backend/develop . # update with your s3 bucket #check inside the sub folder in the bucket and download
unzip env-file.zip #pass as a zip file, so unzip
cp .env.develop .env
rm .env.develop
sed -i -e "s|\(^REDIS_HOST=\).*|REDIS_HOST=redis://$ELASTICACHE_ENDPOINT:6379|g" .env #find every path start with redis, and replace
rm -rf env-file.zip
cp .env .env.develop
zip env-file.zip .env.develop
# aws --region us-west-1 s3 cp env-file.zip s3://liviachatapp-env-files/develop/ # update with your s3 bucket
aws --region us-west-1 s3 cp env-file.zip s3://liviachatapp-env-files/backend/develop/ # update with your s3 bucket
rm -rf .env*
rm -rf env-file.zip
