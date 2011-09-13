#!/usr/bin/env ruby1.9.1
#

# Playing with threads and open3 for running external scripts and grabbing log output.
#
# Small prototype to get an idea of how it works
#
#
require 'open3'
require 'thread'



queue = Queue.new
num_threads = 2

%w(one two three four five).each{|x| queue << x}
num_threads.times{|i| queue << nil}



threads = []

num_threads.times do |i|
  threads << Thread.new do
    work = queue.pop

    until work.nil?

      puts "WORKING ON: #{work}"

      Open3.popen3("./script.sh x/#{work}") do |sin, sout, serr|
        log = File.open("./logs/#{work}.log", "wb")
        unless sout.closed?
          sout.gets
          log.write($_)
        end
        log.close
      end
      work = queue.pop
    end
  end
end

threads.each do |t|
  t.join
end
