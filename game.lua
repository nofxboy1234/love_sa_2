HC = require("Libraries.hardoncollider")
local sti = require("Simple-Tiled-Implementation.sti")

local player_timeslice = 1/540 -- 540 FPS for player movement
local player_blocked = false
local facing_right = true
local gravity = 10

function on_collision(dt, shape_a, shape_b)
  -- determine which shape is the player (hc_hitbox) and which is not
  local other
  if shape_a == hc_hitbox then
    other = shape_b
    -- print("shape_a = hc_hitbox, shape_b = other")
    print("collided")
  elseif shape_b == hc_hitbox then
    other = shape_a
    -- print("shape_b = hc_hitbox, shape_a = other")
    print("collided")
  else -- neither shape is the player (hc_hitbox). exit
    return
  end

  if other == hc_ground_hitbox then
    player.velocity.y = 0
  elseif other == hc_crate_hitbox then

  end
end

function collision_stop(dt, shape_a, shape_b)
  print("stopped colliding")
end

function game_load()
  bg_img = love.graphics.newImage("Resources/Images/SA_bg.png")

  music = love.audio.newSource("Resources/Sounds/TownTheme.mp3", "stream")
  music:setLooping(true)
  music:setVolume(0.2)
  music:play()

  -- char_img = love.graphics.newImage("")

  -- initialize hc library
  -- collider = hc(100, on_collision, collision_stop)
  -- add a rectanglto the hc scene
  -- rect = collider:addRectangle(200, 400, 400, 20)

  sti_load()

  -- Collider = HC(100, on_collision, collision_stop)

  player = {}
  player.image = love.graphics.newImage("Resources/Images/Sprite_shapeyV01/Untitled-3_frame_0.png")
  player.x = 1280 / 2 - 80
  player.y = 600
  player.scale = 0.75
  player.width = player.image:getWidth() * player.scale
  player.height = player.image:getHeight() * player.scale
  player.velocity = {}
  player.velocity.x = 400
  player.velocity.y = 400

  hitbox = {}
  hitbox.width = player.width - 15
  hitbox.height = player.height - 14
  hitbox.x = player.x + (player.width * 0.5) - (hitbox.width * 0.5)
  hitbox.y = player.y + (player.height * 0.5) - (hitbox.height * 0.5)
  player.hitbox = hitbox

  -- hc_hitbox = Collider:addRectangle(hitbox.x, hitbox.y, hitbox.width,
  --   hitbox.height)

  ground_hitbox = {}
  ground_hitbox.width = 1280
  ground_hitbox.height = 50
  ground_hitbox.x = 0
  ground_hitbox.y = 673
  ground_hitbox.colour = {255, 0, 0, 255}

  -- hc_ground_hitbox = Collider:addRectangle(ground_hitbox.x, ground_hitbox.y,
  --   ground_hitbox.width, ground_hitbox.height)

  crate_hitbox = {}
  crate_hitbox.width = 30
  crate_hitbox.height = 30
  crate_hitbox.x = 1280 / 2 - 30
  crate_hitbox.y = 642
  crate_hitbox.colour = {255, 0, 0, 255}

  -- hc_crate_hitbox = Collider:addRectangle(crate_hitbox.x, crate_hitbox.y,
  --   crate_hitbox.width, crate_hitbox.height)
end

function hc_hitbox_update(dt)
  if love.keyboard.isDown("right") then
    if not facing_right then
      facing_right = true
    end
    player.x = player.x + (player.velocity.x * dt)
  end
  if love.keyboard.isDown("left") then
    if facing_right then
      facing_right = false
    end
    player.x = player.x - (player.velocity.x * dt)
  end

  if love.keyboard.isDown("down") then
    player.y = player.y + (player.velocity.y * dt)
  end
  if love.keyboard.isDown("up") then
    -- player.velocity.y = player.velocity.y + (gravity * dt)
    player.y = player.y - (player.velocity.y * dt)
  end

  -- update hitbox position to stay with the player image
  -- hitbox.x = player.x + (player.width * 0.5) - (hitbox.width * 0.5)
  -- hitbox.y = player.y + (player.height * 0.5) - (hitbox.height * 0.5)

  -- update the center co-ord of the hitbox to follow player image
  hitbox.x = player.x + (player.width * 0.5)
  hitbox.y = player.y + (player.height * 0.5)
  -- hc_hitbox:moveTo(hitbox.x, hitbox.y)
end

function game_update(dt)
  sti_update()

  fps = love.timer.getFPS()

  -- fix collision tunneling
  -- ******
  dt = math.min(dt, 1/30) -- 30 FPS at minimum
  -- update objects excluding player
  --

  while dt > player_timeslice do
    dt = dt - player_timeslice
    -- update player with finer granularity timeslice
    hc_hitbox_update(player_timeslice)
    -- Collider:update(player_timeslice)
  end

  -- hc_hitbox_update(dt)
  -- ******

  -- Check for collisions
  -- Collider:update(dt)

end

function game_draw()

  sti_draw()

  if facing_right then
    love.graphics.draw(player.image, player.x, player.y, 0, player.scale, player.scale)
  else
    -- flip the image to the left if facing left
    love.graphics.draw(player.image, player.x, player.y, 0, -1 * player.scale,
     player.scale, (player.width + (hitbox.width * 0.5)) )
  end

  -- draw player hitbox
  love.graphics.setColor(0, 255, 0, 255)
  -- love.graphics.rectangle("line", hitbox.x, hitbox.y, hitbox.width, hitbox.height)
  -- hc_hitbox:draw("line")

  love.graphics.setColor(ground_hitbox.colour)
  -- love.graphics.rectangle("line", ground_hitbox.x, ground_hitbox.y,
  --   ground_hitbox.width, ground_hitbox.height)
  -- hc_ground_hitbox:draw("line")

  love.graphics.setColor(crate_hitbox.colour)
  -- love.graphics.rectangle("line", crate_hitbox.x, crate_hitbox.y,
  --   crate_hitbox.width, crate_hitbox.height)
  -- hc_crate_hitbox:draw("line")


  love.graphics.setColor(0, 0, 0, 255)
  love.graphics.print("Current FPS: " .. tostring(fps), 10, 10)

  -- reset draw colour
  love.graphics.setColor(255, 255, 255, 255)

end

function game_keypressed(key, isrepeat)
  if key == "escape" then
      -- love.event.quit()
      music:stop()
      changegamestate("menu")
  end
end

function sti_load()
  -- grab window size
  windowWidth = love.graphics.getWidth()
  windowHeight = love.graphics.getHeight()

  -- Load a map exported to Lua from Tiled
  map = sti.new("maps/01_01")

  -- Set a collision map to use with your own collision code
  collision = map:getCollisionMap("Collision_Layer")

  -- Create a custom layer
  map:addCustomLayer("Sprite_Layer", 3)

  -- Add data to custom layer
  local spriteLayer = map.layers["Sprite_Layer"]
  spriteLayer.sprites = {
    player = {
      image = love.graphics.newImage("Resources/Images/Sprite_shapeyV01/Untitled-3_frame_0.png"),
      x = 64,
      y = 64,
      r = 0,
    }
  }

  -- Update callback for Custom Layer
  function spriteLayer:update(dt)
      for _, sprite in pairs(self.sprites) do
          sprite.r = sprite.r + math.rad(90 * dt)
      end
  end

  -- Draw callback for Custom Layer
  function spriteLayer:draw()
      for _, sprite in pairs(self.sprites) do
          local x = math.floor(sprite.x)
          local y = math.floor(sprite.y)
          local r = sprite.r
          love.graphics.draw(sprite.image, x, y, r)
      end
  end
end

function sti_update(dt)
  map:update(dt)
end

function sti_draw()
  -- Translation would normally be based on a player's x/y
  local translateX = player.x
  local translateY = player.y

  -- Draw Range culls unnecessary tiles
  map:setDrawRange(translateX, translateY, windowWidth, windowHeight)

  map:draw()

  -- Draw Collision Map (useful for debugging)
  map:drawCollisionMap(collision)
end

