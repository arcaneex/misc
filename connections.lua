-- Quickly made Recent disconnecters/Connect/Disconnect notifications. 
-- Sleek and easy to use, Place in lua/autorun
-- Probably poorly optimised/poorly coded, I made it a while back and rather quickly feel free to improve.

bm_DisconnectTable = bm_DisconnectTable or {}

local admingroups = {
"superadmin",
"admin",
"mod"

}

local reasons = {
{reason="RDM and Leave",default=true},
{reason="Mass RDM",default=false},
{reason="Hacking",default=false},
{reason="Other",default=false}
}


if SERVER then
util.AddNetworkString('SendConnectMsg')
util.AddNetworkString('SendAdminDCMenu')
util.AddNetworkString('SendUserDCMenu')
hook.Add('PlayerInitialSpawn','DoConnect_bMenu',function(ply)
	if !ply then return end
	if !ply:IsPlayer() then return end
	timer.Simple(0.2,function()
		local lastconnect = ply:GetPData('b_LastConnectTime')
		local lastname = ply:GetPData('b_LastConnectName')
		local plycol= hook.Call("TTTScoreboardColorForPlayer", GAMEMODE, ply)
		local str
		ply:SetPData('b_LastConnectTime',os.time())
		ply:SetPData('b_LastConnectName',ply:Nick())
		
		if !lastconnect then
			net.Start('SendConnectMsg')
				net.WriteTable({plycol,ply:Nick(),Color(255,255,255)," has joined the server for the first time!"})
			net.Broadcast()
			return
		end
		if lastname then
			if lastconnect and lastname!=ply:Nick() then
				local time = os.time()-lastconnect
				time = string.NiceTime(time)

				net.Start('SendConnectMsg')
					net.WriteTable({plycol,ply:Nick(),Color(255,255,255)," has joined the server. They last joined "..time.." ago under the name \""..lastname.."\"!"})
				net.Broadcast()
				return
			end
		
			if lastconnect and lastname==ply:Nick() then
				str = "%s has joined the server. They last joined %s ago!"
				local time = os.time()-lastconnect
				time = string.NiceTime(time)
				net.Start('SendConnectMsg')
					net.WriteTable({plycol,ply:Nick(),Color(255,255,255)," has joined the server. They last joined "..time.." ago!"})
				net.Broadcast()
				return
			end
		end
	
		
	
	end)
end)

hook.Add('PlayerDisconnected','DoDisconnect_bMenu',function(ply)
if !ply then return end
table.insert(bm_DisconnectTable,
{
steamid=ply:SteamID(),
steamid64=ply:SteamID64(),
name=ply:Nick(),
ip=ply:IPAddress(),
time=os.time()
})

for k,v in pairs(player.GetAll()) do
	if IsValid(v) then
		v:PrintMessage(HUD_PRINTCONSOLE,ply:SteamID())
		net.Start('SendConnectMsg')
			net.WriteTable({plycol,ply:Nick(),Color(255,255,255),"("..ply:SteamID()..") has disconnected from the server."})
		net.Send(v)
	end
end

end)

concommand.Add("bmenu_opendcmenu",function(ply)
	if table.HasValue(admingroups,ply:GetNWInt('usergroup')) then
		local tab = table.Copy(bm_DisconnectTable)
		
			for k,v in pairs(tab) do
				if !ply:IsSuperAdmin() then
					tab[k].ip = "NO IP 4 U HACKER -  Deagler"
				end
				tab[k].time = os.time()-v.time	
				
			end
	
		net.Start('SendAdminDCMenu')
			net.WriteTable(tab)
		net.Send(ply)
		return
	else
		local tab = table.Copy(bm_DisconnectTable)
		for k,v in pairs(tab) do
			tab[k].ip = "NO IP 4 U HACKER -  Deagler"
			tab[k].time = os.time()-v.time	
		end
	
		
		net.Start('SendUserDCMenu')
			net.WriteTable(tab)
		net.Send(ply)
	
	end
end)
end

if CLIENT then
	surface.CreateFont( "b_Name", {
		font = "Arial",
		size = 18,
		weight = 900,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = true,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
	} )
	net.Receive('SendConnectMsg',function()
		local tab = net.ReadTable()
		
		chat.AddText(unpack(tab))
	
	end)
	
	net.Receive('SendAdminDCMenu',function()
		local dcs=net.ReadTable()
		
		local frame = vgui.Create("DFrame")
		frame:SetSize(500,235)
		frame:Center()
		frame:MakePopup()
		frame:SetTitle("Recently Disconnected Players")
		
		local infopanel = vgui.Create('DPanel',frame)
		infopanel:SetSize(180,200)
		infopanel:SetPos(310,26)
		
		local namelabel = vgui.Create('DLabel',infopanel)
		namelabel:SetFont('b_Name')
		namelabel:SetText("Select a Player!")
		namelabel:SizeToContents()
		namelabel:SetPos(30,10)
		namelabel:SetTextColor(Color(0,0,0))

		local banid = vgui.Create("DTextEntry",infopanel)
		banid:SetWide(infopanel:GetWide()-3)
		banid:SetPos(1,100-25)
		banid:SetText("SteamID")
		
		local bantime = vgui.Create("DTextEntry",infopanel)
		bantime:SetWide(76)
		bantime:SetPos(1,123-25)
		bantime:SetText("1")
		local current
		local bantimes = vgui.Create("DComboBox",infopanel)
		bantimes:SetWide(100)
		bantimes:SetPos(78,123-25)
		bantimes:AddChoice("Minutes")
		bantimes:AddChoice("Hours")
		bantimes:AddChoice("Days")
		bantimes:AddChoice("Weeks")
		bantimes:AddChoice("Permanent")
		bantimes:ChooseOption("Minutes")
		bantimes.OnSelect = function(p,i,val)
			current=val
		end
		
		local currentreason
		local arewevisible=false
		local reason = vgui.Create("DTextEntry",infopanel)
		reason:SetWide(infopanel:GetWide()-3)
		reason:SetPos(1,146)
		reason:SetText("reason")
		reason:SetVisible(false)
		
		local reasonbox = vgui.Create("DComboBox",infopanel)
		reasonbox:SetWide(infopanel:GetWide()-3)
		reasonbox:SetPos(1,123)
		for k,v in pairs(reasons) do
			if v.reason then
				reasonbox:AddChoice(v.reason)
				if v.default then
					reasonbox:ChooseOption(v.reason)
					currentreason=v.reason
				end
			end
		end
		reasonbox.OnSelect = function(p,i,val)
			currentreason=val
			if val != "Other" then
				reason:SetVisible(false)
				arewevisible = false
			else
				reason:SetVisible(true)
				arewevisible = true
			end
			
		end
		
		
		local ban = vgui.Create("DButton",infopanel)
		ban:SetSize(infopanel:GetWide()-3,28)
		ban:SetPos(1,170)
		ban:SetText("Ban")
		ban.DoClick= function()
			local id = banid:GetText()
			local time=bantime:GetText()
			if current=="Minutes" then
				time=time
			elseif current=="Hours" then
				time=time.."h"
			elseif current=="Days" then
				time=time.."d"
			elseif current=="Weeks" then
				time=time.."w"
			elseif current=="Permanent" then
				time=0
			end
			local res
			if arewevisible == true then
				res=tostring(reason:GetText())
			else
				res=currentreason
			end
			RunConsoleCommand("ulx","banid",id,time,res)
			
		
		end
		local listview = vgui.Create("DListView",frame)
		listview:SetSize(300,200)
		listview:SetPos(4,26)
		listview:SetMultiSelect(false)
		listview.OnRowSelected=function(panel,line)
			local tab = util.JSONToTable(panel:GetLine(line):GetValue(3))
			
			namelabel:SetText(tab.name)
			namelabel:SizeToContents()
			local w = surface.GetTextSize(tab.name)
			--namelabel:SetPos(infopanel:GetWide()/2-w,10)
			namelabel:Center()
			local x,y = namelabel:GetPos()
			namelabel:SetPos(x,10)
			
			banid:SetText(tab.steamid)
			
			
		end
		
	
		local info = listview:AddColumn("Disconnected Players")
		info:SetFixedWidth(listview:GetWide())
		info.DoClick = function() return end
	
		local time = listview:AddColumn("")
		time:SetFixedWidth(0)
		time.DoClick = function() return end
		
		local data = listview:AddColumn("")
		data:SetFixedWidth(0)
		data.DoClick=function() return end
		
		for k,v in pairs(dcs) do
		
			local line = listview:AddLine(Format("%s disconnected %s ago.",v.name,string.NiceTime(v.time)),v.time,util.TableToJSON(v))
			listview:SortByColumn(2,false)
		
			line.OnRightClick= function()
				local menu = DermaMenu()
				local row
				
				local header = menu:AddOption(v.name)
				header:SetTextInset(10, 0)
				header.OnCursorEntered = function() end
				header.PaintOver = function() surface.SetDrawColor(0, 0, 0, 50) surface.DrawRect(0, 0, header:GetWide(), header:GetTall()) end
				header:SetIcon('icon16/user.png')
				
				menu:AddSpacer()
				menu:AddSpacer()
	
				row = menu:AddOption("Copy SteamID",function()
					SetClipboardText(v.steamid)
					chat.AddText(Color(255,128,0),v.name.."'s SteamID has been copied to your clipboard!")
				end)
				row:SetIcon('icon16/table_go.png')
				row:SetTextInset(0,0)
				if LocalPlayer():IsSuperAdmin() then
				row = menu:AddOption("Copy IP Address",function()
					SetClipboardText(v.ip)
					chat.AddText(Color(255,128,0),v.name.."'s IP Address has been copied to your clipboard!")
				end)
				row:SetIcon('icon16/table_go.png')
				row:SetTextInset(0,0)
				end
				row = menu:AddOption("View Profile",function()
					gui.OpenURL('http://steamcommunity.com/profiles/'..v.steamid64..'/')
				end)
				row:SetIcon('icon16/information.png')
				row:SetTextInset(0, 0)
				
				menu:Open()
			end
		end
	end)
	
	net.Receive('SendUserDCMenu',function()
		local dcs=net.ReadTable()
		
		local frame = vgui.Create("DFrame")
		frame:SetSize(310,235)
		frame:Center()
		frame:MakePopup()
		frame:SetTitle("Recently Disconnected Players")
		
		local listview = vgui.Create("DListView",frame)
		listview:SetSize(300,200)
		listview:SetPos(4,26)
		listview:SetMultiSelect(false)
	
		local info = listview:AddColumn("Disconnected Players")
		info:SetFixedWidth(listview:GetWide())
		info.DoClick = function() return end
	
		local time = listview:AddColumn("")
		time:SetFixedWidth(0)
		time.DoClick = function() return end
		
		local data = listview:AddColumn("")
		data:SetFixedWidth(0)
		data.DoClick=function() return end
		
		for k,v in pairs(dcs) do
		
			local line = listview:AddLine(Format("%s disconnected %s ago.",v.name,string.NiceTime(v.time)),v.time,util.TableToJSON(v))
			listview:SortByColumn(2,false)
		
			line.OnRightClick= function()
				local menu = DermaMenu()
				local row
				
				local header = menu:AddOption(v.name)
				header:SetTextInset(10, 0)
				header.OnCursorEntered = function() end
				header.PaintOver = function() surface.SetDrawColor(0, 0, 0, 50) surface.DrawRect(0, 0, header:GetWide(), header:GetTall()) end
				header:SetIcon('icon16/user.png')
				
				menu:AddSpacer()
				menu:AddSpacer()
	
				row = menu:AddOption("Copy SteamID",function()
					SetClipboardText(v.steamid)
					chat.AddText(Color(255,128,0),v.name.."'s SteamID has been copied to your clipboard!")
				end)
				row:SetIcon('icon16/table_go.png')
				row:SetTextInset(0,0)
				if LocalPlayer():IsSuperAdmin() then
				row = menu:AddOption("Copy IP Address",function()
					SetClipboardText(v.ip)
					chat.AddText(Color(255,128,0),v.name.."'s IP Address has been copied to your clipboard!")
				end)
				row:SetIcon('icon16/table_go.png')
				row:SetTextInset(0,0)
				end
				row = menu:AddOption("View Profile",function()
					gui.OpenURL('http://steamcommunity.com/profiles/'..v.steamid64..'/')
				end)
				row:SetIcon('icon16/information.png')
				row:SetTextInset(0, 0)
				
				menu:Open()
			end
		end
	end)
end