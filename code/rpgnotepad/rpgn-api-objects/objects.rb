
require 'dm-core'

# tell datamapper to log to stdout
DataMapper::Logger.new($stdout, :debug)

# use an in-memory sqlite db for now..
#DataMapper.setup(:default, 'sqlite3::memory:')
DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/rpgn.sqlite3")

# ------------------------------------------------------------------------
class User
  
  include DataMapper::Resource
  
  property :id, Serial
  
end
# ------------------------------------------------------------------------
class Campaign
  
  include DataMapper::Resource
  
  has n, :players
  has n, :encounters
  
  property :id, Serial
  property :name, String
  
  def to_xml
    xml = %{
<campaign id="#{self.id}">
  <name>#{self.name}</name>
  <players>}
    self.players.each do |player|
      xml << %{
    <player url="#{player_api_url player.id}" />
}
    end
    xml << %{
  </players>
</campaign>
}
  end
end
# ------------------------------------------------------------------------
class Player
  
  include DataMapper::Resource
  
  belongs_to :campaign
  has n, :playercharacters
  
  property :id, Serial

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