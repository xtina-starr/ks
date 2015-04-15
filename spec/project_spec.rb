require './project'
require 'json'

describe Project do
  it "#find_by_name should a project matching the passed in name" do
    name = "Arts-Crafts"

    expect(Project.find_by_name(name).count).to eq(1)
  end

  it "#find_by_name should a project matching the passed in name" do
    name = "Arts-Crafts"

    expect(Project.find_by_name(name)).to be_an_instance_of(Array)
  end

  it "#create_new_project should return error if invalid" do 
    args = ["project", "ab", "1234"]

    expect(Project).to receive(:create_new_project).with(args)
    Project.create_new_project(args)
  end

end