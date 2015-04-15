class Project
  attr_accessor :name, :target_amount

  def initialize(name, target_amount)
    @name = name
    @target_amount = target_amount
  end

  def self.create_new_project(input_args)
    if (input_args[1].length < 4)
      puts "#{input_args[1]} is too short."
    elsif (input_args[1].length > 21)
      puts "#{input_args[1]} is too long."
    else
      new_project = Project.new(input_args[1], input_args[2])
      project_file = File.new("projects.txt", "a")
      project_file.puts new_project.to_json
      project_file.close
      puts "#{input_args[1]} was created with a target of $#{input_args[2]}"
    end
  end

  def to_json
    {:name => self.name, :target_amount => self.target_amount}.to_json
  end

  def self.find_by_name(name)
    @all_projects = []
    File.open('projects.txt', 'r') do |file|
      while entry = file.gets
        @all_projects << JSON.parse(entry.chomp)
      end
    end
    @all_projects.select {|project| project["name"] == name}
  end

end
