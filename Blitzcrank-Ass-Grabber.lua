if not VIP_USER or myHero.charName ~= "Blitzcrank" then return end

local  BlitzcrankAssGrabber_Version = 1.6

class "SxUpdate"
function SxUpdate:__init(LocalVersion, Host, VersionPath, ScriptPath, SavePath, Callback)
    self.Callback = Callback
    self.LocalVersion = LocalVersion
    self.Host = Host
    self.VersionPath = VersionPath
    self.ScriptPath = ScriptPath
    self.SavePath = SavePath
    self.LuaSocket = require("socket")
    AddTickCallback(function() self:GetOnlineVersion() end)
end

function SxUpdate:GetOnlineVersion()
    if not self.OnlineVersion and not self.VersionSocket then
        self.VersionSocket = self.LuaSocket.connect("sx-bol.eu", 80)
        self.VersionSocket:send("GET /BoL/TCPUpdater/GetScript.php?script="..self.Host..self.VersionPath.."&rand="..tostring(math.random(1000)).." HTTP/1.0\r\n\r\n")
    end

    if not self.OnlineVersion and self.VersionSocket then
        self.VersionSocket:settimeout(0, 'b')
        self.VersionSocket:settimeout(99999999, 't')
        self.VersionReceive, self.VersionStatus = self.VersionSocket:receive('*a')
    end

    if not self.OnlineVersion and self.VersionSocket and self.VersionStatus ~= 'timeout' then
        if self.VersionReceive then
            self.OnlineVersion = tonumber(string.sub(self.VersionReceive, string.find(self.VersionReceive, "<bols".."cript>")+11, string.find(self.VersionReceive, "</bols".."cript>")-1))
        else
            print('AutoUpdate Failed')
            self.OnlineVersion = 0
        end
        self:DownloadUpdate()
    end
end

function SxUpdate:DownloadUpdate()
    if self.OnlineVersion > self.LocalVersion then
        self.ScriptSocket = self.LuaSocket.connect("sx-bol.eu", 80)
        self.ScriptSocket:send("GET /BoL/TCPUpdater/GetScript.php?script="..self.Host..self.ScriptPath.."&rand="..tostring(math.random(1000)).." HTTP/1.0\r\n\r\n")
        self.ScriptReceive, self.ScriptStatus = self.ScriptSocket:receive('*a')
        self.ScriptRAW = string.sub(self.ScriptReceive, string.find(self.ScriptReceive, "<bols".."cript>")+11, string.find(self.ScriptReceive, "</bols".."cript>")-1)
        local ScriptFileOpen = io.open(self.SavePath, "w+")
        ScriptFileOpen:write(self.ScriptRAW)
        ScriptFileOpen:close()
    end

    if type(self.Callback) == 'function' then
        self.Callback(self.OnlineVersion)
    end
end

local ForceReload = false
SxUpdate(BlitzcrankAssGrabber_Version,
	"raw.githubusercontent.com",
	"/AMBER17/BoL/master/Blitzcrank-Ass-Grabber.Version",
	"/AMBER17/BoL/master/Blitzcrank-Ass-Grabber.lua",
	SCRIPT_PATH.."/" .. GetCurrentEnv().FILE_NAME,
	function(NewVersion) if NewVersion > BlitzcrankAssGrabber_Version then print("<font color=\"#F0Ff8d\"><b>Blitzcrank Ass-Grabber: </b></font> <font color=\"#FF0F0F\">Updated to "..NewVersion..". Please Reload with 2x F9</b></font>") ForceReload = true else print("<font color=\"#F0Ff8d\"><b>Blitzcrank Ass-Grabber: </b></font> <font color=\"#FF0F0F\">You have the Latest Version</b></font>") end 
end)
	
if FileExist(LIB_PATH .. "/SxOrbWalk.lua") then
	require("SxOrbWalk")
else
	SxUpdate(0,
		"raw.githubusercontent.com",
		"/Superx321/BoL/master/common/SxOrbWalk.Version",
		"/Superx321/BoL/master/common/SxOrbWalk.lua",
		LIB_PATH.."/SxOrbWalk.lua",
		function(NewVersion) if NewVersion > 0 then print("<font color=\"#F0Ff8d\"><b>SxOrbWalk: </b></font> <font color=\"#FF0F0F\">Updated to "..NewVersion..". Please Reload with 2x F9</b></font>") ForceReload = true end 
	end)
end
	
if FileExist(LIB_PATH .. "/VPrediction.lua") then
	require("VPrediction")
else
	SxUpdate(0,
		"raw.githubusercontent.com",
		"/Ralphlol/BoLGit/master/VPrediction.version",
		"/Ralphlol/BoLGit/master/VPrediction.lua",
		LIB_PATH.."/VPrediction.lua",
		function(NewVersion) if NewVersion > 0 then print("<font color=\"#F0Ff8d\"><b>VPrediction: </b></font> <font color=\"#FF0F0F\">Updated to "..NewVersion..". Please Reload with 2x F9</b></font>") ForceReload = true end 
	end)
end
------------------------------------------------------
------------------------------------------------------
------------------------------------------------------
--			 Callbacks				
------------------------------------------------------
------------------------------------------------------
-----------------------------------------------------

function OnLoad()
	print("<b><font color=\"#FF001E\">| Blitzcrank | Ass-Grabber | </font></b><font color=\"#FF980F\"> Have a Good Game !!! </font><font color=\"#FF001E\">| AMBER |</font>")
	TargetSelector = TargetSelector(TARGET_MOST_AD, 1250, DAMAGE_MAGICAL, false, true)
	Variables()
	Menu()
end

function OnTick()

	KillSteall()
	Checks()
	ComboKey = Settings.combo.comboKey
	
	TargetSelector:update()
	Target = GetCustomTarget()
	SxOrb:ForceTarget(Target)

	 test = tostring(math.ceil(ManashieldStrength()))
	
	if Settings.extra.baseW then 
		local pos = Vector(1316,1300) 
		if GetDistance(pos) < 800 then 
			CastW() 
		end
	end
	
	if Settings.extra.baseW then 
		local pos2 = Vector(13500,13600) 
		if GetDistance(pos2) < 800 then 
			CastW() 
		end
	end
	
	if Target ~= nil then
		if ComboKey then
			Combo(Target)
		end
	end
end

function OnDraw()

	if Settings.drawstats.stats then
		if Settings.drawstats.pourcentage then
			DrawText("Percentage Grab done : " .. tostring(math.ceil(pourcentage)) .. "%" ,18, 400, 920, 0xff00ff00)
		end
		if Settings.drawstats.grabdone then
			DrawText("Grab Done : "..tostring(nbgrabwin),18, 400, 940, 0xff00ff00)
		end
		if Settings.drawstats.grabfail then
			DrawText("Grab Miss : "..tostring(missedgrab),18, 400, 960, 0xFFFF0000)
		end
		if Settings.drawstats.mana and test ~= nil then
			DrawText("Passive's Shield : ".. tostring(math.ceil(test)) .. "HP" ,18, 400, 980, 0xffffff00)
		end
	end

	if not myHero.dead and not Settings.drawing.mDraw then	
		if ValidTarget(Target) then 
			if Settings.drawing.text then 
				DrawText3D("Current Target",Target.x-100, Target.y-50, Target.z, 20, 0xFFFFFF00)
			end
			if Settings.drawing.targetcircle then 
				DrawCircle(Target.x, Target.y, Target.z, 150, RGB(Settings.drawing.qColor[2], Settings.drawing.qColor[3], Settings.drawing.qColor[4]))
			end
		end
	
	
		if SkillQ.ready and Settings.drawing.qDraw then 
			DrawCircle(myHero.x, myHero.y, myHero.z, SkillQ.range, RGB(Settings.drawing.qColor[2], Settings.drawing.qColor[3], Settings.drawing.qColor[4]))
		end
		if SkillR.ready and Settings.drawing.rDraw then 
			DrawCircle(myHero.x, myHero.y, myHero.z, SkillR.range, RGB(Settings.drawing.rColor[2], Settings.drawing.rColor[3], Settings.drawing.rColor[4]))
		end
		
		if Settings.drawing.myHero then
			DrawCircle(myHero.x, myHero.y, myHero.z, myHero.range, RGB(Settings.drawing.myColor[2], Settings.drawing.myColor[3], Settings.drawing.myColor[4]))
		end
	end
end

------------------------------------------------------
------------------------------------------------------
------------------------------------------------------
--			 Functions				
------------------------------------------------------
------------------------------------------------------
------------------------------------------------------


function GetCustomTarget()
	if SelectedTarget ~= nil and ValidTarget(SelectedTarget, 1500) and (Ignore == nil or (Ignore.networkID ~= SelectedTarget.networkID)) then
		return SelectedTarget
	end
	TargetSelector:update()	
	if TargetSelector.target and not TargetSelector.target.dead and TargetSelector.target.type == myHero.type then
		return TargetSelector.target
	else
		return nil
	end
end


function OnWndMsg(Msg, Key)	
	
	if Msg == WM_LBUTTONDOWN then
		local minD = 0
		local Target = nil
		for i, unit in ipairs(GetEnemyHeroes()) do
			if ValidTarget(unit) then
				if GetDistance(unit, mousePos) <= minD or Target == nil then
					minD = GetDistance(unit, mousePos)
					Target = unit
				end
			end
		end

		if Target and minD < 115 then
			if SelectedTarget and Target.charName == SelectedTarget.charName then
				SelectedTarget = nil
			else
				SelectedTarget = Target
			end
		end
	end
end

function ManashieldStrength()
 local ShieldStrength = myHero.mana*0.5
 return ShieldStrength
end

function OnProcessSpell(unit, spell)
	
	if spell.name == "summonerteleport" and unit.isMe and Settings.extra.teleportW then 
		CastW()
	end
	
	if spell.name == "RocketGrab" and unit.isMe then
		nbgrabtotal=nbgrabtotal+1
		missedgrab = (nbgrabtotal-nbgrabwin)
		pourcentage =((nbgrabwin*100)/nbgrabtotal)
    end
end

function OnGainBuff(unit , buff)

	if buff.name == "rocketgrab2" and not unit.isMe and unit.type == myHero.type then 
		nbgrabwin = nbgrabwin + 0.2
		missedgrab = (nbgrabtotal-nbgrabwin)
		pourcentage =((nbgrabwin*100)/nbgrabtotal)
	end	
	
end


function KillSteall()
	for _, unit in pairs(GetEnemyHeroes()) do
		local health = unit.health
		local dmgR = getDmg("R", unit, myHero) + (myHero.ap)
			if health < dmgR*0.95 and Settings.killsteal.useR and ValidTarget(unit) then
				CastR(unit)
			end
	 end
end

function Combo(unit)
	if ValidTarget(unit) and unit ~= nil and unit.type == myHero.type then
	
		CastQ(unit)
		
		CastE(unit)
		
		if Settings.combo.useR then 
			if not Settings.combo.useRafterE then
				CastR(unit)
			end
		end
		if Settings.combo.RifKilable then
				local dmgR = getDmg("R", unit, myHero) + (myHero.ap)
				if unit.health < dmgR*0.95 then
					CastR(unit)
				end
		end
	end
end
	
function CastE(unit)
	if GetDistance(unit) <= SkillE.range and SkillE.ready then
			Packet("S_CAST", {spellId = _E}):send()
			myHero:Attack(unit)
	end	
end

function CastQ(unit)
	if unit ~= nil and GetDistance(unit) <= SkillQ.range and SkillQ.ready then
		CastPosition,  HitChance,  Position = VP:GetLineCastPosition(unit, SkillQ.delay, SkillQ.width, SkillQ.range, SkillQ.speed, myHero, true)	
		
		if HitChance >= 2 then
			Packet("S_CAST", {spellId = _Q, fromX = CastPosition.x, fromY = CastPosition.z, toX = CastPosition.x, toY = CastPosition.z}):send()
		end
	end
end

function CastW()
	if SkillW.ready then
		Packet("S_CAST", {spellId = _W}):send()
	end
end

function CastR(unit)
	if GetDistance(unit) <= SkillR.range and SkillR.ready then
		Packet("S_CAST", {spellId = _R}):send()
	end	
end

------------------------------------------------------
------------------------------------------------------
------------------------------------------------------
--			MENU & CHECKS
------------------------------------------------------
------------------------------------------------------
------------------------------------------------------

function Checks()
	SkillQ.ready = (myHero:CanUseSpell(_Q) == READY)
	SkillW.ready = (myHero:CanUseSpell(_W) == READY)
	SkillE.ready = (myHero:CanUseSpell(_E) == READY)
	SkillR.ready = (myHero:CanUseSpell(_R) == READY)

	 _G.DrawCircle = _G.oldDrawCircle 
	 
end

function Menu()
	Settings = scriptConfig("| | Blitzcrank | Ass-Grabber | |", "AMBER")
	
	Settings:addSubMenu("["..myHero.charName.."] - Combo Settings", "combo")
		Settings.combo:addParam("comboKey", "Combo Key", SCRIPT_PARAM_ONKEYDOWN, false, 32)
		Settings.combo:addParam("useE", "Use (E) in Combo", SCRIPT_PARAM_ONOFF, true)
		Settings.combo:addParam("useR", "Use (R) in Combo", SCRIPT_PARAM_ONOFF, false)
		Settings.combo:addParam("RifKilable", "Use (R) if unit is kilable", SCRIPT_PARAM_ONOFF, true)
		
	Settings:addSubMenu("["..myHero.charName.."] - KillSteal", "killsteal")	
	Settings.killsteal:addParam("useR", "Steal With (R)", SCRIPT_PARAM_ONOFF, true)
	
	Settings:addSubMenu("["..myHero.charName.."] - Extra Option", "extra")
	Settings.extra:addParam("teleportW", "Auto use (W) after a teleport", SCRIPT_PARAM_ONOFF, true)
	Settings.extra:addParam("baseW", "Auto use (W) when leave base", SCRIPT_PARAM_ONOFF, true)
	
	Settings:addSubMenu("["..myHero.charName.."] - Draw Settings", "drawing")	
		Settings.drawing:addParam("mDraw", "Disable All Range Draws", SCRIPT_PARAM_ONOFF, false)
		Settings.drawing:addParam("myHero", "Draw My Range", SCRIPT_PARAM_ONOFF, true)
		Settings.drawing:addParam("myColor", "Draw My Range Color", SCRIPT_PARAM_COLOR, {0, 100, 44, 255})
		Settings.drawing:addParam("qDraw", "Draw "..SkillQ.name.." (Q) Range", SCRIPT_PARAM_ONOFF, true)
		Settings.drawing:addParam("qColor", "Draw "..SkillQ.name.." (Q) Color", SCRIPT_PARAM_COLOR, {0, 100, 44, 255})
		Settings.drawing:addParam("rDraw", "Draw "..SkillR.name.." (R) Range", SCRIPT_PARAM_ONOFF, true)
		Settings.drawing:addParam("rColor", "Draw "..SkillR.name.." (R) Color", SCRIPT_PARAM_COLOR, {0, 100, 44, 255})
		Settings.drawing:addParam("text", "Draw Current Target", SCRIPT_PARAM_ONOFF, true)
		Settings.drawing:addParam("targetcircle", "Draw Circle On Target", SCRIPT_PARAM_ONOFF, true)
		
		
	Settings:addSubMenu("["..myHero.charName.."] - Draw Stats", "drawstats")
		Settings.drawstats:addParam("stats", "Show Stats & Passive's shield", SCRIPT_PARAM_ONOFF, true)
		Settings.drawstats:addParam("pourcentage", "Show Pourcentage", SCRIPT_PARAM_ONOFF, true)
		Settings.drawstats:addParam("grabdone", "Show Grab Done", SCRIPT_PARAM_ONOFF, true)
		Settings.drawstats:addParam("grabfail", "Show Grab Fail", SCRIPT_PARAM_ONOFF, true)
		Settings.drawstats:addParam("mana", "Show Passive's shield", SCRIPT_PARAM_ONOFF, true)
		
	Settings:addSubMenu("["..myHero.charName.."] - Orbwalking Settings", "Orbwalking")
		SxOrb:LoadToMenu(Settings.Orbwalking)
	
		Settings.combo:permaShow("comboKey")
		Settings.combo:permaShow("useR")
		Settings.combo:permaShow("RifKilable")
		Settings.killsteal:permaShow("useR")
		Settings.extra:permaShow("teleportW")
		Settings.extra:permaShow("baseW")
	
	TargetSelector.name = "Blitzcrank"
	Settings:addTS(TargetSelector)
	
end

function Variables()
	SkillQ = { name = "Rocket Grab", range = 925, delay = 0.25, speed = math.huge, width = 80, ready = false }
	SkillW = { name = "Overdrive", range = nil, delay = 0.375, speed = math.huge, width = nil, ready = false }
	SkillE = { name = "Power Fist", range = 280, delay = nil, speed = nil, width = nil, ready = false }
	SkillR = { name = "Static Field", range = 590, delay = 0.5, speed = math.huge, angle = 80, ready = false }
	
	nbgrabtotal= 0
	missedgrab = 0
	pourcentage = 0
	nbgrabwin = 0
	VP = VPrediction()
	local ts
	local Target

	_G.oldDrawCircle = rawget(_G, 'DrawCircle')
	_G.DrawCircle = DrawCircle2
end


function DrawCircle2(x, y, z, radius, color)
  local vPos1 = Vector(x, y, z)
  local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
  local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
  local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
end

----- LINK SCRIPT STATUT ----- 
assert(load(Base64Decode("G0x1YVIAAQQEBAgAGZMNChoKAAAAAAAAAAAAAQIKAAAABgBAAEFAAAAdQAABBkBAAGUAAAAKQACBBkBAAGVAAAAKQICBHwCAAAQAAAAEBgAAAGNsYXNzAAQNAAAAU2NyaXB0U3RhdHVzAAQHAAAAX19pbml0AAQLAAAAU2VuZFVwZGF0ZQACAAAAAgAAAAgAAAACAAotAAAAhkBAAMaAQAAGwUAABwFBAkFBAQAdgQABRsFAAEcBwQKBgQEAXYEAAYbBQACHAUEDwcEBAJ2BAAHGwUAAxwHBAwECAgDdgQABBsJAAAcCQQRBQgIAHYIAARYBAgLdAAABnYAAAAqAAIAKQACFhgBDAMHAAgCdgAABCoCAhQqAw4aGAEQAx8BCAMfAwwHdAIAAnYAAAAqAgIeMQEQAAYEEAJ1AgAGGwEQA5QAAAJ1AAAEfAIAAFAAAAAQFAAAAaHdpZAAEDQAAAEJhc2U2NEVuY29kZQAECQAAAHRvc3RyaW5nAAQDAAAAb3MABAcAAABnZXRlbnYABBUAAABQUk9DRVNTT1JfSURFTlRJRklFUgAECQAAAFVTRVJOQU1FAAQNAAAAQ09NUFVURVJOQU1FAAQQAAAAUFJPQ0VTU09SX0xFVkVMAAQTAAAAUFJPQ0VTU09SX1JFVklTSU9OAAQEAAAAS2V5AAQHAAAAc29ja2V0AAQIAAAAcmVxdWlyZQAECgAAAGdhbWVTdGF0ZQAABAQAAAB0Y3AABAcAAABhc3NlcnQABAsAAABTZW5kVXBkYXRlAAMAAAAAAADwPwQUAAAAQWRkQnVnc3BsYXRDYWxsYmFjawABAAAACAAAAAgAAAAAAAMFAAAABQAAAAwAQACBQAAAHUCAAR8AgAACAAAABAsAAABTZW5kVXBkYXRlAAMAAAAAAAAAQAAAAAABAAAAAQAQAAAAQG9iZnVzY2F0ZWQubHVhAAUAAAAIAAAACAAAAAgAAAAIAAAACAAAAAAAAAABAAAABQAAAHNlbGYAAQAAAAAAEAAAAEBvYmZ1c2NhdGVkLmx1YQAtAAAAAwAAAAMAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABgAAAAYAAAAGAAAABgAAAAUAAAADAAAAAwAAAAYAAAAGAAAABgAAAAYAAAAGAAAABgAAAAYAAAAHAAAABwAAAAcAAAAHAAAABwAAAAcAAAAHAAAABwAAAAcAAAAIAAAACAAAAAgAAAAIAAAAAgAAAAUAAABzZWxmAAAAAAAtAAAAAgAAAGEAAAAAAC0AAAABAAAABQAAAF9FTlYACQAAAA4AAAACAA0XAAAAhwBAAIxAQAEBgQAAQcEAAJ1AAAKHAEAAjABBAQFBAQBHgUEAgcEBAMcBQgABwgEAQAKAAIHCAQDGQkIAx4LCBQHDAgAWAQMCnUCAAYcAQACMAEMBnUAAAR8AgAANAAAABAQAAAB0Y3AABAgAAABjb25uZWN0AAQRAAAAc2NyaXB0c3RhdHVzLm5ldAADAAAAAAAAVEAEBQAAAHNlbmQABAsAAABHRVQgL3N5bmMtAAQEAAAAS2V5AAQCAAAALQAEBQAAAGh3aWQABAcAAABteUhlcm8ABAkAAABjaGFyTmFtZQAEJgAAACBIVFRQLzEuMA0KSG9zdDogc2NyaXB0c3RhdHVzLm5ldA0KDQoABAYAAABjbG9zZQAAAAAAAQAAAAAAEAAAAEBvYmZ1c2NhdGVkLmx1YQAXAAAACgAAAAoAAAAKAAAACgAAAAoAAAALAAAACwAAAAsAAAALAAAADAAAAAwAAAANAAAADQAAAA0AAAAOAAAADgAAAA4AAAAOAAAACwAAAA4AAAAOAAAADgAAAA4AAAACAAAABQAAAHNlbGYAAAAAABcAAAACAAAAYQAAAAAAFwAAAAEAAAAFAAAAX0VOVgABAAAAAQAQAAAAQG9iZnVzY2F0ZWQubHVhAAoAAAABAAAAAQAAAAEAAAACAAAACAAAAAIAAAAJAAAADgAAAAkAAAAOAAAAAAAAAAEAAAAFAAAAX0VOVgA="), nil, "bt", _ENV))() ScriptStatus("TGJHHMHFMMI") 
