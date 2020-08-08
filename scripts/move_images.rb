require 'csv'
require 'json'
require 'fileutils'

if ARGV.length != 2
  puts 'Usage: ruby move_images.rb [json_folder] [images_folder]'
  exit(1)
end

Dir[ARGV[0] + '/*.json'].each do |file|
  folderName = file.split('/').last.chomp('.json').delete(',').delete('\'')
  next if %w[latest manifest].include?(folderName)

  number = folderName[0..2]

  Dir.chdir(ARGV[1]) do
    FileUtils.mkdir(folderName)
    FileUtils.mv(number + '.png', folderName + '/' + number + '.png')

    puts folderName + '/' + number + '.png'
  end
end
