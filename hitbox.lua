local class = require("lib.hump.class")
Hitbox = class{}

function Hitbox:init(player, px, py, pw, ph)
  self.parent_object = player

  self.scale_x = 1
  self.scale_y = 1

  self.width = pw * self.scale_x
  self.height = pw * self.scale_y
  self.x = px + (0.5 * pw) - (0.5 * self.width)
  self.y = py + (0.5 * ph) - (0.5 * self.height)

  self.hc_hitbox = collider:addRectangle(self.x, self.y, self.width, self.height)
end

function Hitbox:update(dt)
  -- update the center co-ord of the hitbox to follow player image
  self.x = self.parent_object.x + (self.parent_object.width * 0.5)
  self.y = self.parent_object.y + (self.parent_object.height * 0.5)

  self.hc_hitbox:moveTo(self.x, self.y)
end

function Hitbox:draw()
  love.graphics.setColor(0, 255, 0, 255)
  self.hc_hitbox:draw('line')
end
