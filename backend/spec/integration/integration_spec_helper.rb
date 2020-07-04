# frozen_string_literal: true

require 'bundler/setup'
require 'webrat'
require 'rack/test'
require 'sinatra'

module SinatraSpec
  def app
    Sinatra::Application
  end
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include Webrat::Methods
  config.include Webrat::Matchers
  config.include SinatraSpec
end

Webrat.configure do |config|
  config.mode = :rack
end
