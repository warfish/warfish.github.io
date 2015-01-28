#!/bin/bash

# build _site contents
pushd _src
jekyll build

# move _site contents over to root
cp -r _site/* ../

# Touch .nojekyll to tell github not to run it
popd
touch .nojekyll

# Add git changes
git add .
git commit -m "Autoregenerated update"

