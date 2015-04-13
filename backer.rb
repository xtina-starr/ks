class Backer
  attr_accessor :backer_name, :project_name, :cc_number, :backing_amount

  def initialize(backer_name, project_name, cc_number, backing_amount)
    @backer_name = backer_name
    @project_name = project_name
    @cc_number = cc_number
    @backing_amount = backing_amount
  end

  def self.back_project(input_args, backer_file)
    new_backer = Backer.new(input_args[1], input_args[2], input_args[3], input_args[4])
    backer = {:name => new_backer.backer_name, :project_name => new_backer.project_name, :cc_number => new_backer.cc_number, :backing_amount => new_backer.backing_amount}.to_json
    
    backer_file.puts backer
    backer_file.close
    puts "#{input_args[1]} backed project #{input_args[2]} for $#{input_args[4]}"
  end
end