require 'csv'
require 'json'

element_keys = {
  'earth' => 'e',
  'fire' => 'f',
  'air' => 'a',
  'water' => 'w',
  'spirit' => 's',
  'any' => 'r'
}

if ARGV.length != 2
  puts 'Usage: ruby json_combine_latest.rb [input folder] [output.json]'
  exit(1)
end

if File.file?(ARGV[0] + "/manifest.json")
  meta_hash = JSON.parse(File.read(ARGV[0] + "/manifest.json"))
elsif 
  meta_hash = {}
end

cards_hash = Dir[ARGV[0] + '/*.json'].delete_if {|name| name.match?("/manifest.json$")}.to_h do |location|
  file = JSON.parse(File.read(location))

  latest = file.max { |(ak, _), (bk, _)| ak.to_i <=> bk.to_i }[1]

  [latest['id'], latest]
end

hash = {
  "meta" => meta_hash,
  "cards" => cards_hash
}

File.open(ARGV[1], 'w') do |file|
  file.puts(JSON.pretty_generate(hash))
end
