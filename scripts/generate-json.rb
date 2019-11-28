require 'csv'
require 'json'

element_keys = {
  'e' => :earth,
  'f' => :fire,
  'a' => :air,
  'w' => :water,
  's' => :spirit,
  'r' => :any
}

if ARGV.length != 2
  puts 'Usage: ruby generate-json.rb [input.csv] [output folder]'
  exit(1)
end

lines = CSV.read(ARGV[0], encoding: 'UTF-8')
lines.shift
keys = %i[id version name element type duration cost attack health text]

Dir.mkdir(ARGV[1]) unless Dir.exist?(ARGV[1])

lines.each do |line|
  data = Hash[keys.zip(line)]
  title = data[:id].to_s.rjust(3, '0') + '-' + data[:name].gsub(' ', '')

  data[:element].downcase!
  data[:type].downcase!
  data[:duration]&.downcase!
  
  unless data[:cost].nil?
    list = data[:cost].split('.').map do |item|
      [element_keys[item[1]], item[0].to_i]
    end
    data[:cost] = Hash[list]
  end

  result = { data[:version] => data }

  File.open(File.join(ARGV[1], title + '.json'), 'w') do |file|
    file.puts(JSON.pretty_generate(result))
  end
end
