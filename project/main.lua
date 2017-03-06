-- UTIL
require 'util/util'

-- BUMP
bump  = require 'libs/bump'
world = bump.newWorld()

-- FUNCTION
require 'functions'

-- START LOAD -- CARREGAR ARQUIVOS NECESSÁRIOS P/ O JOGO
function love.load()
  
  -- TIMER
  timer   = 0
  paused  = false
  tempo   = 0
  
  -- VAR
  screenWidth     = love.graphics.getWidth()
  screenHeight    = love.graphics.getHeight()

  -- BACKGROUND DO JOGO
  background  = love.graphics.newImage("/assets/images/background.png")
  
  -- ROW
  row         = {}
  row.image   = love.graphics.newImage("/assets/images/row.png")
  row.width   = 12
  row.height  = 75
  row.px      = (screenWidth/2) - (row.width/2)
  row.py      = 172
  row.space   = 21
  row.timeout = 0
  
  -- RAND PX
  px    = {}
  px[1] = (screenWidth/2) - 25 -- 390 CENTER
  px[2] = (screenWidth/2) - 80 -- 335 LEFT
  px[3] = (screenWidth/2) + 25 -- 440 RIGHT
  
  -- DIRECTION
  direction    = {}
  direction[1] = 'left'
  direction[2] = 'right' 
  
  -- CRAZY CAR OPTIONS  
  limitCrazyCar       = {}
  limitCrazyCar.left  = 220
  limitCrazyCar.right = 550
  
  crazyCar            = {}
  crazyCar.idle       = true
  crazyCar.direction  = false
  crazyCar.speed      = 0.2
  crazyCar.sqm        = 8
  crazyCar.timer      = 0.1
  crazyCar.timeout    = 0
  crazyCar.image      = love.graphics.newImage("/assets/images/red_car.png")
  crazyCar.width      = 58
  crazyCar.height     = 112
  crazyCar.px         = (screenWidth/2) - (crazyCar.width/2)
  crazyCar.py         = screenHeight - crazyCar.height
  crazyCar.quad       = love.graphics.newQuad( 0, 0, crazyCar.width, crazyCar.height, crazyCar.image:getDimensions() )
  
  world:add( crazyCar, crazyCar.px, crazyCar.py, crazyCar.width, crazyCar.height )
  
  
  -- POLICE1 CAR OPTIONS
  policeCar1          = deepcopy(crazyCar)
  policeCar1.idle     = false
  policeCar1.sqm      = 60
  policeCar1.image    = love.graphics.newImage("/assets/images/police_car1.png")
  policeCar1.px       = px[love.math.random( 1, 3 )]
  policeCar1.py       = 172
  policeCar1.width    = 50
  policeCar1.height   = 102
  policeCar1.quad     = love.graphics.newQuad( 0, 0, policeCar1.width, policeCar1.height, policeCar1.image:getDimensions() )
  
  world:add( policeCar1, policeCar1.px, policeCar1.py, policeCar1.width, policeCar1.height )
  
  
  policeCar2          = deepcopy(policeCar1)
  policeCar2.idle     = true
  policeCar2.image    = love.graphics.newImage("/assets/images/police_car2.png")
  policeCar2.px       = px[love.math.random( 1, 3 )]
  policeCar2.py       = -102
  
  world:add( policeCar2, policeCar2.px, policeCar2.py, policeCar2.width, policeCar2.height )
  
  -- SOUNDS
  crazyCarSound = love.audio.newSource("/assets/sounds/car.mp3", "static")
  policeSound   = love.audio.newSource("/assets/sounds/police.mp3", "static")
  
end
-- END LOAD

-- START DRAW - DESENHA NA TELA
function love.draw()
    
  -- DESENHA O BACKGROUND NA TELA
  love.graphics.draw(background)
  
  -- DESENHA A LINHA DA PISTA
  for i=1,5 do
      love.graphics.draw(row.image, row.px, row.py + ((row.height + row.space) * (i - 1)))
  end
  
  -- DESENHA O CARRO NA TELA
  love.graphics.draw(crazyCar.image, crazyCar.quad, crazyCar.px, crazyCar.py)
  
  -- DESENHA O POLICE CAR 1 NA TELA
  love.graphics.draw(policeCar1.image, policeCar1.quad, policeCar1.px, policeCar1.py)
  
  -- DESENHA O POLICE CAR 2 NA TELA
  love.graphics.draw(policeCar2.image, policeCar2.quad, policeCar2.px, policeCar2.py)
    
  -- TIMER  
  love.graphics.print("TEMPO: "..tostring(math.floor(timer)), 10, 10)
  
  -- PAUSED
  if paused == true then
    
    -- SOUNDS STOP
    love.audio.stop(crazyCarSound)
    love.audio.stop(policeSound)
    
    love.graphics.print("PAUSADO\nTECLE <ENTER> PARA CONTINUAR", screenWidth/2 - 110, screenHeight/2)
    
  else
    
    -- SOUNDS START
    love.audio.play(crazyCarSound)
    love.audio.play(policeSound)
  
  end
    
  
  
end
-- END DRAW

-- START UPDATE - ATUALIZA O DRAW
function love.update(dt)
  
  if paused ~= true then
    
    timer = timer + 1 * dt
    
    updateRow(dt)
    updateCrazyCar(dt)
    updatePoliceCar(dt)
    
  end -- paused ~= true then
  
end
-- END UPDATE