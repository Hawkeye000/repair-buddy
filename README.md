Repair Buddy
============

Rails-based application for keeping maintenance and repair records for cars.

Intent is to make diagnosis, repair, and cost data searchable.

Running the Application
-----------------------
To migrate the database run
````
$ rake db:migrate
````
And run with
````
$ rails server
````

External Edmunds API
--------------------
This application replies on external access to the Edmunds API.  Sign up for an API key at http://developer.edmunds.com/.  
Set the environment variables EDMUNDS_API_KEY and EDMUNDS_SECRET for the development environment with the API key provided by Edmunds.com.
Feature tests and all controllers prefixed with 'edmunds' require this setup to work.

Testing
-------
This application uses RSpec.  Run the application test suite with
````
$ rspec spec/
````

Deployment and Production
-------------------------
This application is not yet setup for production and deployemnt.
