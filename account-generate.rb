require 'rubygems'
require 'bundler/setup'
require 'socket'

OUTPUT = 'results.txt'
INPUT = 'students.txt'
WHOIS_SERVER = 'whois.uwa.edu.au'

names = 0
single = 0
multi = 0
failure = 0

File.open(OUTPUT, 'w') do |r|
  puts "Reading input from #{INPUT}"
  puts "Querying against #{WHOIS_SERVER}"

  File.foreach(INPUT) do |n|
    name = n.chomp
    names += 1

    s = TCPSocket.new WHOIS_SERVER, 43
    s.puts "show people having #{name} as name and Students as Department\r\n"

    found = false
    multidec = false

    while l = s.gets
      if m = l.match(/No matches were found/)
        puts "Could not resolve #{name}"
        r.puts "#{name}:?"
        found = true
        failure += 1
        break
      end

      if m = l.match(/E-mail:\s*([0-9]{8})@student.uwa.edu.au/)
        num = m.captures[0]
        puts "Resolved #{name} to #{num}"
        r.puts "#{name}:#{num}"

        if found # If found is true, we've found a second result.
          # Decrement the single counter the first time around the multi loop
          # This prevents the first result from being counted as a single
          unless multidec
            single -= 1
            multi += 1
            multidec = true
          end
        else
          single += 1
        end

        found = true
      end
    end

    unless found
      puts "Encountered strange output for #{name}"
      r.puts "#{name}:??"
      failure += 1
    end

    s.close
    sleep 1
  end
end

puts ""
puts "COMPLETE: Queryed #{names} names."
puts "  #{failure} returned no results."
puts "  #{single} returned a single result."
puts "  #{multi} returned multiple results."
puts "Results written to #{OUTPUT}"
