# README

This project uses:
- Ruby version: 3.2.2
- Rails version: 7.1.3.2
- Postgres version: 14.11

Running this project in any configuration requires the `DB_*` environment variables. Running the
server in a live mode requires the `GOOGLE_MAPS_API_KEY` environment variable. 

See [here](https://developers.google.com/maps/documentation/geocoding) for how to get that.

**ENV variables:**
- DB_USER: The database user
- DB_PASSWORD: The database user's password
- GOOGLE_MAPS_API_KEY: Necessary for conversion of addresses to latitude and longitude

* Project setup
  ```
  $ bundle install
  ```

* Database creation
  ```
  $ bundle exec rails db:setup db:schema:load
  ```
  No further initialization is required.


* There are two forms of tests: Cucumber features and RSpec specs. They use a specific fake key for calls to the maps API.
  ```
  $ GOOGLE_MAPS_API_KEY=not_a_real_key bundle exec cucumber features --expand --verbose --color -r features
  ```
  ```
  $ GOOGLE_MAPS_API_KEY=not_a_real_key bundle exec rails spec
  ```
