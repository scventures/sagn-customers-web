module Her
  module Model
    module Extension
      extend ActiveSupport::Concern

      module ClassMethods

        def reflect_on_association(association)
          OpenStruct.new associations.inject([]) {|ary, (k,v)| v.find {|a| a[:collection?] = k == :has_many; a[:name] == association}}
        end

        def build_with_inverse(attributes = {})
          @klass.build(attributes.merge(:"#{@parent.singularized_resource_name}_id" => @parent.id)).tap do |resource|
            begin
              resource.request_path
            rescue Her::Errors::PathError => e
              e.missing_parameters.each do |m|
                if id = @parent.get_attribute(m) || @parent.get_attribute("_#{m}")
                  resource.send("_#{m}=", id)
                end
              end
            end
          end
        end

      end

      def save
        result = super
        populate_errors(response_errors)
        result
      end

      def populate_errors(response_errors)
        self.errors.clear
        if response_errors.is_a?(Array)
          self.errors.add(:base, response_errors.join(', '))
        else
          response_errors.each do |attribute,errors|
            errors.each do |error|
              self.errors.add(attribute,error)
            end if errors.is_a? Array
          end if response_errors.is_a? Hash
        end
      end

    end
  end
end
