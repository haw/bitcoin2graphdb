module Graphdb
  module Model
    module Extensions
      autoload :Base, 'graphdb/model/extensions/base'
      autoload :OpenAssets, 'graphdb/model/extensions/open_assets'

      EXTENSIONS = {open_assets: 'graphdb/model/extensions/open_assets'}

      attr_accessor :extensions

      def load_extensions
        extensions.each do |e|
          load_module = "Graphdb::Model::Extensions::#{e.camelize}".constantize
          load_module::EXTENSIONS_TARGETS.each do |target|
            target.origin_class.include target
          end
        end
      end

    end
  end
end