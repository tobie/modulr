module Modulr
  class GlobalExportCollector < SyncCollector
    
    def initialize(options = {})
      @global = options[:global]
      super
    end
    
    def globals
      if @global == true
        top_level_modules.map { |m| define_global(m.id) }.join
      else
        define_global(@global)
      end
    end
    private :globals
    
    def define_global(global)
      if global.include?('.')
        props = global.split('.')
        str = props.shift
        results = "var #{str};"
        props.each do |prop|
          results << "\n#{str} = #{str} || {};"
          str << ".#{prop}"
        end
        "#{results}\n#{str};\n"
      else
        "var #{global};\n"
      end
    end
    private :define_global
    
    def requires
      if @global == true
        top_level_modules.map do |m|
          "\n  #{m.id} = require('#{m.id}');"
        end.join
      else
        if top_level_modules.size == 1 #export to named global
          "\n  #{@global} = require('#{top_level_modules.first.id}');"
        else
          #export to props of named global
          top_level_modules.inject("\n#{@global} = {};") do |str, m|
            str << "\n  #{@global}.#{m.id} = require('#{m.id}');"
          end
        end
      end
    end
    private :requires
    
  end
end