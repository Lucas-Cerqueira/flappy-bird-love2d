push = require 'lib/push'
Class = require 'lib/class'

-- classes
require 'classes/Bird'
require 'classes/Pipe'
require 'classes/PipePair'
require 'classes/StateMachine'

-- all code related to game states
require 'states/BaseState'
require 'states/PlayState'
require 'states/ScoreState'
require 'states/TitleScreenState'
require 'states/CountdownState'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

local background = love.graphics.newImage('images/background.png')
local backgroundScroll = 0

local ground = love.graphics.newImage('images/ground.png')
local groundScroll = 0
GROUND_HEIGHT = ground:getHeight()

-- Ground faster than backgroud for parallax effect
local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

-- Width value where the background image repeats itself
local BACKGROUND_LOOPING_POINT = 413

-- Bird object
local bird = Bird()

-- PipePairs table
local pipePairs = {}

local spawnTimer = 0
local pipeInterval = 2

-- last gap Y position
local lastGapY = -PIPE_HEIGHT + math.random(80) + 20

-- variable to pause the game
local scrolling = true

function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')

  love.window.setTitle('Flappy Bird')

  -- initialize the fonts
  smallFont = love.graphics.newFont('fonts/font.ttf', 8)
  mediumFont = love.graphics.newFont('fonts/flappy.ttf', 14)
  flappyFont = love.graphics.newFont('fonts/flappy.ttf', 28)
  hugeFont = love.graphics.newFont('fonts/flappy.ttf', 56)
  love.graphics.setFont(flappyFont)

  -- set the random seed based on the current time
  math.randomseed(os.time())

  -- setup the screen dimensions and settings
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    vsync = true,
    fullscreen = false,
    resizable = true
  })

  -- initialize state machine with all state-returning functions
  gStateMachine = StateMachine {
    ['title'] = function() return TitleScreenState() end,
    ['play'] = function() return PlayState() end,
    ['score'] = function() return ScoreState() end,
    ['countdown'] = function() return CountdownState() end,
  }

  -- set the state to the title screen state
  gStateMachine:change('title')

  -- initialize table of sounds
  sounds = {
    ['jump'] = love.audio.newSource('sounds/jump.wav', 'static'),
    ['explosion'] = love.audio.newSource('sounds/explosion.wav', 'static'),
    ['hurt'] = love.audio.newSource('sounds/hurt.wav', 'static'),
    ['score'] = love.audio.newSource('sounds/score.wav', 'static'),

    -- https://freesound.org/people/xsgianni/sounds/388079/
    ['music'] = love.audio.newSource('sounds/marios_way.mp3', 'static')
  }

  -- set the music to play and loop
  sounds['music']:setLooping(true)
  sounds['music']:setVolume(0.2)
  sounds['music']:play()

  -- initialize the table of keys and mouse buttons pressed
  love.keyboard.keysPressed = {}
  love.mouse.buttonsPressed = {}
end

function love.resize(w, h)
  push:resize(w, h)
end

function love.keypressed(key)
  love.keyboard.keysPressed[key] = true

  if (key == 'escape') then
    love.event.quit()

  elseif (key == 'p') then
    scrolling = not scrolling
  end
end

-- Store keys pressed
function love.keypressed(key)
  love.keyboard.keysPressed[key] = true

  if (key == 'escape') then
    love.event.quit()

  elseif (key == 'p' and gStateMachine.currentState == 'play') then
    scrolling = not scrolling
  end
end

-- Store mouse buttons pressed
function love.mousepressed(x, y, button)
  love.mouse.buttonsPressed[button] = true
end

-- Functions to check if a key or mouse button was pressed
function love.keyboard.wasPressed(key)
  return love.keyboard.keysPressed[key]
end

function love.mouse.wasPressed(button)
  return love.mouse.buttonsPressed[button]
end

function love.draw()
  push:start()

  love.graphics.draw(background, -backgroundScroll, 0)

  -- Draw the current state
  gStateMachine:render()

  love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - ground:getHeight())

  push:finish()
end

function love.update(dt)
  if (scrolling == false) then
    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}
    return
  end

  -- The background image repeats itself after BACKGROUND_LOOPING_POINT pixels
  backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt)
    % BACKGROUND_LOOPING_POINT

  -- The ground image is consistent across its whole width, so the screen width
  -- can be used
  groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt)
    % VIRTUAL_WIDTH

  -- now, we just update the state machine, which defers to the right state
  gStateMachine:update(dt)

  -- Flush the tables
  love.keyboard.keysPressed = {}
  love.mouse.buttonsPressed = {}
end
