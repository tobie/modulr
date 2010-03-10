module Modulr
  class JSModule
    include Comparable
    
    JS_ESCAPE_MAP = {
      '\\'    => '\\\\',
      '</'    => '<\/',
      "\r\n"  => '\n',
      "\n"    => '\n',
      "\r"    => '\n',
      '"'     => '\\"',
      "'"     => "\\'"
    }
    
    def self.parser
      @dependency_finder ||= Parser.new
    end
    
    def self.find_dependencies(js_module)
      expressions = parser.get_require_expressions(js_module.src)
      expressions.map do |exp|
        new(exp[:identifier], js_module.root, js_module.path, exp[:line])
      end
    end
    
    attr_reader :identifier, :root, :terms, :file, :line
    
    def initialize(identifier, root, file=nil, line=nil)
      @identifier = identifier
      @root = root
      @file = file
      @line = line
      @terms = identifier.split('/').reject { |term| term == '' }
      raise ModuleIdentifierError.new(self) unless identifier_valid?
    end
    
    def <=> (other_module)
      id <=> other_module.id
    end

    def inspect
      "#<#{self.class.name} \"#{identifier}\">"
    end

    def identifier_valid?
      @valid ||= terms.all? { |t| t =~ /^([a-zA-Z]+|\.\.?)$/ }
    end
    
    def id
      return @id if @id
      if top_level?
        @id = identifier
      else
        @id = File.expand_path(partial_path, directory)
        @id.sub!("#{File.expand_path(root)}/", '')
      end
    end

    def relative?
      @relative ||= terms.first =~ /^\.\.?$/
    end

    def top_level?
      !relative?
    end

    def path
      @path ||= File.expand_path(partial_path, directory) + '.js'
    end
    
    def src
      return @src if @src
      if File.exist?(path)
        @src = File.read(path)
      else
        raise LoadModuleError.new(self)
      end
    end
    
    def escaped_src
      @escaped_src ||= src.gsub(/(\\|<\/|\r\n|[\n\r"'])/) {
        JS_ESCAPE_MAP[$1]
      }
    end
    
    def dependencies
      @dependencies ||= self.class.find_dependencies(self)
    end

    def to_js(buffer = '')
      call_alias_js_function(buffer)
      fn = "function(require, exports, module) {\n#{src}\n}"
      buffer << "\nmodulr.cache('#{id}', #{fn});\n"
    end
    
    def to_js_string(buffer = '')
      call_alias_js_function(buffer)
      buffer << "\nmodulr.cache('#{id}', '#{escaped_src}');\n"
    end
    
    protected
      def partial_path
        File.join(*terms)
      end
      
      def directory
        relative? ? File.dirname(file) : root
      end
      
      def call_alias_js_function(buffer)
        if relative?
          buffer << "\nmodulr.alias('#{identifier}', '#{id}');"
        end
      end
  end
  
  class ModuleIdentifierError < ModulrError
    attr_reader :js_module
    def initialize(js_module)
      @js_module = js_module
      super("Invalid module identifier '#{js_module.identifier}' in #{js_module.file} at line #{js_module.line}.")
    end
  end

  class LoadModuleError < ModulrError
    attr_reader :js_module
    def initialize(js_module)
      @js_module = js_module
      super("Cannot load module '#{js_module.identifier}' in #{js_module.file} at line #{js_module.line}.\nMissing file #{js_module.path}.")
    end
  end
end