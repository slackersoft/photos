# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
Photos::Application.config.secret_token = ENV['SECRET_TOKEN'] || 'a29b6e85d31760e7996448b23c337c87c8a6841cb4aa3a2c85c694a156cb64cdb7b639e19cd831891b06bfc472c5ed974dd6485e4896b0a39459b351b65f9b73'
