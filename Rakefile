require 'rubygems'
require 'rake'
require 'lib/modulr'

desc "Concatenate example file"
task :build_example do
  File.open(File.join('output', 'example.js'), 'w') do |f|
    f << Modulr.ize(File.join('example', 'program.js'))
  end
end

begin
  require "jeweler"
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "modulr"
    gemspec.summary = "A CommonJS module implementation in Ruby for client-side JavaScript"
    gemspec.author = "Tobie Langel"
    gemspec.email = "tobie.langel@gmail.com"
    gemspec.homepage = "http://github.com/tobie/modulr"
    gemspec.files = FileList["Rakefile", "VERSION", "{lib,bin,assets,vendor,example}/**/*"]
    gemspec.executable = "modulrize"
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install jeweler"
end
