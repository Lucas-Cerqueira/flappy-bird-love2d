Bird = Class{}

local GRAVITY = 20

function Bird:init()
  self.image = love.graphics.newImage('images/bird.png')
  self.width = self.image:getWidth()
  self.height = self.image:getHeight()

  self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
  self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)

  -- bird velocity
  self.dy = 0
end

function Bird:render()
  love.graphics.draw(self.image, self.x, self.y)
end

function Bird:update(dt)
  self.dy = self.dy + GRAVITY * dt

  if (love.keyboard.wasPressed('space') or love.mouse.wasPressed(1)) then
    self.dy = -5
    sounds['jump']:play()
  end
  self.y = self.y + self.dy
  self:render()
end

function Bird:setVelocity(dy)
  self.dy = dy
end

-- the 2's and 4's are used to shrink the bounding box a little bit
function Bird:collides(pipe)
  if ((self.x + 2) > (pipe.x + pipe.width) or ((self.x + 2) + (self.width - 4)) < pipe.x) then
    return false
  end
  if ((self.y + 2) > (pipe.y + pipe.height) or ((self.y + 2) + (self.height - 4)) < pipe.y) then
    return false
  end
  return true
end
