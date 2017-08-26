musicbrick = class("musicbrick")

function musicbrick:init(x,y,type)
	self.specialName = "M"
	self.images = {type,type+1,type+2}
	self.x,self.y = x,y
	self.oppositey = 0
	self:setup()
end

function musicbrick:setup()
	for k,v in pairs(self.images) do
		self.images[k] = love.graphics.newImage("Asserts/Tiles/tile-"..v..".png")
	end
end

function musicbrick:update(dt)
	if self.jumpup then
		self.jumpup:update(dt)
	end
end

function musicbrick:resetAnim(pl)
	self.jumpup = tween.new(0.2,self,{oppositey = self.oppositey-5},tween.easing.outQuad)
	local func = function()
		self.jumpup = tween.new(0.2,self,{oppositey = self.oppositey+5},tween.easing.inQuad)
		self.jumpup:setCallback(function() self.jumpup = nil end)
	end
	self.jumpup:setCallback(func)
	if love.keyboard.isDown("k") then
		pl.body:setLinearVelocity(0,-700)
	else
		pl.body:setLinearVelocity(0,-400)
	end
end

function musicbrick:draw()
	love.graphics.draw(self.images[math.floor(os.clock()*8)%3+1],(self.x-1)*32+translateX,(self.y-1)*32,0,2,2,0,self.oppositey)
end

