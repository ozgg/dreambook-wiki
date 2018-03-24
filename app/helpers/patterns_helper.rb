module PatternsHelper
  # @param [Pattern] entity
  def admin_pattern_link(entity)
    link_to(entity.title, admin_pattern_path(entity.id))
  end

  # @param [Pattern] entity
  def pattern_image_preview(entity)
    return '' if entity.image.blank?
    versions = "#{entity.image.preview_2x.url} 2x"
    image_tag(entity.image.preview.url, alt: entity.title, srcset: versions)
  end

  # @param [Pattern] entity
  def pattern_image_medium(entity)
    return '' if entity.image.blank?
    versions = "#{entity.image.medium_2x.url} 2x"
    image_tag(entity.image.medium.url, alt: entity.title, srcset: versions)
  end
end
