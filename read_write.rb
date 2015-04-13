module ReadWrite

  def self.get_all_projects
    @all_projects = []
    File.open('projects.txt', 'r') do |file|
      while entry = file.gets
        @all_projects << JSON.parse(entry.chomp)
      end
    end
    @all_projects
  end

  def self.get_all_backed_projects
    @backed_projects = []
    File.open('backers.txt', 'r') do |file|
      while entry = file.gets
        @backed_projects << JSON.parse(entry.chomp)
      end
    end
    @backed_projects
  end

end