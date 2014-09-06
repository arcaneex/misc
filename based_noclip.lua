-- Someone asked me to make it so mods could just hit the default noclip key to noclip on DarkRP 
-- He didnt want them to have to bind ulx "noclip"

hook.Add('PlayerBindPress','NoclipULX',function(ply,bind,active)
	if bind == 'noclip' then
		concommand.Run(ply,'ulx',{'noclip'}) -- Basically imitates them entering the command in their actual console.
	end
end)