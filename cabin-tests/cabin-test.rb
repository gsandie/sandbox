#!/usr/bin/env ruby1.9.1
#
# Experments with threads and cabin

require 'rubygems'
require 'bundler/setup'

require 'cabin'
require 'logger'
require 'thread'


#logger = Cabin::Channel.new
#logger.subscribe(Logger.new(STDOUT))
#
#
#c = logger.context
#c[:name] = "testlog"
#c[:verb] = "get"
#
#logger.info("omgomg")
#
#logger.time("TImer test") do
#  puts "Doing some stuff"
#end


logger = Cabin::Channel.new
logger.subscribe(Logger.new(STDOUT))

logger[:hostname] = "gavin03"
logger[:app] = "TestApp1"

q = Queue.new
num_threads = 4

%w{ obj1 obj2 obj3 obj4 obj5 obj6 obj7 }.each{ |i| q << i }
num_threads.times { q << nil }

threads = []
num_threads.times do |i|
  threads << Thread.new do
    p = q.pop
    until p.nil?
      # Want to log the thread number
      c = logger.context
      c[:thread] = i
      logger.info("working on #{p}")
      logger.time("More work #{p} -- #{i}") do
        sleep (rand * 2)
      end
      c.clear()
      p = q.pop
    end
  end
end

threads.each do |t|
  t.join
end
