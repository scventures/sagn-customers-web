module Her
  module Model
    module Extension
      extend ActiveSupport::Concern

      module ClassMethods

        def reflect_on_association(association)
          OpenStruct.new associations.inject([]) {|ary, (k,v)| v.find {|a| a[:collection?] = k == :has_many; a[:name] == association}}
        end

      end

      def save
        result = super
        populate_errors(response_errors)
        result
      end

      def populate_errors(response_errors)
        self.errors.clear
        response_errors.each do |attribute,errors|
          errors.each do |error|
            self.errors.add(attribute,error)
          end if errors.is_a? Array
        end if response_errors.is_a? Hash
      end

    end
  end
end
