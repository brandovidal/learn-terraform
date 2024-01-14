# !/bin/bash

rm -rf tmp/ handler.zip

mkdir -p tmp

cp -r dist/* ./tmp
cp package.json ./tmp

cd tmp/
npm install --omit=dev --ignore-scripts --production
zip -r ../handler.zip .
# cd ..
# rm -rf tmp/
