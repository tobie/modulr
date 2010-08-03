module Modulr
  class SyncCollector < Collector
    def parse_file(path)
      super(path)
      modules << main unless modules.include?(main)
    end
    
    def to_js(buffer = '')
      buffer << "(function() {\n"
      buffer << File.read(PATH_TO_MODULR_SYNC_JS)
      buffer << transport
      buffer << "\nrequire('#{main.id}');\n"
      buffer << "})();\n"
    end
  end
end