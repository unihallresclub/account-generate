require "rubygems"
require "bundler/setup"
require "whois"

c = Whois::Client.new(:host=>'whois.uwa.edu.au')

File.foreach('freshers.txt') { |l|
  name = l.chomp

  r = c.query("show people having '#{name}' as Full Name and Students as Department", false)
  puts r
}

