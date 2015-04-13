class Project
  attr_accessor :name, :target_amount

  def initialize(name, target_amount)
    @name = name
    @target_amount = target_amount
  end

  def self.create_new_project(input_args, project_file)
    # ---validate input---
    # validate length
    # accept the $ currency symbol, dollars and cents
    # Target dollar amounts should accept the $ currency symbol as a prefix and accept both dollars and cents.

    new_project = Project.new(input_args[1], "$" + input_args[2])
    project = {:name => new_project.name, :target_amount => new_project.target_amount}.to_json
    project_file.puts project
    project_file.close
    puts "#{input_args[1]} was created with a target of $#{input_args[2]}"
  end

  def self.write_project_to_file(project)
    # openfile write file
    puts "project was written to file"
  end

  def back
    # load file
    # read line
    # find records that titled back
  end
end