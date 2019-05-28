# frozen_string_literal: true

namespace :patterns do
  desc 'Import patterns from YAML file'
  task import: :environment do
    file_path = "#{Rails.root}/tmp/import/patterns.yml"
    if File.exist? file_path
      puts 'Importing patterns...'
      File.open file_path, 'r' do |file|
        YAML.load(file).each do |id, data|
          title = data['title']
          print "\r#{id}: #{title}    "

          next unless data.key?('essence')

          entity = Pattern.find_or_initialize_by(title: data['title'])
          entity.title = data['title']
          entity.summary = data['essence']
          entity.description = data['interpretation']
          entity.language_id = 1
          entity.save!
        end
        puts
      end
      puts "Done. We have #{Pattern.count} patterns now"
    else
      puts "Cannot find file #{file_path}"
    end
  end

  desc 'Export patterns to YAML file'
  task export: :environment do
    file_path = "#{Rails.root}/tmp/export/patterns.yml"
    ignored = %w[id image words_count slug data]
    File.open(file_path, 'w') do |file|
      Pattern.order('id asc').each do |entity|
        print "\r#{entity.id}    "
        file.puts "#{entity.id}:"
        entity.attributes.reject { |a, v| ignored.include?(a) || v.nil? }.each do |attribute, value|
          file.puts "  #{attribute}: #{value.inspect}"
        end
      end
      puts
    end
  end
end
