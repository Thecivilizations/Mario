player = class("player")

function player:init(x,y)
	self.images = {}
	self.dir = 1
	self.isJumping = false
	self.y = 0
	self.xBak=0
	self.yBak=0
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
	love.graphics.setColor(0, 0, 0, 100)
	if not self.isJumping then
		love.graphics.draw(self.images[math.floor(os.clock()*8)%4+1], self.body:getX()-self.dir*16+26,self.body:getY()+10,0,2*self.dir,2)
	else
		love.graphics.draw(self.jump, self.body:getX()-self.dir*16+26,self.body:getY()+10,0,2*self.dir,2)
	end
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.print(self.xBak.." "..math.floor(self.yBak), 0,0)
	if not self.isJumping then
		love.graphics.draw(self.images[math.floor(os.clock()*8)%4+1], self.body:getX()-self.dir*16+16,self.body:getY(),0,2*self.dir,2)
	else
		love.graphics.draw(self.jump, self.body:getX()-self.dir*16+16,self.body:getY(),0,2*self.dir,2)
	end
end

function player:update(dt)
	self.xBak,self.yBak = self.body:getLinearVelocity()
	if self.yBak==0 and self.y==0 then
		self.isJumping = false
	elseif math.floor(self.yBak)~=0 and math.ceil(self.yBak)~=0 then
		self.isJumping = true
	end
	if love.keyboard.isDown("a") then
		if not self.isJumping then
			if self.xBak>-250 then
				self.body:setLinearVelocity(self.xBak-2,self.yBak)
			end
			self.dir = -1
		else
			if self.xBak>-250 then
				self.body:applyForce(-500,0)
			end
		end
	elseif love.keyboard.isDown("d") then
		if not self.isJumping then
			if self.xBak<250 then
				self.body:setLinearVelocity(self.xBak+2,self.yBak)
			end
			self.dir = 1
		else
			if self.xBak<250 then
				self.body:applyForce(500,0)
			end
		end
	end
	self.y = self.yBak
end

function player:keypressed(key,m)
	if key=="k" and not self.isJumping then
		self.body:setLinearVelocity(self.xBak,-500)
		self.isJumping = true

	end
end
