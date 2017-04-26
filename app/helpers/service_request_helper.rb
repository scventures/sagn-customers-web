module ServiceRequestHelper
  def category_icons(resource)
    image_url = resource.image_url? ? resource.image_url : 'default_category.png'
    if resource.class.equal?(Category)
      image = image_tag(image_url, width: '200', height: '200')
    else
      image_tag('', width: '200', height: '200', data: { src: image_url })
    end
    content_tag :div, class: 'center' do
      image +
      content_tag(:p, resource.name )
    end
  end
  
end
