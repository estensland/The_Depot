require '~/coding/MeadHall/dotfiles/aliases/chamberlain/run_and_tell.rb'
require '~/coding/MeadHall/dotfiles/aliases/chamberlain/run_and_tell_quoted_inputs.rb'
require '~/coding/MeadHall/dotfiles/aliases/chamberlain/helper_function.rb'

class Chamberlain

  #### INSTANCE METHODS

  def self.run
    # set path
    path = "~/coding/MeadHall/dotfiles/aliases/"

    # create file
    puts Dir.pwd
    Dir.chdir "coding"
    Dir.chdir "MeadHall"
    Dir.chdir "dotfiles"
    Dir.chdir "aliases"
    puts Dir.pwd

     File.open('.aliases.sh', 'w') do |alias_file|
      alias_file.write(RunAndTell.base_function)
      alias_file.write("\n\n")
      alias_file.write(RunAndTellQuotedInputs.base_function)
     end
  end

  #### INSTANCE METHODS

  def initialize(opts = {})
    @alias_lists = opts[:alias_lists]
    self.class.run
    write_aliases
  end

  def write_aliases
    @alias_lists.each do |list_group|
      list_group.each do |list|
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
            puts command
            f.puts command
          end
        end

        (list[:quoted_inputs] || []).each do |alias_name, alias_action|
          File.open('.aliases.sh', 'a') do |f|
            arrayed << [alias_name, alias_action]
            command = RunAndTellQuotedInputs.generate_alias(alias_name: alias_name, alias_action: alias_action)
            puts command
            f.puts command
          end
        end


        HelperFunction.generate(name: list[:name], alias_list: arrayed)

      end
    end
  end
end