# coding: utf-8

require 'bundler/setup'
require 'condition'
require 'sequel'
require 'pg'
require 'mongo'
require 'condition/storage/db'
require 'condition/storage/mongo'
require 'redis'
require 'condition/reader/redis_reader'
require 'condition/reader/convert_sheet'

FILES = File.dirname(__FILE__) + "/files"
DB = Sequel.connect('postgres://localhost:5432/test?user=aoyagikouhei')
MONGO = Mongo::MongoClient.new('localhost', 27017)['test']
REDIS = Redis.new

RSpec.configure do |config|
  # some (optional) config here
end
