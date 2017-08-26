brick = class("brick")

function brick:init(x,y,type)
	self.images = {type,type+1,type+2,type+3}
	self.x,self.y = x,y
	self.oppositey = 0
	self:setup()
end

function brick:setup()
	for k,v in pairs(self.images) do
		self.images[k] = love.graphics.newImage("Asserts/Tiles/tile-"..v..".png")
	end
	for i=1,4 do
		table.insert(self.images,self.images[1])
	end
end

function brick:update(dt)
	if self.jumpup then
		self.jumpup:update(dt)
	end
end

function brick:resetAnim()
	self.jumpup = tween.new(0.2,self,{oppositey = self.oppositey+5},tween.easing.outQuad)
	local func = function()
		self.jumpup = tween.new(0.2,self,{oppositey = self.oppositey-5},tween.easing.inQuad)
		self.jumpup:setCallback(function() self.jumpup = nil end)
	end
	self.jumpup:setCallback(func)
end

function brick:draw()
	love.graphics.draw(self.images[math.floor(os.clock()*8)%8+1],(self.x-1)*32+translateX,(self.y-1)*32,0,2,2,0,self.oppositey)
end

