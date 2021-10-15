#!/bin/sh

if [ ! -z "$1" ] && [ "$1" = "server" ]; then
  echo "Starting development server..."
	echo "Installing ruby dependencies..."
	bundle install
  echo "Installing JS dependencies..."
	yarn install
	echo "Building with Webpacker..."
	bundle exec rails webpacker:compile
  echo "Starting Server"
  rm -f tmp/pids/server.pid && bundle exec rails s -p 3000 -b '0.0.0.0'

elif [ ! -z "$1" ] && [ "$1" = "c" ]; then
	bundle exec rails c

elif [ ! -z "$1" ] && [ "$1" = "pronto" ]; then
	bundle exec pronto run

elif [ ! -z "$1" ] && [ "$1" = "sidekiq" ]; then
	bundle exec sidekiq

elif [ ! -z "$1" ] && [ "$1" = "db-create" ]; then
	echo "Creating databases..."
	bundle exec rails db:create
  # RAILS_ENV=test bundle exec rails db:create

elif [ ! -z "$1" ] && [ "$1" = "db-migrate" ]; then
	echo "Running migrations..."
	bundle exec rails db:migrate
	# RAILS_ENV=test bundle exec rails db:migrate

elif [ ! -z "$1" ] && [ "$1" = "db-seed" ]; then
	echo "Populating databases..."
	bundle exec rails db:seed

elif [ ! -z "$1" ] && [ "$1" = "db-drop" ]; then
	echo "Dropping databases..."
	bundle exec rails db:drop
	# RAILS_ENV=test bundle exec rails db:drop

elif [ ! -z "$1" ] && [ "$1" = "db-setup" ]; then
	echo "Running database setup. This might take a while..."
  ./run.sh db-create
  ./run.sh db-migrate
  ./run.sh db-seed

else
  echo "Missing parameter to execute run.sh"

fi
