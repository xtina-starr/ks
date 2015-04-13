require 'json'
require './project.rb'
require './backer.rb'
require './read_write.rb'

@project_file = File.new("projects.txt", "a")
@backer_file = File.new("backers.txt", "a")

# Methods for 'list' command
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

# Methods for 'backer' command
def project_backed_by_given_name(name)
  arr = []
  ReadWrite.get_all_backed.each do |back|
    if (JSON.parse(back)["name"] == name)
      arr << JSON.parse(back)
    end
  end
  arr
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
    exists = ReadWrite.get_all_projects.select {|entry| entry["name"] == ARGV[2]}.count > 0
    
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
    
    if (project_backed_by_given_name(given_name).count > 0)
      project_backed_by_given_name(given_name).each do |backed_project|
        puts "Backed " + backed_project["project_name"] + " for " + backed_project["backing_amount"]
      end
    else
      puts given_name + " has not backed any projects."
    end
  end
else
  puts "#{ARGV[0]}: command not found"
end




