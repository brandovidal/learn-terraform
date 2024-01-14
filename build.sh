# !/bin/bash
rm -rf tmp/ handler.zip
mkdir -p tmp
cp -r dist/* ./tmp
cp package.json ./tmp
# cp pnpm-lock.yaml ./tmp

cd tmp/
npm install --production
zip -r ../handler.zip .
# cd ..
# rm -rf tmp/
