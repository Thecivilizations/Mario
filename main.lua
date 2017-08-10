
io.stdout:setvbuf("no") --控制台输出窗口,优先输出如果没有则在程序结束后再输出的

--[[ 
	项目主体部分
	
--]]

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


local Map = {}
local content = love.filesystem.read("Maps/Map.lua")
Map.width,Map.height,Map.background,Map.tiles,Map.hiddenTiles = loadstring(content)()
local include = analysis(Map.background)
include = analysis(Map.tiles,include)
include = analysis(Map.hiddenTiles,include)
print(#include)



function love.load() --资源加载回调函数，仅初始化时调用一次

end



function love.update(dt) --更新回调函数，每周期调用




end




function love.draw() --绘图回调函数，每周期调用



    


end



function love.keypressed(key) --键盘检测回调函数，当键盘事件触发是调用





end



function love.mousepressed(key,x,y) --回调函数释放鼠标按钮时触发。





end
