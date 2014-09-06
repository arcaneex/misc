--basic server whitelist
-- created by deagler

local Whitelist = {
	"STEAM_0:0:55864032", 
	"Steam_0:0:0",
	"Steam_0:0:0",
	"Steam_0:0:0"
}


local function inWhitelist(ply)
	return ( table.HasValue(Whitelist,ply:SteamID()) );
end


hook.Add("PlayerConnect","WhitelistCheck",function(ply)
	if !inWhitelist(ply) then
		ply:Kick("You are not whitelisted. Please apply for the whitelist at www.________.com");
	end
end)