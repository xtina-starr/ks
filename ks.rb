require 'json'
require './project.rb'
require './backer.rb'
require './read_write.rb'

@project_file = File.new("projects.txt", "a")
@backer_file = File.new("backers.txt", "a")

def check_for_project_in_project_file(project_name)
  ReadWrite.get_all_projects.select {|entry| entry["name"] == project_name}
end

def verify_project_exist(project)
  num_of_matches = check_for_project_in_project_file(project).count

  if (num_of_matches > 0)
    return true
  end
end

def find_backers_for_project_and_return_amt(project)
  # Iterate over @backed_proojects array to find backers that backed x project
  results = ReadWrite.get_all_backed_projects.select { |p| p["project_name"] == project }

  # Iterate again to print backers name and amt
  backed_amt = 0

    if (results.count > 0)
      results.each do |b|
        puts b["name"] + " backed #{b["project_name"]} for $#{b["backing_amount"]}"
        backed_amt = backed_amt + b["backing_amount"].to_i
      end
    else
      puts "Be the first to back this project."
    end
    backed_amt
end

if (ARGV[0] == "project")
  # Make sure input arg is passed in with 'project' command
  if (ARGV[1] == nil)
    puts "Please provide a project name."
  else
    Project.create_new_project(ARGV, @project_file)
  end
elsif (ARGV[0] == "back")
  # input: <given name> <project> <credit card number> <backing amount>
  if (ARGV[1] == nil)
    puts "Please provide a project name."
  else
    # Check if project exists in projects.txt file else project doesn't exist
    @all_projects = []
    File.open('projects.txt', 'r') do |file|
      while entry = file.gets
        @all_projects << JSON.parse(entry.chomp)
      end
    end

    exists = @all_projects.select {|entry| entry["name"] == ARGV[2]}.count > 0
    
    if (exists)
      Backer.back_project(ARGV, @backer_file)
    else
      puts "Project does not exist. Please enter a valid project name."
    end
  end
elsif (ARGV[0] == "list")
  # input: <project name>

  # Make sure input arg is passed in with 'list' command
  if (ARGV[1] == nil)
    puts "Please provide a project name."
  else

    if (verify_project_exist(ARGV[1]))
      backed_amt = find_backers_for_project_and_return_amt(ARGV[1])
      
      amt_needed = check_for_project_in_project_file(ARGV[1])[0]["target_amount"][1..-1].to_i - backed_amt

      puts amt_needed == 0 ? ARGV[1] + " is successful!" : ARGV[1] + " needs $#{amt_needed} more dollars to be successful"
    else
      puts ARGV[1] + " does not exist."
    end

  end
elsif (ARGV[0] == "backer")
  # Make sure input arg is passed in with 'backer' command
  if ARGV[1] == nil
    puts "Please provide a backer name."
  else
    given_name = ARGV[1]
    

    # Read/load projects.txt file and push each entry into @all_backers array
    @all_backers = []
    File.open('backers.txt', 'r') do |file|
      while line = file.gets
        @all_backers << line.chomp
      end
    end

    # Iterate over @all_backers array to find projects that x backed
    # Push into results array
    arr = []
    @all_backers.each do |back|
      # back is a string (serialized) obj and needs to be converted to a hash

      # backer_obj = JSON.parse(back)
      # backer_obj = back #.to_json.delete!("\\")
      # puts JSON.parse(backer_obj)["name"]
      # puts given_name
      if (JSON.parse(back)["name"] == given_name)
        arr << JSON.parse(back)
      end
    end
    
    # Iterate again:
    #   -If there are matches print backed project name and amt for x user
    #   -Else print "This user has not backed any projects."
    if (arr.count > 0)
      arr.each do |backed_project|
        puts "Backed " + backed_project["project_name"] + " for " + backed_project["backing_amount"]
      end
    else
      puts given_name + " has not backed any projects."
    end
  end
end




