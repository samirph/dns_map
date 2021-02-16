# DNS Map
This project is an API to map DNS ips and hostnames and render the mapped data to clients according to their requirements.

## Getting Started

### Pre-requisites

First of all, make sure you have Docker and Docker Compose installed in your machine.

### Starting the API
First, create the database and run the migrations:
```
docker-compose run web bundle exe rake db:create db:migrate
```
To start the project, run the following command:
```
docker-compose up web
```

The endpoints will be available on port 3000.

### cURL Instructions
If you want to make requests to the API by using curl, you can create records using the following format:
```
curl -X POST -H "Content-Type: application/json" -d '{"ip": "2.1.7.22", "hostnames_attributes": [{"hostname": "google.com"}]}' http://localhost:3000/dns-records 
```
And you can query records by using the following format:
```
curl -XGET -H "Content-type: application/json" -d '{"page": 1, "included": ["google.com"], "excluded": ["pluralsight.com"]}' 'http://localhost:3000/dns-records'
```
### Tests
Don't forget to create the DB and run the migrations before running the test suite.
```
docker-compose run web bundle exe rake db:create db:migrate
```
To run the test suite, run the following command:
```
docker-compose run web bundle exe rspec
```
