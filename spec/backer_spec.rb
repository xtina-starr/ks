require './backer'

describe Backer do 
  it "does some stuff" do
    mock_file = File.read("./spec/support/backers.txt")
    allow(File).to receive(:open).with("backers.txt").and_return(mock_file)
    expects(Backer).to eq
  end
end
