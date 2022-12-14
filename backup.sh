#!/bin/bash
set -e

rm -rf _build
mkdir _build

cd _build

# Mirror the whole 2014 website, including some images stored in AWS
wget \
  --convert-links \
  --html-extension \
  --no-check-certificate \
  --no-parent \
  --page-requisites \
  --recursive \
  --user-agent='Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.84 Safari/537.36' \
  -w 0.2 \
  --restrict-file-names=windows \
  -H --domains 2014.djangounderthehood.com,duth-uploads.s3.amazonaws.com \
  http://2014.djangounderthehood.com

# Images from AWS include signatures, let's strip them
rename 's/@.*//' duth-uploads.s3.amazonaws.com/*

# Move images from AWS to statics folder
mv duth-uploads.s3.amazonaws.com 2014.djangounderthehood.com/static/

# Replace all mentions to the AWS folder and strip signatures, all in one lovely line
grep -rl duth-uploads.s3.amazonaws.com . | xargs sed -e 's/\.\.\/duth-uploads.s3.amazonaws.com/static\/duth-uploads.s3.amazonaws.com/' -e 's/@[^"]*//' -i ''

# HTTP -> HTTPS
grep -rl 'http://maxcdn.bootstrapcdn.com' | xargs sed -e 's/http:\/\/maxcdn.bootstrapcdn.com/https:\/\/maxcdn.bootstrapcdn.com/' -i ''
grep -rl 'http://fonts.googleapis.com' | xargs sed -e 's/http:\/\/fonts.googleapis.com/https:\/\/fonts.googleapis.com/' -i ''
grep -rl 'http://use.typekit.net' | xargs sed -e 's/http:\/\/use.typekit.net/https:\/\/use.typekit.net/' -i ''
grep -rl 'http://www.youtube.com' | xargs sed -e 's/http:\/\/www.youtube.com/https:\/\/www.youtube.com/' -i ''
grep -rl 'http://speakerdeck.com' | xargs sed -e 's/http:\/\/speakerdeck.com/https:\/\/speakerdeck.com/' -i ''
grep -rl 'http://www.slideshare.net' | xargs sed -e 's/http:\/\/www.slideshare.net/https:\/\/www.slideshare.net/' -i ''

cd ..

mkdir -p docs
cp -r _build/2014.djangounderthehood.com/* docs/
