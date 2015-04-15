class Command

  def initialize(args)
    case args[0]
    when "project"
      project(args)
    when "back"
      back(args)
    when "list"
      list(args)
    when "backer"
      backer(args)
    end
  end

  def project(args)
    if (args[1] == nil)
      puts "Please provide a project name."
    else
      Project.create_new_project(args)
    end
  end

end