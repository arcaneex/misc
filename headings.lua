/************************************************************
*             simpleGenerate - Heading Generator            *
*Headings for various parts of your code/Titling your script*
*                                                           *
*                  Usage: headings <lines>                  *
*                                                           *
*         This heading was made with simpleGenerate         *
*                                                           *
*           Created by Deagler(STEAM_0:1:32634764)          *
************************************************************/
-- use headings2 "line" for single line headers that look decent.
-- Obviously very poorly coded, I made a version in C++ that is actually really nice and works well
-- check data/deagheadings/heading.txt for the saved headings.
-- feel free to improve on it if you want.

if !file.Exists("deagheadings", "DATA") then 
	file.CreateDir("deagheadings")
	file.Write("deagheadings/heading.txt","lol deaglers header generator because hes lazy\n")
end

function makeheading(ply,cmd,args)
	local longest = "";
	local symbol = "*"
	local line = "";
	local ourheading = {}
	MsgC(Color(255,128,0),"Adding Heading with "..#args.." lines\n");
	
	for k,v in pairs(args) do
		if string.len(longest) < string.len(args[k]) then
			longest = args[k];
		end
	end
	
	for k,v in pairs(args) do
	local spaces = ""
		if longest != v then
			local len = string.len(string.gsub(longest,"\\n","")) -string.len(string.gsub(v,"\\n","")) - 2
			local amt = math.Round(len/2)
			local works = len % 2
	--STEAM_0:1:32634764
			
			for i=0,amt do
				spaces=spaces.." "
			end
		
	
			if works > 0 then
				table.insert(ourheading,symbol..spaces..v..string.sub(spaces,0,string.len(spaces)-1)..symbol)
			else
				table.insert(ourheading,symbol..spaces..v..spaces..symbol)
			end
		else
			if #args == 1 and cmd == "heading" then
				for i=0,string.len(string.gsub(v,"\\n","")) do
					spaces=spaces.." "
				end
				table.insert(ourheading,symbol..spaces..v..spaces..symbol)
				longest = spaces..v..spaces
			else
				table.insert(ourheading,symbol..v..symbol)
			end
		end
		
	end

	
	
	for i=0,string.len(string.gsub(longest,"\\n","")) do
		line=string.gsub(line,"\\n","")..symbol
	end

	--[[
	MsgC(Color(0,255,0),"/"..line.."\n")
	for k,v in pairs(ourheading) do
		MsgC(Color(0,255,0),v.."\n")
	end
	MsgC(Color(0,255,0),line.."/\n")
	]]--
	
	
	
	
	file.Append("deagheadings/heading.txt","\n\n\n/"..string.gsub(line,"\\n","").."\n")
	if #args==1 and cmd == "heading" then
		file.Append("deagheadings/heading.txt",symbol..string.sub(string.gsub(string.gsub(line,"\\n",""),symbol," "),0,string.len(string.gsub(string.gsub(line,"\\n",""),symbol," "))-1)..symbol.."\n")
	end
	
	for k,v in pairs(ourheading) do
		local fixed,amount = string.gsub(v,"\\n","")
	
		file.Append("deagheadings/heading.txt",fixed.."\n")
		if amount>=1 then
			for i=1,amount do
				file.Append("deagheadings/heading.txt",symbol..string.sub(string.gsub(string.gsub(line,"\\n",""),symbol," "),0,string.len(string.gsub(string.gsub(line,"\\n",""),symbol," "))-1)..symbol.."\n")
			end
		end
	end
	if #args==1 and cmd == "heading" then
		file.Append("deagheadings/heading.txt",symbol..string.sub(string.gsub(string.gsub(line,"\\n",""),symbol," "),0,string.len(string.gsub(string.gsub(line,"\\n",""),symbol," "))-1)..symbol.."\n")
	end
	file.Append("deagheadings/heading.txt",line.."/")
	
	MsgC(Color(255,128,0),"Heading added to \"deagheadings/heading.txt\"\n")
	
end

concommand.Add("heading",makeheading)
concommand.Add("heading2",makeheading)