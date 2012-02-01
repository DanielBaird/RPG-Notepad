
require 'dm-core'
require 'dm-migrations'

# tell datamapper to log to stdout
DataMapper::Logger.new($stdout, :debug)

# lets use a sqlite3 file in the current directory
DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/rpgn.sqlite3")

# ------------------------------------------------------------------------
class User
  
  include DataMapper::Resource
  
  has n, :gamerunners
  has n, :players

  property :id, Serial
  
end
# ------------------------------------------------------------------------
class Gamerunner

  include DataMapper::Resource
  
  belongs_to :campaign
  belongs_to :user
  
  property :id, Serial
  
  def to_xml(mode = :full)
    xml = ""
    if mode == :full
      xml = %{
        <gamerunner id="#{self.id}">
        </gamerunner>
      }
    elsif mode == :reference
      xml = %{<gamerunner id="#{self.id}" uri="#{gamerunner_api_url self.id}" />}
    end
    xml
  end

end
# ------------------------------------------------------------------------
class Player
  
  include DataMapper::Resource
  
  belongs_to :campaign
  belongs_to :user
  has n, :playercharacters
  
  property :id, Serial
  property :name, String
  
  def to_xml(mode = :full)
    xml = ""
    if mode == :full
      xml = %{
        <player id="#{self.id}">
          <name>#{self.name}</name>
        </player>
      }
    elsif mode == :reference
      xml = %{<player id="#{self.id}" uri="#{player_api_url self.id}" />}
    end
    xml
  end
  
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
          #{self.gamerunner.to_xml :reference}
          <players>
      }
      self.players.each { |player| xml << player.to_xml(:reference) }
      xml << %{
          </players>
        </campaign>
      }
    elsif mode == :reference
      xml = %{<campaign id="#{self.id}" uri="#{campaign_api_url self.id}" />}
    end
    xml
  end
  
end
# ------------------------------------------------------------------------
class Encounter
  
  include DataMapper::Resource
  
  belongs_to :campaign
  has n, :playercharacters, :through => Resource
  has n, :nonplayercharacters
  
  property :id, Serial
  property :name, String
  
  def to_xml(mode = :full)
    xml = ""
    if mode == :full
      xml = %{
        <encounter id="#{self.id}">
          <name>#{self.name}</name>
          #{self.campaign.to_xml :reference}
          <playercharacters>
      }
      self.playercharacters.each { |pc| xml << pc.to_xml(:reference) }
      xml << %{
          </playercharacters>
          <nonplayercharacters>
      }
      self.nonplayercharacters.each { |npc| xml << npc.to_xml(:reference) }
      xml << %{
          </nonplayercharacters>
        </encounter>
      }
    elsif mode == :reference
      xml = %{<encounter id="#{self.id}" uri="#{encounter_api_url self.id}" />}
    end
    xml
  end
  
end
# ------------------------------------------------------------------------
class Playercharacter
  
  include DataMapper::Resource
  
  belongs_to :player
  has n, :encounters, :through => Resource
  
  property :id, Serial
  property :name, String
  property :abbreviated_name, String
  
  def to_xml(mode = :full)
    xml = ""
    if mode == :full
      xml = %{
        <playercharacter id="#{self.id}">
          <name>#{self.name}</name>
          #{self.player.to_xml :reference}
          <encounters>
      }
      self.encounters.each { |encounter| xml << encounter.to_xml(:reference) }
      xml << %{
          </encounters>
        </playercharacter>
      }
    elsif mode == :reference
      xml = %{<playercharacter id="#{self.id}" uri="#{playercharacter_api_url self.id}" />}
    end
    xml
  end
  
end
# ------------------------------------------------------------------------
class Nonplayercharacter
  
  include DataMapper::Resource
  
  belongs_to :encounter
  
  property :id, Serial
  property :name, String
  property :abbreviated_name, String
  
  def to_xml(mode = :full)
    xml = ""
    if mode == :full
      xml = %{
        <nonplayercharacter id="#{self.id}">
          <name>#{self.name}</name>
          #{self.encounter.to_xml :reference}
        </nonplayercharacter>
      }
    elsif mode == :reference
      xml = %{<nonplayercharacter id="#{self.id}" uri="#{nonplayercharacter_api_url self.id}" />}
    end
    xml
  end
  
end
# ------------------------------------------------------------------------
DataMapper.auto_upgrade!
