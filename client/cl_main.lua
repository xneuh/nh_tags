local ppid = PlayerPedId()
local isDisplaying = false

CreateThread(function()
    while true do 
        Wait(2500)
        ppid = PlayerPedId()
    end
end)

CreateThread(function()
    while true do 
        Wait(0)

        if (isDisplaying) then 
            for _, player in ipairs(GetActivePlayers()) do
                if (id ~= player) then
                    local playerPed = GetPlayerPed(player)
                    local boneCoords = {
                        ["PlayerCoords"] = GetPedBoneCoords(ppid, 31086, -0.4, 0.0, 0.0),
                        ["TargetCoords"] = GetPedBoneCoords(playerPed, 31086, -0.4, 0.0, 0.0)
                    }
                    if (#(boneCoords["PlayerCoords"] - boneCoords["TargetCoords"]) < Settings.DrawDistance) then
                        
                        if (GlobalState.Tags[GetPlayerServerId(player)]) then 
                            DrawText3DSmall(boneCoords["TargetCoords"].x, boneCoords["TargetCoords"].y, boneCoords["TargetCoords"].z + 0.8, GlobalState.Tags[GetPlayerServerId(player)] .. " | " .. GetPlayerName(player), Settings.TagColors[GlobalState.Tags[GetPlayerServerId(player)]])
                        end
    
                        if (GlobalState.Streamers[GetPlayerServerId(player)]) then 
                            DrawText3DSmall(boneCoords["TargetCoords"].x, boneCoords["TargetCoords"].y, boneCoords["TargetCoords"].z + 0.92, "Streamer", Settings.TagColors["Streamer"])
                        end
                    end
                end  
            end	
        else
            Wait(255)
        end				
    end
end)

function DrawText3DSmall(x, y, z, text, color)
    local onScreen, _x, _y = World3dToScreen2d(x,y,z)
	
    local scale = (1 / #(GetGameplayCamCoords() - vec3(x, y, z))) * 1.0
    local fov = (1 / GetGameplayCamFov()) * 100
    scale = scale * fov
    
    if onScreen then
        SetTextScale(0.7 * scale, 1.1 * scale)
        SetTextFont(0)
        SetTextColour(color[1], color[2], color[3], 255)
        SetTextDropshadow(0, 0, 5, 0, 255)
        SetTextDropShadow()
        SetTextOutline()
		SetTextCentre(1)

        SetTextEntry("STRING")
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

RegisterCommand('+tags', function()
    isDisplaying = true
end, false)

RegisterCommand('-tags', function()
    isDisplaying = false
end, false)

RegisterKeyMapping('+tags', 'Show Tags', 'keyboard', 'Z')
