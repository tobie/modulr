module Modulr
  class GlobalizeCollector < Collector
    
    def initialize(options = {})
      @global = options[:global]
      super
    end
    
    def to_js(buffer = '')
      buffer << "var #{@global} = (function() {\n"
      buffer << File.read(PATH_TO_MODULR_SYNC_JS)
      buffer << transport
      buffer << "\n  return require('#{main.id}');\n"
      buffer << "})();\n"
    end
  end
end