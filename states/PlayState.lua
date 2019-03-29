--[[
    PlayState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The PlayState class is the bulk of the game, where the player actually controls the bird and
    avoids pipes. When the player collides with a pipe, we should go to the GameOver state, where
    we then go back to the main menu.
]]

PlayState = Class{__includes = BaseState}

PIPE_SPEED = 60
PIPE_WIDTH = 70
PIPE_HEIGHT = 288

BIRD_WIDTH = 38
BIRD_HEIGHT = 24

PIPE_MIN_INTERVAL = 2
PIPE_MAX_INTERVAL = 4

function PlayState:init()
    self.bird = Bird()
    self.pipePairs = {}
    self.timer = 0
    self.nextPipeInterval = 0

    -- track the score
    self.score = 0

    -- initialize our last recorded Y value for a gap placement to base other gaps off of
    self.lastGapY = -PIPE_HEIGHT + math.random(80) + 20
end

function PlayState:update(dt)
    -- Update the bird object
    self.bird:update(dt)

    -- Increment pipe spawn timer by deltaTime
    self.timer = self.timer + dt

    -- Check if a pipe should be spawned
    if (self.timer > self.nextPipeInterval) then
        local newPair = PipePair(self.lastGapY)
        table.insert(self.pipePairs, newPair)
        self.lastGapY = newPair.y
        self.timer = 0
        self.nextPipeInterval = math.random(PIPE_MIN_INTERVAL, PIPE_MAX_INTERVAL)
    end

    -- Update the pipe pairs positions and check if the bird collides with one of them
    for k, pair in pairs(self.pipePairs) do
        pair:update(dt)

        -- score a point
        if ((not pair.scored) and (self.bird.x > pair.x + PIPE_WIDTH)) then
            self.score = self.score + 1
            pair.scored = true
            sounds['score']:play()
        end

        for l, pipe in pairs(pair.pipes) do
            if (self.bird:collides(pipe)) then
                sounds['explosion']:play()
                sounds['hurt']:play()
                gStateMachine:change('score', {score = self.score})
            end
        end
    end

    -- Check for collision with the ground
    if ((self.bird.y + 2) + (self.bird.height - 4)) >= (VIRTUAL_HEIGHT - GROUND_HEIGHT) then
        sounds['explosion']:play()
        sounds['hurt']:play()
        gStateMachine:change('score', {score = self.score})
    end

    -- Remove the flagged pairs
    for k, pair in pairs(self.pipePairs) do
        if pair.remove then
            table.remove(self.pipePairs, k)
        end             
    end                                                                
end

function PlayState:render()
    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end

    love.graphics.setFont(flappyFont)
    love.graphics.print('Score: ' .. tostring(self.score), 8, 8)

    self.bird:render()
end