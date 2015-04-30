require 'luhn'

class Backer
  attr_accessor :backer_name, :project_name, :cc_number, :backing_amount

  def initialize(backer_name, project_name, cc_number, backing_amount)
    @backer_name = backer_name
    @project_name = project_name
    @cc_number = cc_number
    @backing_amount = backing_amount
  end

  def self.back_project(given_name, project, credit_card, backing_amount)
    # given_name, project, credit_card, backing_amount
    if(given_name.length < 4 || given_name.length > 21)
      puts "#{given_name} must not be shorter that 4 characters and no longer than 20"
    elsif (Backer.credit_card_exist(credit_card))
      puts "ERROR: That card has already been added by another user!"
    else
      if (Backer.valid_cc?(credit_card))
        new_backer = Backer.new(given_name, project, credit_card, backing_amount)

        backer_file = File.new("backers.txt", "a")
        backer_file.puts new_backer.to_json
        backer_file.close
        puts "#{given_name} backed project #{project} for $#{backing_amount}"
      else
        puts "ERROR: This card is invalid"
      end
    end  
  end

  def to_json
    {:name => self.backer_name, :project_name => self.project_name, :cc_number => self.cc_number, :backing_amount => self.backing_amount}.to_json
  end

  def self.valid_cc?(credit_card)
    /^\d{4,19}$/ === credit_card
  end

  def self.credit_card_exist(credit_card)
    backed_projects = []
    File.open('backers.txt', 'r') do |file|
      while entry = file.gets
        backed_projects << JSON.parse(entry.chomp)
      end
    end
    backed_projects.select {|backed| backed["cc_number"] == credit_card}.length > 0
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