module ServiceRequestHelper
  def category_icons(category)
    content_tag :div, class: 'center' do
      image_tag("categories/#{category.get_image_name}", width: '200') +
      content_tag(:p, category.name )
    end
  end
  
  def sub_category_icons(category, subcategory)
    content_tag :div, class: 'center' do
      image_tag("", data: {src: asset_path("categories/#{category.name.parameterize}/#{subcategory.get_image_name}")}, width: '200') +
      content_tag(:p, subcategory.name )
    end
  end
end
