require './backer'
require 'json'

describe Backer do
  it "#find_all_project_by_backer should find all projects backed by a given user" do
    backer_name = "Christina"

    expect(Backer.find_all_project_by_backer(backer_name).count).to eq(8)
  end

  it "#return_backed_amt_for_project should calculate the correct backing total for a given project that has been backed" do
    project = "Arts-Crafts"

    expect(Backer.return_backed_amt_for_project(project)).to eq(150)
  end

  it "#find_all_backers_by_project_name should find projects by project name" do 
    project_name = "Arts-Crafts"

    expect(Backer.find_all_backers_by_project_name(project_name).count).to eq(2)
  end
end
