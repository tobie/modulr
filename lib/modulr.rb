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
  require 'modulr/global_export_collector'
  require 'modulr/minifier'
  require 'modulr/dependency_graph'
  require 'open-uri'
  require 'modulr/version'
  
  PATH_TO_MODULR_JS = File.join(LIB_DIR, '..', 'assets', 'modulr.js')
  PATH_TO_MODULR_SYNC_JS = File.join(LIB_DIR, '..', 'assets', 'modulr.sync.js')
  
  def self.ize(input_filename, options = {})
    if options[:global]
      collector = GlobalExportCollector.new(options)
    else
      collector = Collector.new(options)
    end
    collector.parse_file(input_filename)
    minify(collector.to_js, options[:minify])
  end
  
  def self.graph(file, options = {})
    dir = File.dirname(file)
    mod_name = File.basename(file, '.js')
    mod = JSModule.new(mod_name, dir, file)
    uri = DependencyGraph.new(mod).to_yuml
    output = options[:dependency_graph]
    if output == true
      output = "#{dir}/#{mod_name}.png"
    end
    File.open(output, 'w').write(open(uri).read)
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
