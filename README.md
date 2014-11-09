# Hacking Chinese Challengens

Stack: Ruby on Rails + Postgresql


## Installation

```
# install Ruby >= 2, Postgresql database hn_challenge_development and hn_challenge_test
git clone https://github.com/hackingchinese/challenges
cd challenges
bundle
rake db:create
rake db:migrate
rails server -p 3000
```


## Contributing

Problems/new Ideas:
* Create an issue

Developers:
* Pull-Requests are nice. If it's new functionality, please provide some specs in Rspec


## License
This project's source code is under MIT License. Some of the used libraries, such as Highcharts, uses different licenes.
