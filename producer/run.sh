#!/bin/bash

if [ ! -z "$1" ] && [ "$1" = "server" ]; then
  echo "Starting development server..."
  ./run.sh install
  echo "Starting Server"
  rm -f tmp/pids/server.pid && bundle exec rails s -p 3000 -b '0.0.0.0'

elif [ ! -z "$1" ] && [ "$1" = "c" ]; then
	bundle exec rails c

elif [ ! -z "$1" ] && [ "$1" = "routes" ]; then
	bundle exec rails routes

elif [ ! -z "$1" ] && [ "$1" = "install" ]; then
	echo "Installing ruby dependencies..."
	bundle install

elif [ ! -z "$1" ] && [ "$1" = "pronto" ]; then
	RAILS_ENV=test bundle exec pronto run

elif [ ! -z "$1" ] && [ "$1" = "guard" ]; then
	bundle exec guard

elif [ ! -z "$1" ] && [ "$1" = "sidekiq" ]; then
	bundle exec sidekiq

elif [ ! -z "$1" ] && [ "$1" = "db:create" ]; then
	echo "Creating database..."
	bundle exec rails db:create

elif [ ! -z "$1" ] && [ "$1" = "db:migrate" ]; then
	echo "Migrating database..."
	bundle exec rails db:migrate

elif [ ! -z "$1" ] && [ "$1" = "db:seed" ]; then
	echo "Populating database..."
	bundle exec rails db:seed

elif [ ! -z "$1" ] && [ "$1" = "db:setup" ]; then
	echo "Setting up the database..."
	./run.sh db:create
	./run.sh db:migrate
	./run.sh db:seed

elif [ ! -z "$1" ] && [ ! -z "$2" ] && [ "$1" = "rspec" ]; then
	RAILS_ENV=test bundle exec rspec "$2"

else
  echo "Missing parameter to execute run.sh"

fi
