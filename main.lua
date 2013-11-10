-- Hide Status Bar

display.setStatusBar(display.HiddenStatusBar)

-- Physics

local physics = require('physics')
physics.start()
--physics.setDrawMode('hybrid')

-- Graphics

-- [Title View]

local titleBg2
local playBtn
local creditsBtn
local titleView

-- [Credits]

local creditsView

-- Game Background

local gameBg

-- TextFields

local scoreTF

-- Instructions

local ins

-- Ball

local ball

-- Alert

local alertView

-- Sounds

local ballHit = audio.loadSound('imagens/Footbal_kick.mp3')

-- Variables

local floor

--paredes
paredeEsquerda = display.newRect( 0, -200, 1, 800)
paredeDireita = display.newRect(display.contentWidth,-400,3, 800)
teto = display.newRect(0,-250,display.contentWidth,1)

physics.addBody(paredeEsquerda, "static", {bounce = 0.1 })
physics.addBody(paredeDireita, "static", {bounce = 0.1 })
physics.addBody(teto, "static", {bounce = 0.5 })

-- Functions

local Main = {}
local startButtonListeners = {}
local showCredits = {}
local hideCredits = {}
local showGameView = {}
local gameListeners = {}
local onTap = {}
local onCollision = {}
local alert = {}

-- Main Function

function Main()
	titleBg = display.newImage("imagens/titleBg2.png")
	playBtn = display.newImage("imagens/playBtn.png", 219, 219)
	creditsBtn = display.newImage("imagens/creditsBtn.png", 205, 273)
	titleView = display.newGroup(titleBg, playBtn, creditsBtn)
	
	startButtonListeners('add')
end

function startButtonListeners(action)
	if(action == 'add') then
		playBtn:addEventListener('tap', showGameView)
		creditsBtn:addEventListener('tap', showCredits)
	else
		playBtn:removeEventListener('tap', showGameView)
		creditsBtn:removeEventListener('tap', showCredits)
	end
end

function showCredits:tap(e)
	playBtn.isVisible = false
	creditsBtn.isVisible = false
	creditsView = display.newImage("credits.png", -130, display.contentHeight-50)
	transition.to(creditsView, {time = 300, x = 65, onComplete = function() creditsView:addEventListener('tap', hideCredits) end})
end

function hideCredits:tap(e)
	playBtn.isVisible = true
	creditsBtn.isVisible = true
	transition.to(creditsView, {time = 300, y = display.contentHeight+creditsView.height, onComplete = function() creditsView:removeEventListener('tap', hideCredits) display.remove(creditsView) creditsView = nil end})
end

function showGameView:tap(e)
	transition.to(titleView, {time = 300, x = -titleView.height, onComplete = function() startButtonListeners('rmv') display.remove(titleView) titleView = nil end})
	
	-- Add imagens
	
	-- Background
	
	gameBg = display.newImage("imagens/gameBg.png")
	
	-- Instruçoes
	
	local ins = display.newImage("imagens/ins.png", 44, 214)
	transition.from(ins, {time = 200, alpha = 0.1, onComplete = function() timer.performWithDelay(2000, function() transition.to(ins, {time = 200, alpha = 0.1, onComplete = function() display.remove(ins) ins = nil end}) end) end})
	
	-- TextFields
	
	scoreTF = display.newText('0', 62, 295, 'Helvetica', 16)
	scoreTF:setTextColor(255, 204, 0)
	
	-- Bola
	
	ball = display.newImage("imagens/bola.png", 205, 250)
	ball.name = "ball"
	
	-- Floor
	
	floor = display.newLine(240, 321, 700, 321)
	
	-- Add Physics
	
	-- Ball
	
	physics.addBody(ball, 'dynamic', {friction = .5, bounce = .2, radius = 30})
	
	-- Floor
	
	physics.addBody(floor, 'static', {friction = .5 })
	
	gameListeners('add')
end


function onCollision(e)
	if(tonumber(scoreTF.text) > 1) then
		alert(scoreTF.text)
	end
	scoreTF.text = 0
end

function gameListeners(action)
	if(action == 'add') then
		ball:addEventListener('touch', onTap)
		floor:addEventListener('collision', onCollision)
	else
		ball:removeEventListener('touch', onTap)
		floor:removeEventListener('collision', onCollision)
	end
end

function onTap(e)
	audio.play(ballHit)
	ball:applyForce( 0.5, -15, ball.x, ball.y)
		
	-- Update Score
		
	scoreTF.text = tostring(tonumber(scoreTF.text) + 1)
end



function alert(score)
	gameListeners('rmv')
	alertView = display.newImage("imagens/alert.png", (display.contentWidth * 0.5) - 105, (display.contentHeight * 0.5) - 55)
	transition.from(alertView, {time = 300, xScale = 0.5, yScale = 0.5})
	
	local score = display.newText(scoreTF.text, (display.contentWidth * 0.5) - 8, (display.contentHeight * 0.5), 'Helvetica', 18)
	
	timer.performWithDelay(2000, function() physics.stop() end, 1)
	
	--playBtn = display.newImage("imagens/playBtn.png", 219, 219)
	
	
end

Main()