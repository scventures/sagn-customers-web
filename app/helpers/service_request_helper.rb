module ServiceRequestHelper
  def category_icons(resource, load_image = false)
    image_url = resource.image_url? ? resource.image_url : 'default_category.png'
    image = if load_image
        image_tag(image_url, width: '200', height: '200')
      else
        image_tag('', width: '200', height: '200', data: { src: asset_path(image_url) })
      end
    content_tag :div, class: 'center' do
      image +
      content_tag(:p, resource.name )
    end
  end
  
  def cents_to_money(cents)
    Money.new(cents)
  end
  
end
