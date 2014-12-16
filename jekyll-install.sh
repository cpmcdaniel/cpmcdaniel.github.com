#!/bin/sh

sudo apt-get update
sudo apt-get install bundler nodejs -y

cd /vagrant

bundle install
bundle exec jekyll serve --detach

# install an editor
sudo apt-get install emacs24-nox -y