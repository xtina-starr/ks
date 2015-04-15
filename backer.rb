require 'luhn'

class Backer
  attr_accessor :backer_name, :project_name, :cc_number, :backing_amount

  def initialize(backer_name, project_name, cc_number, backing_amount)
    @backer_name = backer_name
    @project_name = project_name
    @cc_number = cc_number
    @backing_amount = backing_amount
  end

  def self.back_project(input_args)
    # Credit card numbers will always be numeric.
    # Cards that have already been added will display an error.
    # Should accept dollars and cents
    if(input_args[1].length < 4 || input_args[1].length > 21)
      puts "#{input_args[1]} must not be shorter that 4 characters and no longer than 20"
    else
      if (Luhn.valid?(input_args[3]) && input_args[3].length < 20)
        new_backer = Backer.new(input_args[1], input_args[2], input_args[3], input_args[4])
      else
        puts "ERROR: This card is invalid"
      end
    end
    
    backer_file = File.new("backers.txt", "a")
    backer_file.puts new_backer
    backer_file.close
    puts "#{input_args[1]} backed project #{input_args[2]} for $#{input_args[4]}"
  end

  def to_json
    {:name => new_backer.backer_name, :project_name => new_backer.project_name, :cc_number => new_backer.cc_number, :backing_amount => new_backer.backing_amount}.to_json
  end

  def self.find_all_project_by_backer(name)
    backed_projects = []
    File.open('backers.txt', 'r') do |file|
      while entry = file.gets
        backed_projects << JSON.parse(entry.chomp)
      end
    end
    backed_projects.select {|project| project["name"] == name}
  end

  def self.find_all_backers_by_project_name(name)
    backed_projects = []
    File.open('backers.txt', 'r') do |file|
      while entry = file.gets
        backed_projects << JSON.parse(entry.chomp)
      end
    end
    backed_projects.select {|project| project["project_name"] == name}
  end

  def self.return_backed_amt_for_project(name)
    projects = find_all_backers_by_project_name(name)

    backed_amt = 0
    projects.each do |project|
      backed_amt = backed_amt + project["backing_amount"].to_i
    end
    backed_amt
  end
end