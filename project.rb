class Project
  attr_accessor :name, :target_amount

  def initialize(name, target_amount)
    @name = name
    @target_amount = target_amount
  end

  def self.create_new_project(project_name, target_amount)
    if (project_name.length < 4)
      puts "#{project_name} is too short."
    elsif (project_name.length > 21)
      puts "#{project_name} is too long."
    else
      new_project = Project.new(project_name, target_amount)
      project_file = File.new("projects.txt", "a") # maybe move to separate class
      project_file.puts new_project.to_json # wrap in it's own method
      project_file.close # wrap in it's own method
      puts "#{project_name} was created with a target of $#{target_amount}"
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
