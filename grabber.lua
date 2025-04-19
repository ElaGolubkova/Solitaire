
require "vector"

GrabberClass = {}

function GrabberClass:new()
  local grabber = {}
  local metadata = {__index = GrabberClass}
  setmetatable(grabber, metadata)
  
  grabber.previousMousePos = nil
  grabber.currentMousePos = nil
  
  grabber.grabPos = nil
  
  -- NEW: we'll want to keep track of the object (ie. card) we're holding
  grabber.heldObject = nil
  
  return grabber
end

function GrabberClass:update()
  self.currentMousePos = Vector(
    love.mouse.getX(),
    love.mouse.getY()
  )
  
  -- Click (just the first frame)
  if love.mouse.isDown(1) and self.grabPos == nil then
    self:grab()
  end
  -- Release
  if not love.mouse.isDown(1) and self.grabPos ~= nil then
    self:release()
  end 
  -- Making the card follow the mouse after it's grabbed
  if self.heldObject then
    self.heldObject.position = self.currentMousePos - Vector(25, 35)  -- centering card on cursor
  end
end

function GrabberClass:grab()
  self.grabPos = self.currentMousePos
  print("GRAB - " .. tostring(self.grabPos))
  
  -- Checking the position of the mouse and the card
  for _, card in ipairs(cardTable) do
    local mouse = self.currentMousePos
    local pos = card.position
    local size = card.size

    for i = #cardTable, 1, -1 do
      local card = cardTable[i]
        if card:isMouseOver(self.currentMousePos) then
          self.heldObject = card
          card.state = CARD_STATE.GRABBED
          break
        end
    end
  end
end

function GrabberClass:release()
  print("RELEASE - ")
  if self.heldObject == nil then -- we have nothing to release
    return
  end
  
  -- Implementing stacking cards logic here
  local isValidReleasePosition = false
  
  for _, card in ipairs(cardTable) do
  if card ~= self.heldObject and card:isMouseOver(self.currentMousePos) then
    isValidReleasePosition = true
    self.heldObject.position = Vector(card.position.x, card.position.y + 20)
    break
  end
end

  if not isValidReleasePosition then
    self.heldObject.position = self.heldObject.originalPosition
  end
  
  for i, card in ipairs(cardTable) do
    if card == self.heldObject then
      table.remove(cardTable, i)
      table.insert(cardTable, self.heldObject)
      break
    end
  end
  
  self.heldObject.state = 0 -- it's no longer grabbed
  
  self.heldObject = nil
  self.grabPos = nil
end