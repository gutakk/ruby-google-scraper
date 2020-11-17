[![Build Status](https://img.shields.io/github/workflow/status/gutakk/ruby-google-scraper/Test)](https://github.com/gutakk/ruby-google-scraper)

# Ruby Google Scraper
#### Gathering Google search information with your own keywords

### [Production](https://ruby-google-scraper-herokuapp.com/) | [Staging](https://ruby-google-scraper-staging.herokuapp.com/)

### [Project Backlog](https://github.com/gutakk/ruby-google-scraper/projects/1)

### [APIs Documentation](https://github.com/gutakk/ruby-google-scraper/wiki/Ruby-Google-Scraper-API-endpoints)

## Required Tools
* Docker and Docker Compose
    * [Docker for Mac](https://docs.docker.com/docker-for-mac/install/)

## Usage
#### Setup and boot the Docker containers
```sh
./bin/envsetup.sh
```

#### Setup the Postgres databases
```sh
rake db:setup
```

#### Run the Rails application
```sh
foreman start -f Procfile.dev
```
To visit app locally: `localhost:3000`

#### Run tests spec
```sh
rspec
```

## Deployment
Ruby Google Scraper using `Github Actions` for `CI/CD` purposes and deploy to `Heroku`.

- [Production](https://ruby-google-scraper-herokuapp.com/) is deployed from `master` branch
- [Staging](https://ruby-google-scraper-staging.herokuapp.com/) is deployed from `development` branch

## About
This project is created to complete **Web Certification Path** at [Nimble](https://nimblehq.co)
