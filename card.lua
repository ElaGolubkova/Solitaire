
require "vector"

CardClass = {}

CARD_STATE = {
  IDLE = 0,
  MOUSE_OVER = 1,
  GRABBED = 2
}

local cardImageNames = {
  "2_of_hearts", "3_of_hearts", "4_of_hearts", "5_of_hearts", "6_of_hearts", "7_of_hearts",
  "8_of_hearts", "9_of_hearts", "10_of_hearts", "jack_of_hearts", "queen_of_hearts", "king_of_hearts", "ace_of_hearts",
  "2_of_spades", "3_of_spades", "4_of_spades", "5_of_spades", "6_of_spades", "7_of_spades",
  "8_of_spades", "9_of_spades", "10_of_spades", "jack_of_spades", "queen_of_spades", "king_of_spades", "ace_of_spades",
  "2_of_diamonds", "3_of_diamonds", "4_of_diamonds", "5_of_diamonds", "6_of_diamonds", "7_of_diamonds",
  "8_of_diamonds", "9_of_diamonds", "10_of_diamonds", "jack_of_diamonds", "queen_of_diamonds", "king_of_diamonds", "ace_of_diamonds",
  "2_of_clubs", "3_of_clubs", "4_of_clubs", "5_of_clubs", "6_of_clubs", "7_of_clubs",
  "8_of_clubs", "9_of_clubs", "10_of_clubs", "jack_of_clubs", "queen_of_clubs", "king_of_clubs", "ace_of_clubs"
}



function CardClass:new(xPos, yPos)
  local card = {}
  local metadata = {__index = CardClass}
  setmetatable(card, metadata)
  
  card.position = Vector(xPos, yPos)
  card.size = Vector(50, 70)
  card.state = CARD_STATE.IDLE
  
  card.originalPosition = Vector(xPos, yPos)
  
  local name = cardImageNames[math.random(#cardImageNames)]
  card.image = love.graphics.newImage("cards/" .. name .. ".png")
  
  return card
end

function CardClass:update()
  
end

function CardClass:draw()
  if self.state ~= CARD_STATE.IDLE then
    --love.graphics.setColor(0, 0, 0, 0.8) -- color values [0, 1]
    local offset = 4 * (self.state == CARD_STATE.GRABBED and 2 or 1)
    --love.graphics.rectangle("fill", self.position.x + offset, self.position.y + offset, self.size.x, self.size.y, 6, 6)
  end
  
  love.graphics.setColor(1, 1, 1, 1)
  
  -- cards were too big in resolution so had to be scaled down this way 
  local imgWidth = self.image:getWidth()
  local imgHeight = self.image:getHeight()
  local scaleX = self.size.x / imgWidth
  local scaleY = self.size.y / imgHeight
  
  --love.graphics.rectangle("fill", self.position.x, self.position.y, self.size.x, self.size.y, 6, 6)
  love.graphics.draw(self.image, self.position.x, self.position.y, 0, scaleX, scaleY)

  
  love.graphics.print(tostring(self.state), self.position.x + 20, self.position.y - 20)
end

function CardClass:checkForMouseOver(grabber)
  if self.state == CARD_STATE.GRABBED then
    return
  end
    
  local mousePos = grabber.currentMousePos
  local isMouseOver = 
    mousePos.x > self.position.x and
    mousePos.x < self.position.x + self.size.x and
    mousePos.y > self.position.y and
    mousePos.y < self.position.y + self.size.y
  
  self.state = isMouseOver and CARD_STATE.MOUSE_OVER or CARD_STATE.IDLE
end

function CardClass:isMouseOver(mouse)
  return mouse.x > self.position.x and mouse.x < self.position.x + self.size.x and
         mouse.y > self.position.y and mouse.y < self.position.y + self.size.y
end