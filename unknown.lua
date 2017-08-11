unknown = class("unknown")

function unknown:init(x,y)
	self.images = {286,287,288,289}
	self.x,self.y = x,y
	self:setup()
end

function unknown:setup()
	for k,v in pairs(self.images) do
		self.images[k] = love.graphics.newImage("Asserts/Tiles/tile-"..v..".png")
	end
end

function unknown:draw()
	love.graphics.draw(self.images[math.floor(os.clock()*8)%4+1],(self.x-1)*30,(self.y-1)*30,0,2)
end
