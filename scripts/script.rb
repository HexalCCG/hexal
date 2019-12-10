# frozen_string_literal: true

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

Dir[ARGV[0] + '/*.json'].each do |location|
  file = JSON.parse(File.read(location))

  file.each do |version|
    version[1]['id'] = version[1]['id'].to_i
    version[1]['version'] = version[1]['version'].to_i
    version[1]['attack'] = version[1]['version']&.to_i
    version[1]['health'] = version[1]['version']&.to_i
  end

  File.open(location, 'w') do |new_file|
    new_file.puts(JSON.pretty_generate(file))
  end
end
