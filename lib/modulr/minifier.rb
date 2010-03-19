module Modulr
  class MinifierError < ModulrError
  end
  
  class Minifier
    YUI_COMPRESSOR_PATH = File.join(File.dirname(__FILE__), '..', '..', 'vendor', 'yuicompressor-2.4.2.jar').freeze
    
    def self.minify(input, options = {})
      new(options).minify(input)
    end
    
    def initialize(options = {})
      @options = options
    end
    
    def minify(input)
      run_yui_compressor do |pipe, stderr|
        pipe.write(input)
        pipe.close_write
        output, error = pipe.read, stderr.read
        raise MinifierError, error unless error.empty?
        output
      end
    end
    
    protected
      def run_yui_compressor(&block)
        require 'coffee_machine'
        CoffeeMachine.run_jar(YUI_COMPRESSOR_PATH, :args => yui_compressor_args, &block)
      end
      
      def yui_compressor_args
        args = ['--type js']
        @options.each do |option, value|
          args << "--#{option.to_s.gsub('_', '-')}"
          args << value unless value == true || value == false
        end
        args.join(' ')
      end
  end
end
