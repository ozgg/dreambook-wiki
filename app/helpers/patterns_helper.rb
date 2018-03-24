module PatternsHelper
  # @param [Pattern] entity
  def admin_pattern_link(entity)
    link_to(entity.title, admin_pattern_path(entity.id))
  end

  # @param [Pattern] entity
  # @param [String] text
  def pattern_link(entity, text = entity.title)
    link_to(text, dreambook_pattern_path(slug: entity.slug))
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

  # Prepare post text for views
  #
  # @param [Pattern] pattern
  # @return [String]
  def prepare_pattern_text(pattern)
    strings = pattern.interpretation.split("\n").map(&:squish).reject(&:blank?)
    raw(strings.map { |s| parse_pattern_string(s, pattern.language) }.join)
  end

  # Parse fragments like [[Pattern]](link text)
  #
  # @param [String] string
  # @return [String]
  def parse_pattern_links(string, language)
    regex = Pattern::LINK_PATTERN
    string.gsub regex do |chunk|
      match   = regex.match chunk
      pattern = Pattern.with_language(language).with_slug(match[:slug]).first
      if pattern.is_a?(Pattern)
        link_text = match[:text].blank? ? pattern.title : match[:text]
        pattern_link(pattern, link_text)
      else
        '<span class="not-found">' + match[:slug] + '</span>'
      end
    end
  end

  private

  # Parse string as string from pattern description
  #
  # @param [String] string
  # @param [Language] language
  # @return [String]
  def parse_pattern_string(string, language)
    output = string.gsub('<', '&lt;').gsub('>', '&gt;')
    output = parse_pattern_links(output, language)
    "<p>#{output}</p>\n"
  end
end
