namespace :dreams do
  desc "Import dreams from YAML file"
  task import: :environment do
    file_path = "#{Rails.root}/tmp/import/dreams.yml"
    if File.exist? file_path
      puts 'Importing dreams...'
      permitted = %w[body created_at ip title updated_at user_id uuid]
      File.open file_path, 'r' do |file|
        YAML.load(file).each do |id, data|
          title = data['title']
          print "\r#{id}: #{title}    "

          next unless data['user_id'] == 1 || Dream.where(uuid: data['uuid']).exists?

          attributes = data.select { |k, _| permitted.include?(k) }
          entity = Dream.new(attributes)
          entity.personal = data['privacy'] != 'generally_accessible'
          entity.language_id = 1
          entity.save!
        end
        puts
      end
      puts "Done. We have #{Dream.count} dreams now"
    else
      puts "Cannot find file #{file_path}"
    end
  end
end
