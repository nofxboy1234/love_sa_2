local class = require("lib.hump.class")
Player = class{}

function Player:init(x, y, sx, sy)
  self.image = love.graphics.newImage("maps/player.png")
  self.scale = 1
  self.x = x
  self.y = y
  self.speed_x = sx
  self.speed_y = sy
  self.width = self.image:getWidth()
  self.height = self.image:getHeight()

  self.hitbox = Hitbox(self, self.x, self.y, self.width, self.height)
end

function Player:update(dt)
  if love.keyboard.isDown("right") or joystick_01:isDown(12) then
    self.x = self.x + (self.speed_x * dt)
  end
  if love.keyboard.isDown("left") or joystick_01:isDown(11) then
    self.x = self.x - (self.speed_x * dt)
  end

  if love.keyboard.isDown("down") or joystick_01:isDown(14) then
    self.y = self.y + (self.speed_y * dt)
  end
  if love.keyboard.isDown("up") or joystick_01:isDown(13) then
    self.y = self.y - (self.speed_y * dt)
  end

  self.hitbox:update(dt)
end

function Player:draw()
  local x = math.floor(self.x)
  local y = math.floor(self.y)

  love.graphics.draw(self.image, x, y)

  self.hitbox:draw()
end

