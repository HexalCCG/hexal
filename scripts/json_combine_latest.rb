require 'optparse'
require 'json'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: json_combine_latest.rb [options]"

  opts.on("-i", "--input=INPUT", String, "Input folder") do |v|
    options[:input] = v
  end
  opts.on("-o", "--output=OUTPUT", String, "Output file") do |v|
    options[:output] = v
  end
end.parse!

if options[:input].nil? 
  raise OptionParser::MissingArgument
end
if options[:output].nil?
  options[:output] = "latest.json"
end

ignore_files = ["/manifest.json", "/latest.json"]
ignore_files_reg = Regexp.union(ignore_files)

cards_array = Dir[options[:input] + '/*.json'].delete_if {|name| name.match?(ignore_files_reg)}.map do |location|
  file = JSON.parse(File.read(location))
  latest = file.max { |(ak, _), (bk, _)| ak.to_i <=> bk.to_i }[1]

  latest
end

if File.file?(options[:input] + "/manifest.json")
  meta_hash = JSON.parse(File.read(options[:input] + "/manifest.json"))
else
  meta_hash = {}
end

meta_hash["length"] = cards_array.length
meta_hash["version"] = cards_array.inject(0) { |sum, n| sum + n["version"] } - cards_array.length

hash = {
  "meta" => meta_hash,
  "cards" => cards_array
}

File.open(options[:output], 'w') do |file|
  file.puts(JSON.pretty_generate(hash))
end
