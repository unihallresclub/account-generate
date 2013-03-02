require "rubygems"
require "bundler/setup"
require "whois"

c = Whois::Client.new(:host=>'whois.uwa.edu.au')

File.foreach('freshers.txt') { |l|
  name = l.chomp

  query = "show people having '#{name}' as name and Students as Department"
  puts query
  r = c.query(query, false)
  puts r
}

