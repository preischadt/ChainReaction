require 'utils'
require 'Universe'
require 'Ball'

--[[TODO
Problems (may need Java):
	No ads for LOVE
	Sounds not working
	App name unchangeable
Create new sounds and music
]]

PC = true
SPACE_X = 400
SPACE_Y = 300
BALLS = 30
BALL_RADIUS = 4.5
EXPLOSION_RADIUS = 30
EXPLOSION_TIME = 2
EXPLOSION_FORCE = 2000
EXPLOSION_ACTION = 5
INERTIA = 0.6
WHITE_PER_SECOND = 15
CLICK_RADIUS = 30
CLICK_FORCE = 0.1
COLOR = {
	['blue'] = {0, 255, 255, 255}, --blue
	['red'] = {255, 0, 0, 255}, --red
	['green'] = {0, 255, 0, 255}, --green
	['purple'] = {255, 0, 255, 255}, --purple
	['yellow'] = {255, 255, 0, 255}, --yellow
	['white'] = {255, 255, 255, 255}, --white
}

local universe
function love.load()
	math.randomseed(os.time())
	love.graphics.setBackgroundColor(0, 0, 0)
	
	local _,_,flags = love.window.getMode()
    local width, height = love.window.getDesktopDimensions(flags.display)
    
    if PC then
		width = 800
		height = 600
    end
    
    if width<height then
		SPACE_X, SPACE_Y = SPACE_Y, SPACE_X
	end
	SCREEN_SIZE = math.min(width/SPACE_X, height/SPACE_Y)
	SCREEN_X = (width-SPACE_X*SCREEN_SIZE)/2
	SCREEN_Y = (height-SPACE_Y*SCREEN_SIZE)/2
	love.window.setMode(width, height)
	
	love.graphics.setFont(love.graphics.newFont(10*SCREEN_SIZE))
	
	universe = Universe:new()
end

function love.update(dt)
	if dt>1 or (PC and love.keyboard.isDown(' ')) then
		return
	end
	
	if PC then
		if love.mouse.isDown('r') and universe.ball[1].color~='white' then
			universe.ball[1].color = 'white'
			universe.ball[1]:resetCooldown()
			universe.ball[1].cooldown = 5*universe.ball[1].cooldown
			universe.white = universe.white + 1
		end
		if love.mouse.isDown('m') and universe.ball[2].color~='white' then
			universe.ball[2].color = 'white'
			universe.ball[2]:resetCooldown()
			universe.ball[2].cooldown = 5*universe.ball[2].cooldown
			universe.white = universe.white + 1
		end
	end
	
	universe:update(dt)
	if PC and love.keyboard.isDown('escape') then
		love.event.quit()
	end
end

function love.draw()
	universe:draw()
end





















