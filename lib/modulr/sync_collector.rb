module Modulr
  class SyncCollector < Collector
    def to_js(buffer = '')
      buffer << "(function() {\n"
      buffer << File.read(PATH_TO_MODULR_SYNC_JS)
      buffer << transport
      buffer << "\nrequire('#{main.id}');\n"
      buffer << "})();\n"
    end
  end
end