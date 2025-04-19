-- Ela Golubkova
-- CMPM 121 - Solitaire project
-- 4-14-25
io.stdout:setvbuf("no")

require "card"
require "grabber"

function love.load()
  math.randomseed(os.time())
  love.window.setMode(960, 640)
  love.graphics.setBackgroundColor(0, 0.7, 0.2, 1)
  
  grabber = GrabberClass:new()
  cardTable = {}
  
  local startX = 100
  local spacingX = 70
  local spacingY = 30

  for col = 1, 7 do
    
    local x = startX + (col - 1) * spacingX
    local y = 100 
    local card = CardClass:new(x, y)
    
    table.insert(cardTable, card)
  
  end
end
function love.update()
  grabber:update()
  
  checkForMouseMoving()  
  
  for _, card in ipairs(cardTable) do
    card:update()
  end
end
function love.draw()
  for _, card in ipairs(cardTable) do
      card:draw()
  end
  
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.print("Mouse: " .. tostring(grabber.currentMousePos.x) .. ", " .. tostring(grabber.currentMousePos.y), 10, 10)
end

function checkForMouseMoving()
  if grabber.currentMousePos == nil then
    return
  end
  
  for _, card in ipairs(cardTable) do
    card:checkForMouseOver(grabber)
  end
end