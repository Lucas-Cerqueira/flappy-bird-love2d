PipePair = Class{}

LAST_GAP_VARIATION = 40

function PipePair:init(lastY)
  self.x = VIRTUAL_WIDTH + 32
  self.y = math.max(-PIPE_HEIGHT + 10,
                    math.min(lastY + math.random(-LAST_GAP_VARIATION, LAST_GAP_VARIATION), 
                             VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT)
  )

  self.gapHeight = math.random(80, 100)

  self.pipes = {
    ['upper'] = Pipe('top', self.y),
    ['lower'] = Pipe('bottom', self.y + PIPE_HEIGHT + self.gapHeight)
  }

  -- whether this pipe pair is ready to be removed from the scene
  self.remove = false

  -- whether this pair has been scored
  self.scored = false
end

function PipePair:update(dt)
    -- remove the pipe from the scene if it's beyond the left edge of the screen,
    -- else move it from right to left
    if self.x > -PIPE_WIDTH then
        self.x = self.x - PIPE_SPEED * dt
        self.pipes['lower'].x = self.x
        self.pipes['upper'].x = self.x
    else
        self.remove = true
    end
end

function PipePair:render()
  for k, pipe in pairs(self.pipes) do
    pipe:render()
  end
end
