class Project
  attr_accessor :name, :target_amount

  def initialize(name, target_amount)
    @name = name
    @target_amount = target_amount
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