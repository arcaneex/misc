/*********************************************************************************************************************
*                                                                                                                    *
*                                       deagleMusic - Keeping the Admins Happy                                       *
*                                                                                                                    *
*********************************************************************************************************************/
-- made this basic script because admins were getting mad at me when I was playing music
-- It basically stops playing music when other people are talking and will continue playing when they stop.

CreateClientConVar("deag_safespam",0)
local playmusic = {}

local function updatemic()
if playmusic[1] != nil then
RunConsoleCommand("-voicerecord")
else
RunConsoleCommand("+voicerecord")
end
end

local function startvoice(ply)
	table.insert(playmusic,ply)
	updatemic()
end

local function endvoice(ply)
	for k,v in pairs(playmusic) do
		if v==ply then
			table.remove(playmusic,k)
		end
	end
	updatemic()
end






hook.Remove("PlayerStartVoice", "deagstartvoice")
hook.Remove("PlayerEndVoice", "deagendvoice")


if GetConVarNumber("deag_safespam") == 1 then
        hook.Add("PlayerStartVoice", "deagstartvoice", startvoice)
		hook.Add("PlayerEndVoice", "deagendvoice", endvoice)
end


cvars.AddChangeCallback("deag_safespam", function() 
        if GetConVarNumber("deag_safespam") == 1 then
                hook.Add("PlayerStartVoice", "deagstartvoice", startvoice)
			hook.Add("PlayerEndVoice", "deagendvoice", endvoice)
        else
			hook.Remove("PlayerStartVoice", "deagstartvoice")
			hook.Remove("PlayerEndVoice", "deagendvoice")
        end
		updatemic()
end)

MsgC(Color(0,255,0),"==============================".."\n")
MsgC(Color(0,255,0),"====Micspammer by Deagler=====\n")
MsgC(Color(0,255,0),"==============================".."\n")
RunConsoleCommand("say","deagleMusic loaded. F1>Player List to mute me.")
updatemic()