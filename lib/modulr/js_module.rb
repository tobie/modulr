module Modulr
  class JSModule
    def self.from_expression(exp, file)
      str = exp.arguments.first.value.first
      new(str.value[1...-1], file, str.line.to_i)
    end

    attr_reader :identifier, :terms, :file, :line
    def initialize(identifier, file, line)
      @identifier = identifier
      @file = file
      @line = line
      @terms = identifier.split('/').reject { |term| term == '' }
      raise ModuleIdentifierError.new(self) unless identifier_valid?
    end

    def inspect
      "#<#{self.class.name} \"#{identifier}\">"
    end

    def identifier_valid?
      @valid ||= terms.all? { |t| t =~ /^([a-zA-Z]+|\.\.?)$/ }
    end

    def relative?
      @relative ||= terms.first =~ /^\.\.?$/
    end

    def top_level?
      !relative?
    end

    def path
      if @path
        @path
      else
        Dir.chdir(File.dirname(file)) do
          @path = File.expand_path(File.join(*terms)) << '.js'
        end
      end
    end
    
    def src
      return @src if @src
      if File.exist?(path)
        @src = File.read(path)
      else
        raise LoadModuleError.new(self)
      end
    end
    
    def to_js(buffer = '')
      buffer << "modulr.cache('#{identifier}', function(require, exports) {\n#{src}\n  return exports;\n});\n"
    end
  end
  
  class ModuleIdentifierError < StandardError
    attr_reader :js_module
    def initialize(js_module)
      @js_module = js_module
      super("Invalid module identifier '#{js_module.identifier}' in #{js_module.file} at line #{js_module.line}.")
    end
  end

  class LoadModuleError < StandardError
    attr_reader :js_module
    def initialize(js_module)
      @js_module = js_module
      super("Cannot load module '#{js_module.identifier}' in #{js_module.file} at line #{js_module.line}.\nMissing file #{js_module.path}.")
    end
  end
end