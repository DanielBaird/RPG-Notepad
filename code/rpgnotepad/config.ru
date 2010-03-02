require 'rubygems'
require 'sinatra'

set :environment, :development

require 'rpgn-api.rb'

run Sinatra::Application