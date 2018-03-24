namespace :patterns do
  desc 'Import patterns from YAML'
  task import: :environment do
    file_path = "#{Rails.root}/tmp/import/patterns.yml"
    if File.exists? file_path
      puts 'Importing patterns...'
      ignored = %w(id image agent)
      File.open file_path, 'r' do |file|
        YAML.load(file).each do |id, data|
          attributes = data.reject { |key| ignored.include? key }
          entity     = Pattern.find_by(id: id) || Pattern.new(id: id)
          entity.assign_attributes(attributes)
          if data.key?('agent')
            entity.agent = Agent.named(data['agent'])
          end
          entity.save!
          print "\r#{id}    "
        end
        puts
      end
      Pattern.connection.execute "select setval('patterns_id_seq', (select max(id) from patterns));"
      puts "Done. We have #{Pattern.count} patterns now"
    else
      puts "Cannot find file #{file_path}"
    end
  end

  desc 'Dump patterns to YAML'
  task dump: :environment do
    file_path = "#{Rails.root}/tmp/export/patterns.yml"
    ignored   = %w(id image words_count slug ip agent_id)
    File.open(file_path, 'w') do |file|
      Pattern.order('id asc').each do |entity|
        print "\r#{entity.id}    "
        file.puts "#{entity.id}:"
        entity.attributes.reject { |a, v| ignored.include?(a) || v.nil? }.each do |attribute, value|
          file.puts "  #{attribute}: #{value.inspect}"
        end

        file.puts "  agent: #{entity.agent.name.inspect}" unless entity.agent.nil?
        file.puts "  ip: #{entity.ip}" unless entity.ip.blank?
      end
      puts
    end
  end
end
