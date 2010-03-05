module Modulr
  LIB_DIR = File.dirname(__FILE__)
  PARSER_DIR = File.join(LIB_DIR, '..', 'vendor', 'rkelly', 'lib')
  $:.unshift(LIB_DIR)
  $:.unshift(PARSER_DIR)
  
  require 'modulr/js_module'
  require 'modulr/collector'
  
  PATH_TO_MODULR_JS = File.join(LIB_DIR, '..', 'assets', 'modulr.js')
  
  def self.ize(input_filename, options = {})
    collector = Collector.new(options[:root])
    collector.parse_file(input_filename)
    collector.to_js
  end
end
