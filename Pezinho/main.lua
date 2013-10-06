display.setStatusBar( display.HiddenStatusBar ) 

local physics = require("physics")
physics.start()
physics.setGravity(0, 10)
local sprite = require("sprite")


physics.setDrawMode("hybrid")

-- Variaveis
larguraTela = display.contentWidth;
alturaTela = display.contentHeight;
motionX= 0; -- movimento no eixo x
velocidade = 5; --velocidade do jogador
lifes = 3 --vidas jogador
score = 0 --pontuacao

-- Add ceu
local sky = display.newImage( "imagens/background_sky.png", true )
sky.x = larguraTela/2; sky.y = 290;

-- Add grama
local grass_bottom = display.newImage( "imagens/grass_bottom.png", true )
grass_bottom.x = larguraTela/2; grass_bottom.y = alturaTela-35;
physics.addBody( grass_bottom, "static", { friction=100, bounce=0.3 } )


-- Add Jogador		
local player = display.newImage( "imagens/jogador.png" )
physics.addBody(player , "dynamic", { friction= -500,density= 40, bounce= 0, radius= 45} ) 
player.isFixedRotation=true
player.x = 50
player.y= 340
player.myName= "player"

--add bola
local bola = display.newImage("imagens/bola2.png")
bola.x = display.contentWidth/2
physics.addBody(bola,"dynamic", { friction=200, density= 30, bounce=.9, radius = 13.5  } )
bola.myName= "bola"

--paredes
paredeEsquerda = display.newRect( 0, -200, 1, 800)
paredeDireita = display.newRect(display.contentWidth,-200,10, 800)
teto = display.newRect(0,-250,display.contentWidth,1)

physics.addBody(paredeEsquerda, "static", {bounce = 0.1 })
physics.addBody(paredeDireita, "static", {bounce = 0.1 })
physics.addBody(teto, "static", {bounce = 0.5 })

-- Exibe pontuação

textScore = display.newText("0", 10 , 10, "Helvetica", 20)
textScore:setReferencePoint(display.TopLeftReferencePoint)
textScore:setTextColor(255,255,255)
textScore.x = display.contentWidth - 290
textScore.y = display.screenOriginX + 5

-- Exibe vidas

textLives = display.newText("Vidas: 3", 10, 30, "Helvetica", 15)
textLives:setReferencePoint(display.TopLeftReferencePoint)
textLives:setTextColor(255,255,255)
textLives.x = display.contentWidth - 310
textLives.y = display.screenOriginY + 70

local function updateScore(event)
	textScore.text=tonumber(textScore.text) + 50
end

local function onCollision(event)
	if((event.object1.myName == "bola" and event.object2.myName =="player") or (event.object1.myName == "player" and event.object2.myName =="bola")) then
		score = score + 50
		updateScore()
		print(score)
	end
end
	
-- Add Botao Jump button
local up = display.newImage ("imagens/btn_arrow.png")
	up.x = 280; up.y = 480;
	up.rotation = 270

-- Add botaoEsquerdo
local botaoEsquerdo= display.newImage ("imagens/btn_arrow.png")
	botaoEsquerdo.x = 45; botaoEsquerdo.y = 480;
	botaoEsquerdo.rotation = 180;

-- Add botaoDireito
	local botaoDireito = display.newImage ("imagens/btn_arrow.png")
	botaoDireito.x = 120; botaoDireito.y = 482;

-- Stop 
local function stop (event)
	if event.phase =="ended" then
		motionX = 0;
	end		
end
Runtime:addEventListener("touch", stop )

-- Mover jogador
local function moveplayer (event)
	player.x = player.x + motionX;
end
Runtime:addEventListener("enterFrame", moveplayer)

--pular
function up:touch(event)
	if event.phase == "began"  then
		player:setLinearVelocity( 0, -200 )
	end
	
end

up:addEventListener("touch",up)

-- seta esquerda, move jogador para esquerda
local function moveEsquerda (event)
	motionX = -velocidade;
end
botaoEsquerdo:addEventListener("touch",moveEsquerda)

-- seta direita, move jogador para direita
local function moveDireita (event)
	motionX = velocidade;
end
botaoDireito:addEventListener("touch",moveDireita)

Runtime:addEventListener("collision",onCollision)
