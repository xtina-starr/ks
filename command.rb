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

  def list(args)
    # input: <project name>

    # Make sure input arg is passed in with 'list' command
    if (args[1] == nil)
      puts "Please provide a project name."
    else

      project = Project.find_by_name(args[1]).first

      if (project)
        # backed_amt = find_backers_for_project_and_return_amt(args[1])
        
        amt_needed = project["target_amount"].to_i - Backer.return_backed_amt_for_project(args[1])

        puts amt_needed == 0 ? args[1] + " is successful!" : args[1] + " needs $#{amt_needed} more dollars to be successful"
      else
        puts args[1] + " does not exist."
      end

    end
  end

end