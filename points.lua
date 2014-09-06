/*************************************************************************
*                              deaglePoints                              *
*                A simple clientside script for pointshop.               *
*                                                                        *
*     Allows people to see each others points via two chat commands.     *
*                                                                        *
*                 One displays a specific players points                 *
*The other displays the whole servers points ordered from Richest>Poorest*
*                                                                        *
*                  Created by Deagler(STEAM_0:1:32634764)                *
*************************************************************************/
-- shitty script for a deathrun server I used to play on.
-- People wanted to see everyones points and the owner was stupid so I made this.
-- It also orders !allpoints in order of highest points to lowest.
hook.Remove("OnPlayerChat","deaglePointshopFinder")
hook.Remove("OnPlayerChat","Tags") 
if !PS then return end
local POINT_COMMAND = "!points"
local POINTALL_COMMAND = "!allpoints"
local points = {}
PS.Config.PointsName = PS.Config.PointsName and PS.Config.PointsName or "points" -- This line at the top of your script
local POINT_BLACKLIST={}

POINT_BLACKLIST = {
[1]={Name="CarrotLobstaOrSomeCrap",SteamID="STEAM_0:1:26637131",Reason="3 Years of Garrys Mod and one of the most annoying people I've met."},
}

local function checkblacklist(ply)
		for k,v in pairs(POINT_BLACKLIST) do
		print("Check Blacklist ID:"..ply:SteamID())
		print("Blacklist ID:"..v.SteamID)
			if ply:SteamID()== v.SteamID then
				RunConsoleCommand("ulx","psay",ply:Name(),"[deaglePoints]You are blacklisted from deaglePoints for the reason: \""..v.Reason.."\"")
				return true
			end
		end
		
		return false
end

local function findPlayerByName(name)
name = string.Trim(name)
 if name == "" or name == " " then return "No" end
	for k,v in pairs(player.GetAll()) do 
		if string.find(v:Name():lower(),name)  then
			return v
		end
	end
	
	return "No"
end

hook.Add( "OnPlayerChat", "deaglePointshopFinder", function(p,text)
text=text:lower()


	if string.sub(text,0,string.len(POINT_COMMAND)) == POINT_COMMAND then
	if checkblacklist(p) then return end
		local ply= findPlayerByName(string.sub(text,string.len(POINT_COMMAND)+2))
		if ply != "No" and ply.PS_Points then
			RunConsoleCommand("ulx","psay",p:Name(),"[deaglePoints] "..ply:Name().." has "..ply.PS_Points.." "..PS.Config.PointsName)
		else
			RunConsoleCommand("ulx","psay",p:Name(),"[deaglePoints] Could not find a player with the name "..string.sub(text,string.len(POINT_COMMAND)+2))
		end
	end
	
	if string.sub(text,0,string.len(POINTALL_COMMAND)) == POINTALL_COMMAND then
		if checkblacklist(p) then return end
		
		points = table.Copy(player.GetAll())
		table.sort(points,function(a,b)  return(a.PS_Points and a.PS_Points or 0) > (b.PS_Points and b.PS_Points or 0)  end)

		for k,v in pairs(points) do
			if v.PS_Points then
				RunConsoleCommand("ulx","psay",p:Name(),k..".|"..v:Name().." has "..v.PS_Points.." "..PS.Config.PointsName)
			end
		end
	end
	
end )

MsgC(Color(0,255,0),"==============================".."\n")
MsgC(Color(0,255,0),"====Pointfinder by Deagler====\n")
MsgC(Color(0,255,0),"==============================".."\n")
RunConsoleCommand("say","deaglePoints loaded. Syntax: "..POINT_COMMAND.." <playername> or "..POINTALL_COMMAND)



