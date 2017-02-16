module Her
  module FileUpload
    extend ActiveSupport::Concern

    module ClassMethods
      def has_file_upload(attribute)
        attributes attribute

        define_method(:"#{ attribute }=") do |file|
          assign_file_attribute(attribute.to_sym, file)
        end
      end
    end

    def assign_file_attribute(attribute, file)
      if file.is_a?(ActionDispatch::Http::UploadedFile)
        file = Faraday::UploadIO.new(
          file.tempfile.path,
          file.content_type,
          file.original_filename
        )
      end

      # Super can't be called with Stack Level Too Deep errors
      if @attributes[attribute] != file
        self.send(:"#{ attribute }_will_change!")
      end

      @attributes[attribute] = file
    end
  end
end
