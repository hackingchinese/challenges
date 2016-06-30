# Hacking Chinese App: Challenges + Resources

Web-App that powers the social features of HackingChinese.

Prerequisites:

* Ruby >=2.2
* PostgreSQL >= 9.3
* Linux / OSX (not tested on Windows)
* Imagemagick + devlib (e.g. libmagickwand on Ubuntu)
* Virtual Screenbuffer / Xorg for making screenshots of websites for Resoures

## Installation

```bash
# install Ruby >= 2.2, Postgresql database hn_challenge_development and hn_challenge_test
git clone https://github.com/hackingchinese/challenges
cd challenges
# install dependencies
bundle
# copy example configuration for database, adjust if necessary
cp config/database.yml.example config/database.yml
# copy example secrets for social login + cookie secret
cp secrets.yml.example secrets.yml
# create database + tables
rake db:setup
# start server on port localhost:3000
rails server -p 3000
```

## Contributing

[![Build Status](https://travis-ci.org/hackingchinese/challenges.svg)](https://travis-ci.org/hackingchinese/challenges)

Problems/New ideas:
* Create an issue

Developers:
* Pull-Requests are nice. If it's new functionality, please provide some specs in Rspec

## License

This project's source code is under MIT License. Some of the used libraries, such as Highcharts, uses different licenes.
