
require 'dm-core'

# tell datamapper to log to stdout
DataMapper::Logger.new($stdout, :debug)

# lets use a sqlite3 file in the current directory
DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/rpgn.sqlite3")

# ------------------------------------------------------------------------
class User
  
  include DataMapper::Resource
  
  has n, :gamerunners
#  has n, :players

  property :id, Serial
  
end
# ------------------------------------------------------------------------
class Gamerunner

  include DataMapper::Resource
  
  belongs_to :campaign
  has 1, :user
  
  property :id, Serial

end
# ------------------------------------------------------------------------
class Player
  
  include DataMapper::Resource
  
  belongs_to :campaign
#  has 1, :user
  has n, :playercharacters
  
  property :id, Serial

end
# ------------------------------------------------------------------------
class Campaign
  
  include DataMapper::Resource
  
  has 1, :gamerunner
  has n, :players
  has n, :encounters
  
  property :id, Serial
  property :name, String
  
  def to_xml(mode = :full)
    xml = ""
    if mode == :full
      xml = %{
        <campaign id="#{self.id}">
          <name>#{self.name}</name>
          <players>
      }
      self.players.each do |player|
        xml << %{
            <player url="#{player_api_url player.id}" />
        }
      end
      xml << %{
          </players>
        </campaign>
      }
    elsif mode == :list
      xml = %{<campaign id="#{self.id}" uri="#{campaign_api_url self.id}" />}
    end
    xml
  end
end
# ------------------------------------------------------------------------
class Encounter
  
  include DataMapper::Resource
  
  has n, :playercharacters, :through => Resource
  
  belongs_to :campaign
  has n, :nonplayercharacters

  property :id, Serial
  
end
# ------------------------------------------------------------------------
class Playercharacter
  
  include DataMapper::Resource
  
  belongs_to :player
  
  has n, :encounters, :through => Resource
  
  property :id, Serial
  property :name, String
  property :abbreviated_name, String
  
  def to_s
    "A Player Character"
  end
  
end
# ------------------------------------------------------------------------
class Nonplayercharacter
  
  include DataMapper::Resource
  
  belongs_to :encounter
  
  property :id, Serial
  property :name, String
  property :abbreviated_name, String
  
  def to_s
    "A Non Player Character"
  end
  
end
# ------------------------------------------------------------------------
DataMapper.auto_upgrade!