#!/usr/bin/env ruby
# coding: UTF-8
require 'storage.rb'
require 'db_storage.rb'
require 'config.rb'

$storage = DBStorage.new
$storage.create_table

