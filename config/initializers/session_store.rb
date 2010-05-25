# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_pboost_session',
  :secret      => '5d92cf1299659006df05b4c99803440f1b88a9bbd73e46e6210f2829a0adaef7d01a63bd417362f0edd0f4c6473d1e52f177fbbad3614690fd9207fdfe273d64'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
