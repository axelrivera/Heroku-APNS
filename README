=Heroku APNS

This is a sinatra app for people who want to quickly and easily deploy an APNS server to Heroku

==Acknowledgements:

Based on apn_on_rails

==Installing:

First, replace the apple_push_notifiation_production.pem with your own .pem file

Next, if you are testing on your local database, create a local-database.yml file based on the template provided and fill in the credentials.

Finally, deploy to Heroku

==Usage:

There are three API endpoints: 

===register
Parameters: token
This should be formatted as a single string with no &lt; or spaces. 

===message
Parameters: token, badge, message

===deliver
This should be called by an external cron job because heroku lacks a minute-by-minute cron capability

===feedback
This should be called by an external cron job because heroku lacks a minute-by-minute cron capability



Released under the MIT license by Eric Silverberg.