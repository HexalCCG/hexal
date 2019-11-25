options = ARGV

if options.length != 2 then
  raise 'Usage: ruby generate-json.rb [csv] [output folder]'
end

File.open(options[0]).