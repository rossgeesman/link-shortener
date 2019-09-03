# Link Shortener Take Home

## Setup
1. Install dependencies by running `bundle install` from project root.
2. Setup database and run migrations by running `rails db:setup`
3. `rails s` to run server in development.
4. Run tests with `rspec spec/models` or `rspec spec/controllers`

## Use
Visit `localhost:3000` and enter the URL that you wish to shorten into the text field. Valid URLS will be saved and you will be shown an admin page with the shortened URL, the original url, a secret admin url, a visit counter, and a checkbox to disable forwarding.

## Explanation
URLs are stored in the `original_url` column of the ShortLink table. Each URL short code is the database row id in Base36 encoding. When a record is created the database sets the `admin_secret` column to a random UUID to serve as a secondary id for admin purposes. Queries for the shortened URL are cached at the database layer to prevent excessive load on the databse. The cache is expired when the user changes the URL `active` status.

