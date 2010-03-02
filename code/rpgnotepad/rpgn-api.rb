
require 'rubygems'
require 'sinatra'
require 'yaml'

$version = '0.1.20090302'

$root_path = "/rpgnotepad"

$data = {
  :users => {
    112233 => {
      :name => "Daniel",
      :abbreviated_name => "Dan",
      :characters => [ 246 ],
      :runs_campaigns => [ 1234 ],
    }
  },
  :campaigns => {
    1234 => {
      :name => "Daniel's D&D 4e Campaign",
      :playercharacters => {
        246 => {
          :player => 112233,
          :name => "Theosophus Winterfall",
          :abbreviated_name => "Theo",
          :properties => {
            "Hit Points" => {
              :max => 33,
              :current => 22,
            },
          },
        },
      },
      :nonplayers => {
        357 => {
          :properties => {
            "Name" => "Orc1",
            "Hit Points" => {
              :max => 100,
              :current => 77,
            },
          },
        },
      },
      :encounters => {
        5678 => {
          :parties => {
            "orcs" => [ 357 ],
            "players" => [ 246 ],
          },
        },
      },
    },
  },
}

# helper methods =========================================================

def campaign_url cam_id
  "#{$root_path}/campaign/#{cam_id}"
end

def user_url user_id
  "#{$root_path}/user/#{user_id}"
end

def pc_url cam_id, pc_id
  "#{$root_path}/campaign/#{cam_id}/pc/#{pc_id}"
end

# get methods ============================================================

get '/?' do
  "RPG Notepad v#{$version}"
end
# ------------------------------------------------------------------------
get '/campaigns/?' do
  # return a list of the campaigns available
  result = {}
  $data[:campaigns].each do |cam_id, cam_info|
    result[campaign_url cam_id] = cam_info[:name]
  end
  YAML.dump result
end
# ------------------------------------------------------------------------
get '/campaign/:cam_id/?' do
  # return info about a given campaign
  cam_id = params[:cam_id].to_i rescue 0
  campaign = $data[:campaigns][cam_id]
  throw :halt, [404, "Campaign with id '#{cam_id}' was not found."] unless campaign
  result = {}
  result['name'] = campaign[:name]
  result['playercharacters'] = {}
  campaign[:playercharacters].each do |pc_id, pc|
    result['playercharacters'][pc_url(cam_id, pc_id)] = { 'player' => user_url(pc[:player]), 'character' => pc[:name] }
  end

  YAML.dump result
end
# ------------------------------------------------------------------------
get '/campaign/:cam_id/encounter/:enc_id/?' do
  "got campaign '#{params[:cam_id]}', group '#{params[:enc_id]}'"
end
# ------------------------------------------------------------------------


