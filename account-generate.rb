require "rubygems"
require "bundler/setup"
require "whois"

c = Whois::Client.new(:host=>'whois.uwa.edu.au')
r= c.query('Ash Tyndall in Full Name', false)
puts r
