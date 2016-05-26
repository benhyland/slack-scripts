#!/usr/bin/env ruby

lib = File.join(File.dirname(__FILE__), '../lib/')
$:.unshift lib unless $:.include?(lib)

target = ARGV[0]

require "#{target}.rb"
