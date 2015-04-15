class Backer
  attr_accessor :backer_name, :project_name, :cc_number, :backing_amount

  def initialize(backer_name, project_name, cc_number, backing_amount)
    @backer_name = backer_name
    @project_name = project_name
    @cc_number = cc_number
    @backing_amount = backing_amount
  end

  def self.back_project(input_args)
    # given name should be alphanumeric
    # validate length for given name
    # Credit card numbers may vary in length, up to 19 characters.
    # Credit card numbers will always be numeric.
    # Card numbers should be validated using Luhn-10.
    # Cards that fail Luhn-10 will display an error.
    # Cards that have already been added will display an error.
    # Backing dollar amounts should NOT use the $ currency symbol as a prefix to avoid issues with escaping but should accept dollars and cents
    backer_file = File.new("backers.txt", "a")

    new_backer = Backer.new(input_args[1], input_args[2], input_args[3], input_args[4])
    backer = {:name => new_backer.backer_name, :project_name => new_backer.project_name, :cc_number => new_backer.cc_number, :backing_amount => new_backer.backing_amount}.to_json
    
    backer_file.puts backer
    backer_file.close
    puts "#{input_args[1]} backed project #{input_args[2]} for $#{input_args[4]}"
  end

  def self.find_all_backers_by_project_name(name)
    @backed_projects = []
    File.open('backers.txt', 'r') do |file|
      while entry = file.gets
        @backed_projects << JSON.parse(entry.chomp)
      end
    end
    @backed_projects.select {|project| project["project_name"] == name}
  end

  def self.return_backed_amt_for_project(name)
    projects = find_all_backers_by_project_name(name)

    backed_amt = 0
    projects.each do |project|
      backed_amt = backed_amt + project["target_amount"].to_i
    end
    backed_amt
  end
end