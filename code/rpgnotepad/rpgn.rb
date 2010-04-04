
require 'rubygems'
require 'sinatra'
require 'nokogiri'
require 'yaml'

require 'rpgn-api-objects/objects'

$version = '0.1.20100404'

$root_path = "/rpgnotepad"

# helper methods =========================================================

def rpgn_api_url path
  "#{$root_path}/api/#{path}"
end
# ------------------------------------------------------------------------
def campaign_api_url cam_id
  "#{$root_path}/api/campaign/#{cam_id}"
end
# ------------------------------------------------------------------------
def user_api_url user_id
  "#{$root_path}/user/#{user_id}"
end
# ------------------------------------------------------------------------
def pc_url cam_id, pc_id
  "#{$root_path}/campaign/#{cam_id}/pc/#{pc_id}"
end
# ------------------------------------------------------------------------
def as_xml(content, parent_name = "xml", indent = 0)
  xml = "#{"\t" * indent}<#{parent_name}>"
  if content.respond_to? "each_key"
    content.each_key do |key|
      xml += as_xml(content[key], key, indent+1)
    end
  else
    xml += "#{content}"
  end
  xml += "</#{parent_name}>\n"
  
  xml
end

# get methods ============================================================

get '/?' do
  # TODO: this should be some kind of menu or login or something. Hmm...
  "RPG Notepad v#{$version}"
end
# ------------------------------------------------------------------------
get '/api/campaign/:cam_id/pc/:pc_id/?' do
  pc = PlayerCharacter.new
  pc.to_s
end
# ------------------------------------------------------------------------
get '/api/campaign/:cam_id/encounter/:enc_id/?' do
  "got campaign '#{params[:cam_id]}', group '#{params[:enc_id]}'"
end
# ------------------------------------------------------------------------
#
# the good stuff is below.  everything else is crap.
#
# ========================================================================
# == client ==============================================================
# ========================================================================
#
get '/campaign/new/?' do
  %^
    <form action="#{rpgn_api_url 'campaigns'}" method="post">
      <label>campaign name: <input name="name" type="text" /></label>
    </form>
  ^
end

#
# ========================================================================
# == API =================================================================
# ========================================================================
#
# ------------------------------------------------------------------------
get '/api/campaigns/?' do
  # return a list of the campaigns available, including the URL and campaign name.
  # e.g:
  # /rpgnotepad/campaign/1234: Daniel's D&D 4e Campaign
  # /rpgnotepad/campaign/3456: Ruins of the Galactic Empire

  result = {}
  $data[:campaigns].each do |cam_id, cam_info|
    result[campaign_url cam_id] = cam_info[:name]
  end
  YAML.dump result
  as_xml result
end
# ------------------------------------------------------------------------
post '/api/campaigns/?' do
  cam = Campaign.new(:name => params[:name])
  if cam.save
    campaign_api_url(cam.id)
  else
    "problem!"
  end
end
# ------------------------------------------------------------------------
get '/api/campaign/:cam_id/?' do
  # return info about a given campaign; includes pcs (each with pc url, 
  # player url, and character name), and TODO other stuff....
  # e.g:
  # name: Daniel's D&D 4e Campaign
  # playercharacters: 
  #   /rpgnotepad/campaign/1234/pc/246: 
  #     player: /rpgnotepad/user/112233
  #     character: Theosophus Winterfall
  
  cam_id = params[:cam_id].to_i rescue nil
  
  campaign = Campaign.get cam_id
  throw :halt, [404, "Campaign with id '#{cam_id}' was not found."] unless campaign
  
  campaign.to_xml
  
end
# ------------------------------------------------------------------------
