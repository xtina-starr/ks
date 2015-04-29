class Command

  def initialize(args)
    case args[0]
    when "project"
      project(args[1], args[2])
    when "back"
      back(args)
    when "list"
      list(args[1])
    when "backer"
      backer(args[1])
    else
      puts "#{args[0]} is not recognized as a command."
    end
  end

  def project(project_name, target_amount)
    if (project_name == nil)
      puts "Please provide a project name."
    else
      Project.create_new_project(project_name, target_amount)
    end
  end

  def back(args)
    if (args[1] == nil)
      puts "Please provide a project name."
    else
      exists = Project.find_by_name(args[2]).count > 0

      if (exists)
        Backer.back_project(args)
      else
        puts "Project does not exist. Please enter a valid project name."
      end
    end
  end

  def list(name)
    # input: <project name>

    # Make sure input arg is passed in with 'list' command
    if (name == nil)
      puts "Please provide a project name."
    else

      project = Project.find_by_name(name).first

      if (project)
        Backer.find_all_backers_by_project_name(name).each do |back|
          puts "#{back["name"]} backed #{back["project_name"]} for #{back["backing_amount"]}"
        end
        amt_needed = project["target_amount"].to_i - Backer.return_backed_amt_for_project(name)

        puts amt_needed <= 0 ? name + " is successful!" : name + " needs $#{amt_needed} more dollars to be successful"
      else
        puts name + " does not exist."
      end
    end
  end

  def backer(backer_name)
    # Make sure input arg is passed in with 'backer' command
    if backer_name == nil
      puts "Please provide a backer name."
    else

      projects_backed_by_given_name = Backer.find_all_project_by_backer(backer_name)

      if (projects_backed_by_given_name.length > 0)
        projects_backed_by_given_name.each do |backed_project|
          puts "Backed " + backed_project["project_name"] + " for " + backed_project["backing_amount"]
        end
      else
        puts backer_name + " has not backed any projects."
      end
    end
  end

end