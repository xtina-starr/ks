require 'json'
require './project.rb'
require './backer.rb'

# class Backer
#   attr_accessor :backer_name, :project_name, :cc_number, :backing_amount

#   def initialize(backer_name, project_name, cc_number, backing_amount)
#     @backer_name = backer_name
#     @project_name = project_name
#     @cc_number = cc_number
#     @backing_amount = backing_amount
#   end
# end

@project_file = File.new("projects.txt", "a")
@backer_file = File.new("backers.txt", "a")

if (ARGV[0] == "project")
  # Make sure input arg is passed in with 'project' command
  if (ARGV[1] == nil)
    puts "Please provide a project name."
  else
    # validate length
    # accept the $ currency symbol, dollars and cents
    # Target dollar amounts should accept the $ currency symbol as a prefix and accept both dollars and cents.
    
    new_project = Project.new(ARGV[1], "$" + ARGV[2])
    project = {:name => new_project.name, :target_amount => new_project.target_amount}.to_json
    @project_file.puts project
    @project_file.close
    puts "#{ARGV[1]} was created with a target of $#{ARGV[2]}"
  end
elsif (ARGV[0] == "back")
  # input: <given name> <project> <credit card number> <backing amount>
  if (ARGV[1] == nil)
    puts "Please provide a project name."
  else
    # given name should be alphanumeric
    # validate length for given name
    # Credit card numbers may vary in length, up to 19 characters.
    # Credit card numbers will always be numeric.
    # Card numbers should be validated using Luhn-10.
    # Cards that fail Luhn-10 will display an error.
    # Cards that have already been added will display an error.
    # Backing dollar amounts should NOT use the $ currency symbol as a prefix to avoid issues with escaping but should accept dollars and cents

    # Check if project exists in projects.txt file else project doesn't exist
    @all_projects = []
    File.open('projects.txt', 'r') do |file|
      while entry = file.gets
        @all_projects << JSON.parse(entry.chomp)
      end
    end

    exists = @all_projects.select {|entry| entry["name"] == ARGV[2]}.count > 0
    
    if (exists)
      new_backer = Backer.new(ARGV[1], ARGV[2], ARGV[3], ARGV[4])
      backer = {:name => new_backer.backer_name, :project_name => new_backer.project_name, :cc_number => new_backer.cc_number, :backing_amount => new_backer.backing_amount}.to_json
      
      @backer_file.puts backer
      @backer_file.close
      puts "#{ARGV[1]} backed project #{ARGV[2]} for $#{ARGV[4]}"
    else
      puts "Project does not exist. Please enter a valid project name."
    end
  end
elsif (ARGV[0] == "list")
  # input: <project name> //list Awesome_Sauce 
  # => 
  # -- John backed for $50  
  # -- Jane backed for $50  
  # -- Mary backed for $400 
  # puts "not yet implemented"

  # Make sure input arg is passed in with 'list' command
  if (ARGV[1] == nil)
    puts "Please provide a project name."
  else
    project_input = ARGV[1]

    # Check if project exist in projects.txt file // maybe not
    @all_projects = []
    File.open('projects.txt', 'r') do |file|
      while entry = file.gets
        @all_projects << JSON.parse(entry.chomp)
      end
    end

    # Check if project exist in projects.txt file // maybe not

    matches = @all_projects.select {|entry| entry["name"] == project_input}
    num_of_matches = matches.count
      
    if (num_of_matches > 0)
      puts "do some stuff."
    else
      puts project_input + " does not exist."
    end

    # Read/load backers.txt file and push each entry into @backed_projects array
    @backed_projects = []
    File.open('backers.txt', 'r') do |file|
      while entry = file.gets
        @backed_projects << JSON.parse(entry.chomp)
      end
    end

    # Iterate over @backed_proojects array to find backers that backed x project
    results = @backed_projects.select { |p| p["project_name"] == project_input }

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
    
    amt_needed = matches[0]["target_amount"][1..-1].to_i - backed_amt

    puts amt_needed == 0 ? project_input + " is successful!" : project_input + " needs $#{amt_needed} more dollars to be successful"
    # Print whether a project is successful
    # - if not print how much is needed


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


