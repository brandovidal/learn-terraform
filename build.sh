# !/bin/bash

rm -rf build/ handler.zip projects/build/

cp -r dist/ build/

# mkdir -p build

cd build/
npm install --omit=dev --ignore-scripts --production
zip -r ../handler.zip .
cd ..

cp -r build/ projects/build/
rm -rf build/ handler.zip
