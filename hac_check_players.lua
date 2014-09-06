-- run on client, basically prints every person that is banned by HAC AND on ur servers, some are manual bans.
-- created by deagler
local banlist


http.Fetch("http://unitedhosts.org/bar/tmp/hac_db_all.json",function(body)
	banlist = util.JSONToTable(body);
	
	MsgC(Color(255,128,0,255),"FLAGGED PLAYERS:\n");
	for k,v in pairs(player.GetAll()) do
		if banlist[v:SteamID()] then
			MsgC(Color(0,235,0,255),Format("%s for the reason \"%s\"",v:Nick(),banlist[v:SteamID()]))
		end
	end
end)