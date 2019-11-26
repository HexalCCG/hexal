# frozen_string_literal: true

require 'csv'
require 'json'

if ARGV.length != 2
  puts 'Usage: ruby generate-json.rb [csv] [output folder]'
  exit(1)
end

lines = CSV.open(ARGV[0]).readlines
keys = lines.delete lines.first

File.open(ARGV[1], 'w') do |f|
  data = lines.map do |values|
    Hash[keys.zip(values)]
  end
  f.puts JSON.pretty_generate(data)
end

# File.open(options[0]).each_line do |line|
#   puts line
# end
