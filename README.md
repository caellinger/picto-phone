# README

[![Codeship Status for caellinger/picto-phone](https://app.codeship.com/projects/c4d642b0-6be7-0138-fa1c-2a4bda735c4c/status?branch=master)](https://app.codeship.com/projects/394569)

PictoPhone is an app developed by Christie Ellinger as a capstone project for Launch Academy.

Click [here](https://vimeo.com/419779003) for a side-by-side demonstration of what the game looks like in action.

### Installation
Run the following to download dependencies and set up the database:
```
bundle exec bundle install
bundle exec rake db:create
bundle exec rake db:migrate
```

### Set Up
Create a `.env` file to hold secret keys for the Wordnik API and Amazon S3. An example template has been provided.

### Usage
To run locally on your machine (*note: you must have an internet connection*), run each of the following commands in a separate terminal tab:
```
rails s
```
```
yarn start
```
Then navigate to http://localhost:3000 in your browser.

### Status
PictoPhone is a work-in-progress. Check back soon for more features!
