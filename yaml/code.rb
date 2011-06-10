#!/usr/bin/env ruby1.9.1

require 'yaml'


info = Hash.new

info["name"] = "blahblah"
info["place"] = "scotland"


# Dump the object to a new file as yaml
#
x = File.open(File.dirname(__FILE__) + "/foo.yaml", 'w+')
x.write(YAML.dump(info))
x.close


# Load a yaml file which gives a ruby object
y = YAML.load_file(File.dirname(__FILE__) + "/bar.yaml")

p y
