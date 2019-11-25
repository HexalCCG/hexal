# frozen_string_literal: true

require 'csv'

options = ARGV

if options.length != 2
  raise 'Usage: ruby generate-json.rb [csv] [output folder]'
end

puts CSV.read(options[0], headers: true)

# File.open(options[0]).each_line do |line|
#   puts line
# end
