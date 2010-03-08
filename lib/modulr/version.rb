module Modulr
  module VERSION
    STRING = File.read(File.join(File.dirname(__FILE__), '..', '..', 'VERSION')).chomp
    MAJOR, MINOR, PATCH = STRING.split(".").collect { |n| Integer(n) }
  end
end
