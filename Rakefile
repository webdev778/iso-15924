require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

ROOT_PATH = File.dirname(__FILE__)
ISO_15924_FILE = 'iso_15924.txt'
ISO_15924_FILE_PATH = File.join(ROOT_PATH, ISO_15924_FILE)
YAML_FILE_PATH = File.join(ROOT_PATH, 'lib', 'iso-15924.yaml')

desc 'Remove generated files'
task :clean do
  File.delete(YAML_FILE_PATH) if File.exist?(YAML_FILE_PATH)
  File.delete(ISO_15924_FILE_PATH) if File.exist?(ISO_15924_FILE_PATH)
end

desc 'Download iso 15924 zip file and unzip'
file ISO_15924_FILE do |task|
  require 'open-uri'
  require 'zip'
  iso_file = File.join(File.dirname(__FILE__), task.name)
  data = open('https://www.unicode.org/iso15924/iso15924.txt.zip')
  Zip::File.open_buffer(data) do |zip|
    entry = zip.first
    unless entry.nil? || File.exist?(iso_file)
      entry.extract(iso_file)
      puts "Downloaded to #{iso_file}"
    end
  end
end

desc 'Create 15924 yaml file'
task :iso => [:clean, ISO_15924_FILE] do
  require 'csv'
  require 'yaml'
  headers = %w(code numeric english french pva age date)
  data = Hash.new
  File.open(ISO_15924_FILE_PATH,'r:bom|utf-8') do |f|
      data = CSV.new(f, **{ col_sep: ";", headers: headers,
                            skip_lines: /^#/, skip_blanks: true,
                            quote_char: nil,
                            converters: [:numeric, :date]
                            }).map(&:to_h)
  end

  h = Hash[data.collect { |item| [item["code"], item.reject{|k,v| k == "code"} ] }]

  File.open(YAML_FILE_PATH, 'w') do |f|
      f.write(YAML.dump(h))
  end
end

desc 'Check if any updates on RA'
task :sync_ra => [:iso] do
  str = `git diff iso_15924.txt`
  puts str
  updated = !str.empty?
  if updated || true
    puts 'iso 15924 file on RA has been updated'
    sh 'touch `date +"%s"`.yml'
    Rake::Task[:bump].execute
  else
    puts 'no updates from RA'
  end
end

desc 'Bump version and release'
task :bump do
  sh 'git config user.email "isodata-bot@example.com"'
  sh 'git config user.name "isodata-bot"'
  sh 'git add .'
  sh 'git commit -m "synced iso data with RA"' do |ok, res|
    sh 'gem bump -v patch -p -t -r' if ok
  end
end

task :default => :spec
