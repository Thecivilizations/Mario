
io.stdout:setvbuf("no") --控制台输出窗口,优先输出如果没有则在程序结束后再输出的

--[[ 
	项目主体部分
	
--]]
local Map = {}
Map.width,Map.height,Map.background,Map.Tiles,Map.hiddenTiles = require("Maps/Map")
local include = {}




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

function analysis(m)
	local tab = m
	local result = {}
	for k,v in pairs(m) do
		if #result>0 and v~= 0 then
			for i,j in pairs(result) do

			end
		end
	end
end

