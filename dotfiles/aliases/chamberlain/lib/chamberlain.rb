require 'fileutils'
require 'yaml'

require '~/coding/MeadHall/dotfiles/aliases/chamberlain/lib/custom_function.rb'
require '~/coding/MeadHall/dotfiles/aliases/chamberlain/lib/helper_function.rb'
require '~/coding/MeadHall/dotfiles/aliases/chamberlain/lib/list_collector.rb'
require '~/coding/MeadHall/dotfiles/aliases/chamberlain/lib/rspec_helper_function.rb'
require '~/coding/MeadHall/dotfiles/aliases/chamberlain/lib/run_and_tell.rb'
require '~/coding/MeadHall/dotfiles/aliases/chamberlain/lib/run_and_tell_quoted_inputs.rb'

class Chamberlain

  #### INSTANCE METHODS

  def directory_path
    "/Users/Eric/coding/MeadHall/dotfiles/aliases/"
  end

  def self.run
    
    self.clear_and_move_files_to_last_pass
    self.set_base_methods

  end
  
  def self.clear_and_move_files_to_last_pass
    self.clear_last_pass
    self.move_to_last_pass
  end
  
  def self.clear_last_pass
    self.change_directory_to_last_pass
    Dir.entries(".").each do |file|
      next if file == '.' || file == '..' || File.directory?(file)
      FileUtils.rm(file)
    end
  end
  
  def self.change_directory_to_last_pass
    FileUtils.cd("#{path}/chamberlain/last_pass/")
  end
  
  def self.change_directory_to_directory_pass
    FileUtils.cd(directory_path)
  end
  
  def self.move_to_last_pass
    self.change_directory_to_directory_pass
    Dir.entries(".").each do |file|
      next if file == '.' || file == '..' || File.directory?(file)
      FileUtils.mv(file, "chamberlain/last_pass/#{file}")
    end
  end
  
  def self.set_base_methods
    # create file
    File.open('.aliases.sh', 'w') do |alias_file|
      alias_file.write(RunAndTell.base_function)
      alias_file.write("\n\n")
      alias_file.write(RunAndTellQuotedInputs.base_function)
    end
  end

  #### INSTANCE METHODS

  def initialize(opts = {})
    @profile = opts[:profile]
    @option = opts[:options]
    @alias_lists = run_list_collector(opts[:profile])
    self.class.run
    write_aliases
  end
  
  def run_list_collector(given_profile)
    ListCollector.run(list: given_profile)
  end

  def write_aliases
    system "echo `tput setaf 2`"
    @alias_lists.each do |list|
      File.open('.aliases.sh', 'a') do |f|
        f.puts "\n\n"
        f.puts "# Alias List: #{list[:name]}\n"
        f.puts ""
      end

      arrayed = []

      (list[:aliases] || []).each do |alias_name, alias_action|
        arrayed << [alias_name, alias_action]
        File.open('.aliases.sh', 'a') do |f|
          command = RunAndTell.generate_alias(alias_name: alias_name, alias_action: alias_action)
          print '.'
          f.puts command
        end
      end

      (list[:grepped_aliases] || []).each do |alias_name, alias_action|
        File.open('.aliases.sh', 'a') do |f|
          arrayed << [alias_name, alias_action]
          command = RunAndTell.generate_alias(single_input: true, alias_name: alias_name, alias_action: alias_action)
          print '.'
          f.puts command
        end
      end

      (list[:quoted_inputs] || []).each do |alias_name, alias_action|
        File.open('.aliases.sh', 'a') do |f|
          arrayed << [alias_name, alias_action]
          command = RunAndTellQuotedInputs.generate_alias(alias_name: alias_name, alias_action: alias_action)
          print '.'
          f.puts command
        end
      end

      (list[:custom_functions] || []).each do |function_name, function_hash|
        arrayed << [function_name, function_hash[:helper_descrpition]] if function_hash[:helper_descrpition]
        command = CustomFunction.generate(
          name: function_name,
          echo_description: function_hash[:echo_description],
          command: function_hash[:command]
        )
        File.open('.aliases.sh', 'a') do |f|
          print '.'
          f.puts command
        end
      end

      (list[:rspec_helper_functions] || []).each do |function_name, function_hash|
        arrayed << [function_name, function_hash[:helper_descrpition]] if function_hash[:helper_descrpition]
        puts function_name
        command = RspecHelperFunction.generate(
          name: function_name,
          class: function_hash[:class],
          plural_class: function_hash[:plural_class],
          file_suffix: function_hash[:file_suffix]
        )
        File.open('.aliases.sh', 'a') do |f|
          print '.'
          f.puts command
        end
      end

      File.open('.aliases.sh', 'a') do |f|
        f.puts HelperFunction.generate(name: list[:name], alias_list: arrayed)
        f.puts "\n\n\n#########"
      end

    end
    system "echo `tput sgr0`"
  end
end
