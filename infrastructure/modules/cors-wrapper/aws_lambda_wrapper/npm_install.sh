#!/bin/sh
npm install axios
find . -type f -name "*" | zip -r9 -@ bootstrap.zip
aws lambda update-function-code \
  --function-name test-cors-anywhere \
  --zip-file fileb://bootstrap.zip \
  --profile username \
  > /dev/null
