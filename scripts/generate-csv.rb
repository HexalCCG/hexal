require 'csv'
require 'json'

element_keys = {
  'earth' => 'e',
  'fire' => 'f',
  'air' => 'a',
  'water' => 'w',
  'any' => 'r'
}

if ARGV.length != 2
  puts 'Usage: ruby generate-csv.rb [input folder] [output.csv]'
  exit(1)
end

CSV.open(ARGV[1], 'wb') do |csv|
  Dir[ARGV[0] + '/*.json'].each do |file|
    file = JSON.parse(File.read(file))
    hash = file.max { |(ak, _), (bk, _)| ak.to_i <=> bk.to_i }

    hash['cost']&.map! { |key, value| element_keys[key] + '.' + value.to_s }

    csv << hash.values
  end
end
