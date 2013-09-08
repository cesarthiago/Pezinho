display.setStatusBar( display.HiddenStatusBar ) 

local physics = require("physics")
physics.start()
physics.setGravity(0, 10)

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
local player = display.newImage( "imagens/menino.png" )
physics.addBody(player , "dynamic", { friction=-500,density=1000, bounce=-110 } ) 
player.x = 50
player.y= 340

--add bola
local bola = display.newImage("imagens/bola.png")
bola.x = display.contentWidth/2
physics.addBody(bola,"dynamic", { friction=100, density= 10, bounce=.9 } )


--paredes
paredeEsquerda = display.newRect( 0, -200, 1, 800)
paredeDireita = display.newRect(display.contentWidth,-150,10, 800)
teto = display.newRect(0,-250,display.contentWidth,1)

physics.addBody(paredeEsquerda, "static", {bounce = 0.1 })
physics.addBody(paredeDireita, "static", {bounce = 0.1 })
physics.addBody(teto, "static", {bounce = 0.5 })

-- Exibe pontuação

textScore = display.newText("Score: 0", 10 , 10, "Helvetica", 20)
textScore:setReferencePoint(display.TopLeftReferencePoint)
textScore:setTextColor(255,255,255)
textScore.x = display.contentWidth - 310
textScore.y = display.screenOriginX + 5

-- Exibe vidas

textLives = display.newText("Vidas: ", 10, 30, "Helvetica", 15)
textLives:setReferencePoint(display.TopLeftReferencePoint)
textLives:setTextColor(255,255,255)
textLives.x = display.contentWidth - 310
textLives.y = display.screenOriginY + 70

local function updateScore(num)
	score= score + num
	textScore.text = "Score " .. score
	textScore:setReferencePoint(display.TopLeftReferencePoint)
	textScore.x = display.contentWidth - 310
end

-- Add  Botao Jump button
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

