require 'rubygems'
require 'bundler'
require 'data_mapper'
require 'dm-sqlite-adapter'

require 'gmail'

Bundler.require

require './whereis.rb'
require './models/checkin.rb'
require './models/person.rb'

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/whereis.db")
DataMapper.finalize

run WhereIs
