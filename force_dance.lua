-- created by deagler
-- does what you think it does.

local CATEGORY_NAME = "Fun"

function ulx.fdance( calling_ply, target_plys )
	local affected_plys = {}
	local dances = {
	"dance",
	"robot",
	"muscle"
	}
	for i=1, #target_plys do
		local v = target_plys[ i ]
		if IsValid(v) then
			v:SendLua([[LocalPlayer():ConCommand("act ]]..table.Random(dances)..[[")]])
			table.insert( affected_plys, v )
		end
	end

	ulx.fancyLogAdmin( calling_ply, "#A forced #T into a dance frenzy!", affected_plys)
end

local fdance = ulx.command( CATEGORY_NAME, "ulx fdance", ulx.fdance, "!fdance" )
fdance:addParam{ type=ULib.cmds.PlayersArg }
fdance:defaultAccess( ULib.ACCESS_ADMIN )
fdance:help( "Put people into a dancy frenzy!" )