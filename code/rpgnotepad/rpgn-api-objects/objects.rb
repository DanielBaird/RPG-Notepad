
require 'dm-core'

# tell datamapper to log to stdout
DataMapper::Logger.new($stdout, :debug)

# use an in-memory sqlite db for now..
DataMapper.setup(:default, 'sqlite3::memory:')

# ------------------------------------------------------------------------
class User
  
  include DataMapper::Resource
  
end
# ------------------------------------------------------------------------
class Campaign
  
  include DataMapper::Resource
  
  has n, :players
  has n, :encounters
  has n, :nonplayercharacters
  
end
# ------------------------------------------------------------------------
class Player
  
  include DataMapper::Resource
  
  belongs_to :campaign
  has n, :playercharacters
  
end
# ------------------------------------------------------------------------
class Encounter
  
  include DataMapper::Resource
  
  has n, :playercharacters, :through => Resource
  
  belongs_to :campaign
  has n, :nonplayercharacters
  
end
# ------------------------------------------------------------------------
class PlayerCharacter
  
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
class NonPlayerCharacter
  
  include DataMapper::Resource
  
  belongs_to :encounter
  
  property :id, Serial
  property :name, String
  property :abbreviated_name, String
  
  def to_s
    "A Player Character"
  end
  
end
# ------------------------------------------------------------------------
