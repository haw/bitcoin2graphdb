module Graphdb
  module Model
    module Extensions
      autoload :Base, 'graphdb/model/extensions/base'
      autoload :OpenAssets, 'graphdb/model/extensions/open_assets'

      EXTENSIONS = {open_assets: 'graphdb/model/extensions/open_assets'}

      attr_accessor :extensions

      def load_extensions
        extensions.each do |e|
          autoload e.camelize, "graphdb/model/extensions/#{e}"
        end
      end

      def unload_extensions
        Graphdb::Model.send(:remove_const, :Transaction)
        load 'graphdb/model/transaction.rb'
      end

    end
  end
end