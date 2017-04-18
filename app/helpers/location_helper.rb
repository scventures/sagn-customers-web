module LocationHelper
  def static_map_for(lat, lng, options = {})
    if lat && lng
      if options[:width] and options[:height]
        size = {size: "#{options[:width]}"+ 'x'+ "#{options[:height]}"}
      else
        size = {:size => "600x300"}
      end
      params = {
        :key => ENV['GOOGLE_MAP_API_KEY'],
        :center => [lat, lng].join(','),
        :zoom => 15,
        :markers => [lat, lng].join(','),
        :sensor => true
        }
        if size
          params.merge!(size)
        end
      query_string =  params.map{|k,v| "#{k}=#{v}"}.join("&")
      image_tag "https://maps.googleapis.com/maps/api/staticmap?#{query_string}", :alt => 'Location Address'
    end
  end
end

