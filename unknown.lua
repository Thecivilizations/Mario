unknown = class("unknown")

function unknown:init(x,y)
	self.images = {286,287,288,289}
	self.x,self.y = x,y
	self:setup()
	self.oppositey = 0
end

function unknown:setup()
	for k,v in pairs(self.images) do
		self.images[k] = love.graphics.newImage("Asserts/Tiles/tile-"..v..".png")
	end
end

function unknown:update(dt)
	if self.jumpup then
		self.jumpup:update(dt)
	end
end

function unknown:resetAnim()
	self.jumpup = tween.new(0.2,self,{oppositey = self.oppositey+5},tween.easing.outQuad)
	local func = function()
		self.jumpup = tween.new(0.2,self,{oppositey = self.oppositey-5},tween.easing.inQuad)
		self.jumpup:setCallback(function() self.jumpup = nil end)
	end
	self.jumpup:setCallback(func)
end

function unknown:draw()
	love.graphics.draw(self.images[math.floor(os.clock()*8)%4+1],(self.x-1)*32+translateX,(self.y-1)*32,0,2,2,0,self.oppositey)
end
