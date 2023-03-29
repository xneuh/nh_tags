local FormattedToken = "Bot " .. Settings.DiscordSettings.DiscordToken
GlobalState.Tags, GlobalState.Streamers = {}, {}

DiscordRequest = function(requestMethod, requestEndPoint, JSON)
    local data = nil

    PerformHttpRequest("https://discordapp.com/api/" .. requestEndPoint, function(errorCode, resData, resHeaders)
        data = {
            ["data"] = resData,
            ["code"] = errorCode,
            ["headers"] = resHeaders
        }
    end, requestMethod, #JSON > 0 and json.encode(JSON) or "", {["Content-Type"] = "application/json", ["Authorization"] = FormattedToken})
    
    while (data == nil) do 
        Wait(0)
    end

    return data
end

GetUserRoles = function(source)
    local discordId = nil

    for _, _data in pairs(GetPlayerIdentifiers(source)) do 
        if (string.find(_data, "discord")) then 
            discordId = string.gsub(_data, "discord:", "")
            break
        end    
    end
    if (discordId) then 
        local endpoint = ("guilds/%s/members/%s"):format(Settings.DiscordSettings.GuildId, discordId)
        local requestRes = DiscordRequest("GET", endpoint, {})
        if (requestRes["code"] == 200) then 
            local reqData = json.decode(requestRes["data"])
            local discordRoles = reqData["roles"]
            return discordRoles
        else
            return false
        end
    else
        return false
    end
end

HasRole = function(source, roleName)
    for _, _data in pairs(GetUserRoles(source)) do 
        if (Settings.DiscordSettings["Roles"][_data] == roleName) then 
            return true
        end
    end
    return false
end 

GetTag = function(source)
    local src = source
    for _, _data in pairs(GetUserRoles(src)) do 
        if (Settings.DiscordSettings["Roles"][_data] ~= nil) then 
            return Settings.DiscordSettings["Roles"][_data]
        end
    end
    return false
end

RegisterCommand(Settings.TagCommand, function(source)
    local src = source 
    local data = ESX.GetPlayerFromId(src)
    local userTag = GetTag(src)

    if (userTag) then
        if (not GlobalState.Tags[src]) then 
            data.showNotification("~b~Pomyślnie Włączono Tag ~r~[" .. userTag .. "]")
            GlobalState.Tags[src] = userTag
        else
            data.showNotification("~b~Pomyślnie Wyłączono Tag ~r~[" .. userTag .. "]")
            GlobalState.Tags[src] = false
        end
    else
        data.showNotification("~b~Twoja Rola nie posiada Tagu!")
    end
end)


RegisterCommand(Settings.StreamerCommand, function(source) 
    local src = source 
    local data = ESX.GetPlayerFromId(src)

    if (HasRole(src, "Streamer")) then 
        if (not GlobalState.Streamers[src]) then 
            GlobalState.Streamers[src] = true
            data.showNotification("~b~Włączono Tag Streamera")
        else
            GlobalState.Streamers[src] = false 
            data.showNotification("~b~Wyłączono Tag Streamera")
        end
    else
        data.showNotification("~b~Nie posiadasz Rangi Streamer!")
    end
end)
