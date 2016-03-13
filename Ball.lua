Ball = {}
Ball.__index = Ball

function Ball:new(x, y, universe)
	local self = {
		x = x or 0,
		y = y or 0,
		vx = 0,
		vy = 0,
		color = 'blue',
		cooldown = 0,
		universe = universe,
	}
	
	setmetatable(self, Ball)
	return self
end

function Ball:draw()
	love.graphics.setColor(COLOR[self.color])
	love.graphics.circle("fill", self.x*SCREEN_SIZE + SCREEN_X, self.y*SCREEN_SIZE + SCREEN_Y, BALL_RADIUS*SCREEN_SIZE)
end

function Ball:explode(x, y, color, applyForce, changeColor)
	local dx = self.x - x
	local dy = self.y - y
	local dist = (dx^2 + dy^2)^0.5
	if dist>0 then
		--apply force
		if applyForce then
			if color=='red' or color=='green'or color=='purple' then
				local force = EXPLOSION_FORCE/dist^2
				self.vx = self.vx + force*dx
				self.vy = self.vy + force*dy
			elseif color=='yellow' then
				--yellow
				local force = EXPLOSION_FORCE/dist^2
				self.vx = self.vx - force*dx
				self.vy = self.vy - force*dy
			elseif color=='white' then
				--white
				self.vx = self.vx + 100*dy/dist^2 - 5*dx/10
				self.vy = self.vy - 100*dx/dist^2 - 5*dy/10
			end
		end
		
		--change color
		if changeColor and dist<EXPLOSION_RADIUS+BALL_RADIUS then
			if self.cooldown==0 then
				self:resetCooldown()
				
				local white = 0
				if math.random(2000)==1 then
					self.color = 'white'
					self.cooldown = 5*self.cooldown
					white = 1
				elseif math.random(500)==1 then
					self.color = 'yellow'
				elseif math.random(200)==1 then
					self.color = 'purple'
				elseif math.random(100)==1 then
					self.color = 'green'
				elseif math.random(30)==1 then
					self.color = 'red'
				else
					self.color = color
				end
				
				return 1, white
			end
		end
	end
	
	return 0, 0
end

function Ball:countDown(dt)
	local white = 0
	
	if PC and love.keyboard.isDown('r') then
		if self.color=='white' then
			white = 1
		end
		self.color = 'blue'
		self.cooldown = 0
		return false, white
	end
	
	if self.cooldown>0 then
		self.cooldown = self.cooldown - dt
		if self.cooldown<=0 then
			--explode
			self.universe:explode(self.x, self.y, self.color)
			self.cooldown = 0
			local color = self.color
			self.color = 'blue'
			
			--extra effects
			if color=='green' then
				--green extra explosion
				self.universe:explode(math.random(SPACE_X), math.random(SPACE_Y), random('red', 'green'))
			elseif color=='purple' then
				--purple self activation
				self.color = random('red', 'green', 'purple')
				self:resetCooldown()
			elseif color=='white' then
				--white disappearence
				white = 1
			end
		end
		
		--white random explosion
		if self.color=='white' and math.random()<=dt*WHITE_PER_SECOND then
			self.universe:explode(self.x, self.y, self.color)
		end
		
		return true, white
	else
		return false, white
	end
end

function Ball:resetCooldown()
	self.cooldown = EXPLOSION_TIME * (math.random()*0.2 + 0.9)
end

function Ball:move(dt)
	--apply resistence
	local inertia = INERTIA^dt
	self.vx = self.vx*inertia
	self.vy = self.vy*inertia
	
	--wall bounce
	if (self.x<=0 and self.vx<0) or (self.x>SPACE_X and self.vx>0) then
		self.vx = -self.vx
	end
	if (self.y<=0 and self.vy<0) or (self.y>SPACE_Y and self.vy>0) then
		self.vy = -self.vy
	end
	
	--move
	self.x = self.x + self.vx*dt
	self.y = self.y + self.vy*dt
end

function Ball:drag(x, y, vx, vy)
	local dx = self.x - x
	local dy = self.y - y
	local dist = (dx^2 + dy^2)^0.5
	local v = (vx^2+vy^2)^0.5
	if dist<CLICK_RADIUS+BALL_RADIUS then
		local force = CLICK_FORCE
		self.vx = self.vx + vx*force
		self.vy = self.vy + vy*force
	end
end
























