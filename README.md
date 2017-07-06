# Sidekiq::TrackableBatch ([Demo App][demo])

This is the source code of a simple demo app showing how you could use [sidekiq-trackable_batch][stb] in a Rails 5 application. The app provides users with a UI to see the progress of a background task.

The following files are worth perusing.
- lib/fulfillment.rb -> The Workflow declaration called by after_create on the Order model.
- lib/order_status_notifier.rb -> The code called when a worker has successfully performed.
- app/assets/javascripts/channels/order_fulfilment.js -> Client-Side code for updating the UI.

## Local Setup

- Resolve dependencies by running bundle install.
- Edit config/database.yml with your local database credentials.
- Setup the database by running `rake db:setup`.
- Startup the app and sidekiq processes with `heroku local`. ([More Info][hl])

[demo]: https://sidekiq-trackable-batch-demo.herokuapp.com/
[stb]: https://github.com/darrhiggs/sidekiq-trackable_batch
[hl]: https://devcenter.heroku.com/articles/heroku-local
