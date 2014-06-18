# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'
require './lib/loggly'
require 'afmotion'
require 'sugarcube-nsdate'
Bundler.require(:development)

begin
  require 'bundler'
  Bundler.require
rescue LoadError
end

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'Loggly'
end
App.config.spec_mode = true

