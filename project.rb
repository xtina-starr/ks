class Project
  attr_accessor :name, :target_amount

  def initialize(name, target_amount)
    @name = name
    @target_amount = target_amount
  end

  def self.create_new_project(input_args)
    # ---validate input---
    # validate length
    # accept the $ currency symbol, dollars and cents
    # Target dollar amounts should accept the $ currency symbol as a prefix and accept both dollars and cents.

    project_file = File.new("projects.txt", "a")
    new_project = Project.new(input_args[1], "$" + input_args[2])
    
    project_file.puts new_project.to_json
    project_file.close
    puts "#{input_args[1]} was created with a target of $#{input_args[2]}"
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
