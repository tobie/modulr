module Modulr
  LIB_DIR = File.dirname(__FILE__)
  VENDOR_DIR = File.join(LIB_DIR, '..', 'vendor', 'rkelly', 'lib')
  $:.unshift(LIB_DIR)
  $:.unshift(VENDOR_DIR)
  
  require 'modulr/js_module'
  require 'modulr/collector'
  
  PATH_TO_MODULR_JS = File.join(LIB_DIR, '..', 'assets', 'modulr.js')
  
  def self.ize(options)
    collector = Collector.new
    collector.parse_file(options[:input])
    File.open(options[:output], 'w+') { |f| collector.to_js(f) }
  end
end
