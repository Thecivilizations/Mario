
io.stdout:setvbuf("no") --控制台输出窗口,优先输出如果没有则在程序结束后再输出的
	
--[[ 
	项目主体部分
	
--]]

class = require "middleclass"
require "unknown"
require "brick"

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

function blockanalysis(m)
	for k,v in pairs(m.tiles) do
		if v == 286 then
			table.insert(m.specialBlocks,unknown(k%m.width,math.ceil(k/m.width)))
		elseif v==451 then
			table.insert(m.specialBlocks,brick(k%m.width,math.ceil(k/m.width),v))
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
	tiles = {}
	love.graphics.setDefaultFilter("nearest", "nearest")
	for k,v in pairs(include) do
		tiles[v] = love.graphics.newImage("Asserts/Tiles/tile-"..v..".png")
	end
	blockanalysis(Map)
end



function love.update(dt) --更新回调函数，每周期调用
	




end




function love.draw() --绘图回调函数，每周期调用
	love.graphics.clear(14,199,255)
	for x=1,Map.width do
		for y=1,Map.height do
			if Map.tiles[x+(y-1)*Map.width]~= 0 then
				love.graphics.setColor(0, 0, 0, 100)
				love.graphics.draw(tiles[Map.tiles[x+(y-1)*Map.width]],(x-1)*32+10,(y-1)*32+10,0,2)
				love.graphics.setColor(255, 255, 255, 255)
				love.graphics.draw(tiles[Map.tiles[x+(y-1)*Map.width]],(x-1)*32,(y-1)*32,0,2)
			end
		end
	end
	for k,v in pairs(Map.specialBlocks) do
		v:draw()
	end


    


end


function love.keypressed(key) --键盘检测回调函数，当键盘事件触发是调用





end



function love.mousepressed(key,x,y) --回调函数释放鼠标按钮时触发。





end
