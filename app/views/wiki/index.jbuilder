if @collection.any?
  json.data @collection do |entity|
    json.id entity.title
    json.type entity.class.table_name
    json.attributes do
      json.call(entity, :summary)
    end
  end
end
json.partial! 'letters', locals: { current_letter: @letter }
