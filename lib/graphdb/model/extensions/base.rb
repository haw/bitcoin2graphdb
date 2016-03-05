module Graphdb
  module Model
    module Extensions
      module Base

        attr_accessor :origin_class

        def set_origin(clazz)
          @origin_class ||= clazz
        end

      end
    end
  end
end