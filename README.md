# Weather Forecaster

*This app was created within one week as an assessment project for [RoleModel Software](https://rolemodelsoftware.com/)'s [Craftsmanship Academy](https://rolemodelsoftware.com/academy).*

### See a 7-day forecast of high and low temperatures

This app allows you to add locations by inputting either a text or IP address, and then view the 7-day forecast of high and low temperatures for your locations. 

## This app utilizes the following APIs:
- [ipapi.co](https://ipapi.co/) for fetching location data based on IP addresses
- [Geocode.xyz](https://geocode.xyz/) for fetching location data based on text addresses
- [Open-Meteo.com](https://open-meteo.com/) for fetching weather data
- [Image-Charts.com](https://www.image-charts.com/) for rendering temperature charts

## Prerequisites
The Setup steps expect you to have the following installed:
- Ruby - 4.0.1
- Rails -8.1.2
- PostgreSQL

## Setup
The following steps will help you get Weather Forecaster up and running on your computer. 

### 1. Clone the repository and cd into it:

```bash
git clone git@github.com:aidenwstone/weather-forecaster.git
```

```bash
cd weather-forecaster
```

### 2. Install Gems

```bash
bundle install
```

### 3. Initialize the database

```bash
bin/rails db:setup
```

After running these commands, you will be ready to start up the server!

## Starting the server
To start the server, use this command:

```bash
bin/rails server
```

You should then be able to access the app by visiting [localhost:3000](http://localhost:3000/) in your web browser.

## Running tests
To run the full test suite, use this command:

```bash
bundle exec rspec
```
