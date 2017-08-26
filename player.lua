player = class("player")

function player:init(x,y)
	self.images = {}
	self.dir = 1
	self.isJumping = false
	self.y = 0
	self.xBak=0
	self.yBak=0
	self.nors = {x=0,y=0}
	self.times = 1
end

function player:setup()
	self.body = love.physics.newBody(_WORLD, 100,0,"dynamic")
	self.body:setFixedRotation(true)
	love.physics.newFixture(self.body,love.physics.newPolygonShape(3,0,3,30,27,30,27,0))
	for i=1,3 do
		table.insert(self.images,love.graphics.newImage("Asserts/Mario/little-"..i..".png"))
	end
	self.jump = love.graphics.newImage("Asserts/Mario/little-4.png")
	table.insert(self.images,self.images[2])
end

function player:draw()
	love.graphics.setColor(255, 255, 255, 255)
	local x,y = self.body:getLinearVelocity()
	if not self.isJumping then
		love.graphics.draw(self.images[math.floor(os.clock()*8)%4+1], self.body:getX()-self.dir*16+16+translateX,self.body:getY(),0,2*self.dir,2)
		
	else
		love.graphics.draw(self.jump, self.body:getX()-self.dir*16+16+translateX,self.body:getY(),0,2*self.dir,2)
		
	end
end

function player:update(dt)
	local x,y = self.body:getLinearVelocity()
	if y==0 and self.y==0 then
		self.isJumping = false
	elseif math.floor(y)~=0 and math.ceil(y)~=0 then
		self.isJumping = true
		self.xBak = x
	end
	if love.keyboard.isDown("a") then
		if not self.isJumping then
			if self.xBak>-250 then
				self.xBak = self.xBak-400*dt
			end
			self.body:setLinearVelocity(self.xBak*self.times,y)
			self.dir = -1
		else
			if self.xBak>-250 then
				self.body:applyForce(-500*self.times,0)
			end
			self.xBak = x
		end
	elseif love.keyboard.isDown("d") then
		if not self.isJumping then
			if self.xBak<250 then
				self.xBak = self.xBak+400*dt
			end
			self.body:setLinearVelocity(self.xBak*self.times,y)
			self.dir = 1
		else
			if self.xBak<250 then
				self.body:applyForce(500*self.times,0)
			end
			self.xBak = x
		end
	end
	if love.keyboard.isDown("j") then
		self.times = 1.4
	else
		self.times = 1
	end
	self.y = y
	if self:getY()>510 then
		self.body:setY(0)
	end
end

function player:keypressed(key,m)
	local x,y = self.body:getLinearVelocity()
	if key=="k" and not self.isJumping then
		self.body:setLinearVelocity(x,-500*((self.times-1)*0.5+1))
		self.isJumping = true

	end
end

function player:getX()
	return self.body:getX()
end

function player:getY()
	return self.body:getY()
end

function player:getUpValue()
	local x,y = self.body:getLinearVelocity()
	return y
end
