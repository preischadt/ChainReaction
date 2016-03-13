Universe = {}
Universe.__index = Universe

function Universe:new()
	local self = {
		ball = {},
		combo = 0,
		record = 0,
		white = 0,
		explosion = {
			amount = 0,
		},
		click = {},
		--music = love.audio.newSource('music.mid'),
		sound = {}
	}
	
	--play music TODO
	--love.audio.play(self.music)
	
	--load sounds
	for color in pairs(COLOR) do
		local path = color .. '.wav'
		local file = io.open(path, 'r')
		if file then
			self.sound[color] = love.audio.newSource(path)
			self.sound[color]:setVolume(0.5)
			file:close()
		end
	end
	
	--create balls
	for i=1,BALLS do
		self.ball[i] = Ball:new(math.random(SPACE_X), math.random(SPACE_Y), self)
	end
	
	setmetatable(self, Universe)
	return self
end

function Universe:update(dt)
	--reset explosions
	self.explosion.amount = 0
	
	--click explosion
	self:control(dt)
	
	--count down
	local combing = false
	for i,ball in ipairs(self.ball) do
		local c, w = ball:countDown(dt)
		combing = combing or c
		self.white = self.white - w
	end
	if not combing then
		self.combo = 0
	end
	
	--set record
	if self.combo>self.record then
		self.record = self.combo
	end
	
	--move
	for i,ball in ipairs(self.ball) do
		ball:move(dt)
	end
end

function Universe:draw()
	--draw balls
	for i,ball in ipairs(self.ball) do
		ball:draw()
	end
	
	--draw explosions
	for i=1,self.explosion.amount do
		local explosion = self.explosion[i]
		love.graphics.setColor(COLOR[explosion.color])
		love.graphics.circle("fill", explosion.x*SCREEN_SIZE + SCREEN_X, explosion.y*SCREEN_SIZE + SCREEN_Y, EXPLOSION_RADIUS*SCREEN_SIZE)
	end
	
	--print combo and record
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.printf('Combo: ' .. self.combo .. '\nRecord: ' .. self.record, 0, SPACE_Y*SCREEN_SIZE*0.45 + SCREEN_Y, SPACE_X*SCREEN_SIZE + SCREEN_X*2, 'center')
end

function Universe:control(dt)
	if love.mouse.isDown('l') then
		--get mouse position
		local x, y = love.mouse.getPosition()
		x = (x-SCREEN_X)/SCREEN_SIZE
		y = (y-SCREEN_Y)/SCREEN_SIZE
		self.click.oldX = self.click.x or x
		self.click.oldY = self.click.y or y
		self.click.x = x
		self.click.y = y
		self.click.vx = (self.click.x-self.click.oldX)/dt
		self.click.vy = (self.click.y-self.click.oldY)/dt
		
		--create red explosion
		if not self.click.flag then
			self.click.flag = true
			if self.combo==0 then
				self:explode(x, y, 'red')
			end
		end
		
		--mouse influence
		local dx = self.click.x - self.click.oldX
		local dy = self.click.y - self.click.oldY
		local dist = (dx^2 + dy^2)^0.5
		for i,ball in ipairs(self.ball) do
			ball:drag(self.click.x, self.click.y, self.click.vx, self.click.vy)
		end
	else
		self.click.flag = nil
		self.click.x = nil
		self.click.y = nil
	end
end

function Universe:explode(x, y, color)
	self.combo = self.combo + 1
	
	--play sound
	if self.sound[color] then
		love.audio.stop(self.sound[color])
		love.audio.play(self.sound[color])
	end
	
	--put in queue to draw
	self.explosion.amount = self.explosion.amount + 1
	self.explosion[self.explosion.amount] = self.explosion[self.explosion.amount] or {}
	local explosion = self.explosion[self.explosion.amount]
	explosion.x = x
	explosion.y = y
	explosion.color = color
	
	--explode balls
	local activations = 0
	for i,ball in ipairs(self.ball) do
		local applyForce = self.white==0 or color=='white'
		local changeColor = activations<EXPLOSION_ACTION and color~='white'
		local a, w = ball:explode(x, y, color, applyForce, changeColor)
		activations = activations + a
		self.white = self.white + w
	end
end























