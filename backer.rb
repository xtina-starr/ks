class Backer
  attr_accessor :backer_name, :project_name, :cc_number, :backing_amount

  def initialize(backer_name, project_name, cc_number, backing_amount)
    @backer_name = backer_name
    @project_name = project_name
    @cc_number = cc_number
    @backing_amount = backing_amount
  end
end