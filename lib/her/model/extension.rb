module Her
  module Model
    module Extension
      extend ActiveSupport::Concern
      module ClassMethods

        def reflect_on_association(association)
          OpenStruct.new associations.inject([]) {|ary, (k,v)| v.find {|a| a[:collection?] = k == :has_many; a[:name] == association}}
        end

      end
    end
  end
end
