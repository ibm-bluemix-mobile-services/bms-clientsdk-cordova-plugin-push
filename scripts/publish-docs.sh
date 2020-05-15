#!/bin/bash

# This script is used by Travis-CI to automatically rebuild and deploy API documentation.

# If any part of this script fails, the Travis build will also be marked as failed
set -ev

# Clone the repository where the docs will be hosted
git clone https://ibm-bluemix-mobile-services:${GITHUB_TOKEN}@github.com/ibm-bluemix-mobile-services/ibm-bluemix-mobile-services.github.io.git
cd ibm-bluemix-mobile-services.github.io
git remote rm origin
git remote add origin https://ibm-bluemix-mobile-services:${GITHUB_TOKEN}@github.com/ibm-bluemix-mobile-services/ibm-bluemix-mobile-services.github.io.git
cd ..

# Generate new docs using JSDoc
version=$(grep '"version":' package.json -m1 | cut -d\" -f4)
docs_directory='./ibm-bluemix-mobile-services.github.io/API-docs/client-SDK/Cordova-Push-Plugin'
rm -rf "${docs_directory}"/*
jsdoc -c config.json -d "${docs_directory}"
mv "${docs_directory}"/bms-push/"${version}"/* "${docs_directory}"

# Publish docs
cd ibm-bluemix-mobile-services.github.io
git add .
git commit -m "Published docs for Push Cordova plugin ${version}"
git rebase master
git push --set-upstream origin master