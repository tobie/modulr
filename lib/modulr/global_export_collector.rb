module Modulr
  class GlobalExportCollector < Collector
    
    def initialize(options = {})
      @global = options[:global]
      super
    end
    
    def to_js(buffer = '')
      buffer << "#{define_global} = (function() {\n"
      buffer << File.read(PATH_TO_MODULR_SYNC_JS)
      buffer << transport
      buffer << "\n  return require('#{main.id}');\n"
      buffer << "})();\n"
    end
    
    def define_global
      if @global.include?('.')
        props = @global.split('.')
        str = props.shift
        results = "var #{str};"
        props.each do |prop|
          results << "\n#{str} = #{str} || {};"
          str << ".#{prop}"
        end
        "#{results}\n#{str}"
      else
        "var #{@global}"
      end
    end
  end
end