CountdownState = Class{__includes = BaseState}

function CountdownState:init(params)
    self.timer = 3
end

function CountdownState:update(dt)
    self.timer = self.timer - dt

    if (self.timer <= 0) then
        gStateMachine:change('play')
    end
end

function CountdownState:render()
    love.graphics.setFont(hugeFont)
    love.graphics.printf(tostring(math.ceil(self.timer)), 0, 120, VIRTUAL_WIDTH, 'center')
end