module Modulr
  LIB_DIR = File.dirname(__FILE__)
  PARSER_DIR = File.join(LIB_DIR, '..', 'vendor', 'rkelly', 'lib')
  $:.unshift(LIB_DIR)
  $:.unshift(PARSER_DIR)
  
  class ModulrError < StandardError
  end
  
  require 'modulr/js_module'
  require 'modulr/parser'
  require 'modulr/collector'
  require 'modulr/minifier'
  require 'modulr/version'
  
  PATH_TO_MODULR_JS = File.join(LIB_DIR, '..', 'assets', 'modulr.js')
  
  def self.ize(input_filename, options = {})
    collector = Collector.new(options)
    collector.parse_file(input_filename)
    minify(collector.to_js, options[:minify])
  end
  
  protected
    def self.minify(output, options)
      if options
        Minifier.minify(output, options == true ? {} : options)
      else
        output
      end
    end
end
