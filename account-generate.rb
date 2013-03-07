require 'rubygems'
require 'bundler/setup'
require 'socket'

puts "Writing results to results.txt"
File.open('results.txt', 'w') do |r|
  File.foreach('students.txt') do |n|
    name = n.chomp

    s = TCPSocket.new 'whois.uwa.edu.au', 43
    s.puts "show people having #{name} as name and Students as Department\r\n"

    found = false
    while l = s.gets
      if m = l.match(/No matches were found/)
        puts "Could not resolve #{name}"
        r.puts "#{name}:?"
        found = true
        break
      end

      if m = l.match(/E-mail:\s*([0-9]{8})@student.uwa.edu.au/)
        num = m.captures[0]
        puts "Resolved #{name} to #{num}"
        r.puts "#{name}:#{num}"
        found = true
      end
    end

    unless found
      puts "Encountered strange output for #{name}"
      r.puts "#{name}:??"
    end

    s.close
    sleep 1
  end
end

