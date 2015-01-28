#!/usr/bin/bash

# build _site contents
jekyll build

# move _site contents over to root
cp -r _site/* ./

# Touch .nojekyll to tell github not to run it
touch .nojekyll


