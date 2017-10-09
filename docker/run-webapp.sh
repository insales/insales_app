#!/bin/bash
source ~/.profile
set -e

sudo chown rails:rails $GEM_HOME $HOME/webapp

cd /home/rails/webapp

if [ ! -f config/database.yml ]; then
  cp config/database.yml.example config/database.yml
fi

bundle check || bundle install --jobs=$(nproc)
bundle exec rake db:create
bundle exec rake db:migrate
bundle exec rails s --binding=0.0.0.0
