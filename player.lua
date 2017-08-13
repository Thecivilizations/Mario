player = class("player")

function player:init(x,y)
	self.images = {}
	self.dir = 1
	self.isJumping = false
end

function player:setup()
	self.body = love.physics.newBody(_WORLD, 100,0,"dynamic")
	self.body:setFixedRotation(true)
	love.physics.newFixture(self.body,love.physics.newPolygonShape(3,0,3,30,27,30,27,0))
	for i=1,3 do
		table.insert(self.images,love.graphics.newImage("Asserts/Mario/little-"..i..".png"))
	end
	table.insert(self.images,self.images[2])
end

function player:draw()
	love.graphics.setColor(0, 0, 0, 100)
	love.graphics.draw(self.images[math.floor(os.clock()*8)%4+1], self.body:getX()-self.dir*16+26,self.body:getY()+10,0,2*self.dir,2)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(self.images[math.floor(os.clock()*8)%4+1], self.body:getX()-self.dir*16+16,self.body:getY(),0,2*self.dir,2)
end

function player:update(dt)
	local x,y = self.body:getLinearVelocity()
	if love.keyboard.isDown("a") then
		self.dir = -1
		if not self.isJumping then
			self.body:setLinearVelocity(-200,0)
		else
			self.body:applyForce(-600,0)
		end
	elseif love.keyboard.isDown("d") then
		self.dir = 1
		if not self.isJumping then
			self.body:setLinearVelocity(200,0)
		else
			self.body:applyForce(600,0)
		end
	end
	if y==0 then
		self.isJumping = false
	else
		self.isJumping = true
	end
end

function player:keypressed(key)
	if key=="k" then
		local x,y = self.body:getLinearVelocity()
		self.body:setLinearVelocity(x,-500)
		self.isJumping = true
	end
end
