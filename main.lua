
io.stdout:setvbuf("no") --控制台输出窗口,优先输出如果没有则在程序结束后再输出的
	
--[[ 
	项目主体部分
	
--]]
math.randomseed(os.time())
local ID = math.random(0,10000)

class = require "middleclass"
tween = require "tween"
sock = require "sock"
local binser = require "spec.binser"
require "unknown"
require "brick"
require "musicbrick"
require "player"

function getLocalIP()
	local ri = '192.111.111.111'
	local po = '19245'
	local ru = socket.udp()
	ru:setpeername(ri,po)
	local localIP,_ = ru:getsockname()
	ru:close()
	print(localIP)
	return localIP
end

function currDir()  
	os.execute("cd > cd.tmp")  
	local f = io.open("cd.tmp", r)  
	local cwd = f:read("*a")  
	f:close()  
	os.remove("cd.tmp")  
	return cwd  
end

function analysis(m,r)
	local tab = m
	local result = r or {}
	for k,v in pairs(tab) do
		if #result>0 and v~= 0 then
			local insertAllow = true
			for i,j in pairs(result) do
				if v==j then
					insertAllow = false
				end
			end
			if insertAllow then
				table.insert(result,v)
			end
		elseif v~= 0 then
			table.insert(result,v)
		end
	end
	return result
end

function blockanalysis(m,w,s)
	for k,v in pairs(m.tiles) do
		if v == 286 then
			table.insert(m.specialBlocks,unknown(k%m.width,math.ceil(k/m.width)))
		elseif v==451 then
			table.insert(m.specialBlocks,brick(k%m.width,math.ceil(k/m.width),v))
		elseif v==283 then
			table.insert(m.specialBlocks,musicbrick(k%m.width,math.ceil(k/m.width),v))
		end
		local body = love.physics.newBody(w,(k%m.width-1)*32,math.ceil(k/m.width)*32-32,"static")
		if v == 1016 then
			love.physics.newFixture(body, s.triangleLeftDown,1)
		elseif v~= 0 then
			love.physics.newFixture(body, s.rect,1)
		else
			body:destroy()
			body = nil
		end
		if body then
			table.insert(m.bodies,body)
		end
	end
end


local Map = {}
local content = love.filesystem.read("Maps/Map.lua")
Map.width,Map.height,Map.background,Map.tiles,Map.hiddenTiles = loadstring(content)()
Map.specialBlocks = {}
local include = analysis(Map.background)
include = analysis(Map.tiles,include)
include = analysis(Map.hiddenTiles,include)

function love.load() --资源加载回调函数，仅初始化时调用一次
	IPBuffer = ""
	_WORLD = love.physics.newWorld(0,900,false)
	tiles = {}
	love.graphics.setDefaultFilter("nearest", "nearest")
	for k,v in pairs(include) do
		tiles[v] = love.graphics.newImage("Asserts/Tiles/tile-"..v..".png")
	end
	shapes = {}
	shapes.rect = love.physics.newChainShape(true,0,0,0,32,32,32,32,0)
	shapes.triangleLeftDown = love.physics.newChainShape(true,0,0,0,32,32,32)
	Map.bodies = {}
	blockanalysis(Map,_WORLD,shapes)
	mario = player()
	mario:setup()
	screen  = love.graphics.newCanvas(width, height)
	translateX = 0
	players = {}
end



function love.update(dt) --更新回调函数，每周期调用
	_WORLD:update(dt)
	mario:update(dt)
	for k,v in pairs(Map.specialBlocks) do
		v:update(dt)
		if not v.specialName then
			if mario:getX()+27>(v.x-1)*32 and mario:getX()<(v.x-1)*32+29 and mario:getUpValue()<0 and mario:getY()<(v.y-1)*32+40 and mario:getY()>=(v.y-1)*32+32 and not v.jumpup then
				Map.specialBlocks[k]:resetAnim()
			end
		elseif v.specialName == "M" then
			if mario:getX()+27>(v.x-1)*32 and mario:getX()<(v.x-1)*32+29 and mario:getY()>(v.y-1)*32-40 and mario:getY()<=(v.y-1)*32+32 and not v.jumpup then
				Map.specialBlocks[k]:resetAnim(mario)
			end
		end
	end
	translateX = -mario:getX()+320
	if translateX>=0 then
		translateX = 0
	elseif translateX<=-Map.width*32+640 then
		translateX = -Map.width*32+640
	end
	if server then
		server:update()
		for k,v in pairs(players) do
			server:sendToAllBut(server:getClients()[1],"getData",{k,v.x,v.y,v.isj,v.dir})
		end
	end
	if client then
		client:update()
		client:send("getData",{ID,mario:getX(),mario:getY(),mario.isJumping,mario.dir})
	end
end




function love.draw() --绘图回调函数，每周期调用
	love.graphics.setCanvas(screen)
	love.graphics.clear(0,0,0,0)
	--love.graphics.clear(14,199,255)
	mario:draw()
	--[[if p2x~=0 then
		if p2j==0 then
			love.graphics.draw(mario.images[math.floor(os.clock()*8)%4+1],p2x-p2d*16+16+translateX,p2y,0,2*p2d,2)
		else
			love.graphics.draw(mario.jump,p2x-p2d*16+16+translateX,p2y,0,2*p2d,2)
		end
	end]]
	for k,v in pairs(players) do
		if v.isj then
			love.graphics.draw(mario.jump,v.x-v.dir*16+16+translateX,v.y,0,2*v.dir,2)
		else
			love.graphics.draw(mario.images[math.floor(os.clock()*8)%4+1],v.x-v.dir*16+16+translateX,v.y,0,2*v.dir,2)
		end
	end
	for x=1,Map.width do
		for y=1,Map.height do
			if Map.tiles[x+(y-1)*Map.width]~= 0 and Map.tiles[x+(y-1)*Map.width]~= 286 and Map.tiles[x+(y-1)*Map.width]~=451 and Map.tiles[x+(y-1)*Map.width]~=283 then
				love.graphics.setColor(255, 255, 255, 255)
				love.graphics.draw(tiles[Map.tiles[x+(y-1)*Map.width]],(x-1)*32+translateX,(y-1)*32,0,2)
			end
		end
	end
	for k,v in pairs(Map.specialBlocks) do
		v:draw()
	end
	love.graphics.setCanvas()
	love.graphics.clear(14,199,255)
	love.graphics.setColor(0, 0, 0, 180/9)
	for i=-1,1 do
		for j=-1,1 do
			love.graphics.draw(screen, 0+i+10,0+j+10)
		end
	end
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(screen, 0,0)
    if not hosted then
    	love.graphics.print("Press 'H' to host game.", 0, 0)
    else
    	love.graphics.print("Game Hosted", 0, 0)
    end
    love.graphics.print("IP: "..IPBuffer.." ,Press 'G' to join.",0,10)
end


function love.keypressed(key) --键盘检测回调函数，当键盘事件触发是调用
	mario:keypressed(key,Map)
	if tonumber(key) or key=="." then
		IPBuffer = IPBuffer..key
	end 
	if key == "delete" then
		IPBuffer = ""
	end
	if key=="h" then
		hostgame()
	end
	if key=="g" then
		joingame(IPBuffer)
	end
end



function love.mousepressed(key,x,y) --回调函数释放鼠标按钮时触发。





end

function normalize(x,y)
	local length = math.sqrt(x^2+y^2)
	return x/length,y/length
end 

function hostgame()
	server = sock.newServer()
	server:on("connect",function(data,cl) print("Connected")  end)
	server:on("getData",function(data) players[data[1]] = {x=data[2],y=data[3],isj=data[4],dir=data[5]} end)
end

function joingame(ip)
	if #ip<=3 then
		client = sock.newClient()
	else
		client = sock.newClient(ip)
	end
	client:on("connect",function(data) print("Finish") end)
	client:on("getData",function(data) players[data[1]] = {x=data[2],y=data[3],isj=data[4],dir=data[5]} end)
	client:connect()
end
