require 'rubygems'
require 'sinatra'

set :environment, :development

require 'rpgn.rb'

run Sinatra::Application
