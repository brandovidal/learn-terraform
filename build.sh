# !/bin/bash

rm -rf build/ handler.zip

mkdir -p build

cp -r dist/* ./build
cp package.json ./build

cd build/
npm install --omit=dev --ignore-scripts --production
# zip -r ../handler.zip .
cd ..

cp -r build/ projects/
rm -rf build/
