function love.conf(t)
    t.modules.audio = true
	t.modules.graphics = true
	t.modules.image = true
	t.modules.math = true
    t.modules.keyboard = true
    t.modules.joystick = true
    t.modules.mouse = true
    t.modules.sound = true
    t.modules.timer = true
    t.modules.thread = true
    t.console = false
    t.window.title = "ChainReaction"
    t.window.width = 800
    t.window.height = 600
	t.identity = t.window.title
end
