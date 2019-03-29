Pipe = Class{}

local PIPE_IMAGE = love.graphics.newImage('images/pipe.png')

PIPE_SPEED = 60

PIPE_HEIGHT = PIPE_IMAGE:getHeight()
PIPE_WIDTH = PIPE_IMAGE:getWidth()

function Pipe:init(orientation, y)
  self.x = VIRTUAL_WIDTH
  self.y = y

  self.width = PIPE_IMAGE:getWidth()
  self.height = PIPE_IMAGE:getHeight()

  self.orientation = orientation
end

function Pipe:render()
  -- love.graphics.draw(PIPE_IMAGE, self.x, self.y)
  love.graphics.draw(PIPE_IMAGE, self.x,
    self.orientation == 'top' and self.y + PIPE_HEIGHT or self.y,
    0, 1, self.orientation == 'top' and -1 or 1)
end
