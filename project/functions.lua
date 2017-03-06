-- EVENT ON PRESS
function love.keypressed(key)
        
    if key == 'left' or key == 'right' then
      
        crazyCar.idle       = false
        crazyCar.direction  = key
          
    else
        
        crazyCar.idle       = true
        crazyCar.direction  = false
        
        if key == 'escape' then
          
          if paused == true then
              love.event.quit()
          end
                    
          paused = true
        
        end -- if key == 'escape' then
      
        if key == 'return' then
            
          paused = false
            
        end -- if key == 'return' then      
        
    end    
    
end -- function love.keypressed(key)

-- EVENT ON LEASS
function love.keyreleased(key)
  
    crazyCar.idle     = true
    crazyCar.timeout  = 0
  
end -- function love.keyreleased(key)

-- UPDATE ROW
updateRow = function(dt)
    
    row.timeout = row.timeout + dt
    row.py      = 172
    
    for r=1,10 do
      
        if row.timeout > (r * 0.06) then
        
            row.py = row.py + r + 3
            
        end
      
    end  
    
    if row.timeout > 0.6 then
        
        row.py      = 172
        row.timeout = 0
        
    end
      
end

-- UPDATE CAR
updateCrazyCar = function(dt)
    
    actualX, actualY, cols, len = world:check( crazyCar, crazyCar.px, crazyCar.py )
    
    if len > 0 then
       
       -- PARA O JOGO
       paused = true
       
       -- SOUNDS STOP
       love.audio.stop(crazyCarSound)
       love.audio.stop(policeSound)
       
       -- CRIA MENSAGEM DE ALERTA
       local title    = "Game Over"
       local message  = 'Sua pontuação foi de: '..tostring(math.floor(timer))..' pontos'
       local buttons  = {"Reiniciar", "Sair do Jogo"}
       local pressedbutton = love.window.showMessageBox(title, message, buttons)
        
       if pressedbutton == 1 then
           reiniciarJogo()
       else
           love.event.quit()
       end
               
    end -- if len > 0 then
    
    if crazyCar.idle ~= true then
        
        crazyCar.timer    = crazyCar.timer + dt
        crazyCar.timeout  = crazyCar.timeout + dt
                        
        if crazyCar.timer > crazyCar.speed then
          
            crazyCar.timer = 0.1
            
            if crazyCar.direction == 'left' then
                
                if crazyCar.px <= limitCrazyCar.left then
                  crazyCar.px = limitCrazyCar.left
                else
                  crazyCar.px = crazyCar.px - crazyCar.sqm
                end
                            
            end -- crazyCar.direction == 'left'
          
            if crazyCar.direction == 'right' then
                
                if crazyCar.px >= limitCrazyCar.right then
                  crazyCar.px = limitCrazyCar.right
                else
                  crazyCar.px = crazyCar.px + crazyCar.sqm
                end
            
            end -- crazyCar.direction == 'right'
            
        end -- crazyCar.timer > crazyCar.speed
       
    end -- crazyCar.idle ~= true 
    
    world:update( crazyCar, crazyCar.px, crazyCar.py, crazyCar.width, crazyCar.height )
    
end -- updateCrazyCar = function(dt)

-- UPDATE CAR
updatePoliceCar = function(dt)
    
  tempo = tempo + 1 * dt
  
  if tempo < 6 then
    crazyCar.sqm = crazyCar.sqm + (tempo * 0.01)
  end
  
  if tempo > 12 then
    tempo         = 0
    crazyCar.sqm  = 8
  end
    
  if policeCar2.idle == true and policeCar1.py > 420 then
      policeCar2.idle = false
      policeCar2.py   = 172
  end
  
  if policeCar1.idle ~= true then
    
    if policeCar1.py > 200 then
      
      if policeCar1.px == 335 then
        policeCar1.direction = direction[2]
      elseif policeCar1.px == 440 then
        policeCar1.direction = direction[1]
      elseif policeCar1.px == 390 then
        policeCar1.direction = direction[love.math.random( 1, 2 )]  
      end      
      
      if policeCar1.direction == 'left' then        
        policeCar1.px = policeCar1.px - (policeCar1.sqm * dt)
      elseif policeCar1.direction == 'right' then
        policeCar1.px = policeCar1.px + (policeCar1.sqm * dt)
      end
      
    end
    
    policeCar1.py = policeCar1.py + (policeCar1.sqm * dt) + (tempo * 0.1)
  end
    
  if policeCar2.idle ~= true then
    
    if policeCar2.py > 200 then
      
      if policeCar2.px == 335 then
        policeCar2.direction = direction[2]
      elseif policeCar2.px == 440 then
        policeCar2.direction = direction[1]
      elseif policeCar2.px == 390 then
        policeCar2.direction = direction[love.math.random( 1, 2 )]  
      end      
      
      if policeCar2.direction == 'left' then        
        policeCar2.px = policeCar2.px - (policeCar2.sqm * dt)
      elseif policeCar2.direction == 'right' then
        policeCar2.px = policeCar2.px + (policeCar2.sqm * dt)
      end
      
    end
    
    policeCar2.py = policeCar2.py + (policeCar2.sqm * dt) + (tempo * 0.1)
  end
    
  if policeCar1.py > screenHeight then
    policeCar1.px = px[love.math.random( 1, 3 )]
    policeCar1.py = 172
  end
  
  if policeCar2.py > screenHeight then
    policeCar2.px  = px[love.math.random( 1, 3 )]
    policeCar2.py = 172
  end
  
  world:update( policeCar1, policeCar1.px, policeCar1.py, policeCar1.width, policeCar1.height )
  world:update( policeCar2, policeCar2.px, policeCar2.py, policeCar2.width, policeCar2.height )
  
end -- updatePoliceCar = function(dt)

reiniciarJogo = function()
  
  crazyCar.idle       = true
  crazyCar.direction  = false
  crazyCar.speed      = 0.2
  crazyCar.sqm        = 8
  crazyCar.timer      = 0.1
  crazyCar.timeout    = 0
  crazyCar.px         = (screenWidth/2) - (crazyCar.width/2)
  crazyCar.py         = screenHeight - crazyCar.height
    
  world:update( crazyCar, crazyCar.px, crazyCar.py, crazyCar.width, crazyCar.height )
  
  
  -- POLICE1 CAR OPTIONS
  policeCar1.idle     = false
  policeCar1.sqm      = 60
  policeCar1.px       = px[love.math.random( 1, 3 )]
  policeCar1.py       = 172
  
  world:update( policeCar1, policeCar1.px, policeCar1.py, policeCar1.width, policeCar1.height )
  
  
  policeCar2.idle     = true
  policeCar2.sqm      = 60
  policeCar2.px       = px[love.math.random( 1, 3 )]
  policeCar2.py       = -102
  
  world:update( policeCar2, policeCar2.px, policeCar2.py, policeCar2.width, policeCar2.height )
  
  timer   = 0
  tempo   = 0
  paused  = false
  
end
  
