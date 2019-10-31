
require 'csv'
class Gossip
    attr_accessor :author, :content
    def initialize(author,content)
      @author = author
      @content = content
    end
  
    def save
        CSV.open("./db/gossip.csv", "ab") do |csv|
          csv << [@author,@content]
        end
      end

      def self.all #retourne tout les potins
        all_gossips = []
        CSV.read("./db/gossip.csv").each do |csv_line|
          all_gossips << Gossip.new(csv_line[0], csv_line[1])
        end
        return all_gossips
      end

      def self.find(id) #cherche un potins en fonctions de son numéro
        CSV.foreach("./db/gossip.csv").with_index do |csv_line, index|
          return gossip = Gossip.new(csv_line[0], csv_line[1]) if index == id.to_i
        end
      end

      def self.update(author, content, id)
		gossip_array = self.all
		gossip_array[id.to_i].content = content
		gossip_array[id.to_i].author = author
		#erase the csv file
		File.open("./db/gossip.csv", 'w') {|file| file.truncate(0) }
		#rewrite the file with the modif
		gossip_array.each do |gossip|
			gossip.save
		end	
	end

end 
