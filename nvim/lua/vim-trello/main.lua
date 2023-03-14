------------------------------------------------------------------------------
-- main.lua
-- Max Thomas
-- Sometime in 2023
--https://www.youtube.com/watch?v=Y9Vi_1lkE_E
------------------------------------------------------------------------------

local json = require("json")
local url = "https://"

local api_key = ""
local token = ""

local function trello_get_cards_listener(event)
  print("================================================")
  print("================================================")

  if (event.IsError) then
    print("Network error: ", event.response )
  else
    print (event.response) -- spits out a load of JSON response.  need to manipulate this
    local r = json.decode(event.response)
    local status = r.status
    local errMsg = r.errMsg
    local otherstuff = r.otherstuff
  end
  print("================================================")

end

local function trello_get_cards()
  local headers = {}
  headers["Content-Type"] = "application/json"
  headers["Accept-Language"] = "en-GB"

  local body = {}
  body.api_key = api_key
  body.token = token

  local.params = {}
  params.headers = headers
  params.body = json.encode(body)

  --use the request metho dof the built in network library
  --network.request(url, method, listener, parameters)
  --method can be GET, POST, HEAD, PUT and DELETE
  --the listener is a function that waits for a response or an error from
  --a call to a web service method
  --The params is an array (table) that specifies HTTP request or response 
  --processing options
  network.request( url .. "<endpoint>", "POST", <listener>, params)
end

trello_get_cards()
