function menu_load()
  menu_items = {"start game", "credits", "help", "quit"}
  title_img = love.graphics.newImage("Resources/Images/SA-01_720.png")

  music = love.audio.newSource("Resources/Sounds/Circlerun_ZEQ2_Select_Your_Game_Mode.mp3", "stream")
  music:setLooping(true)
  music:setVolume(0.2)
  music:play()

  menu_sound = love.audio.newSource("Resources/Sounds/Menu_Selection_Click.wav", "static")
  -- menu_sound:setVolume(1.0)

  menuselection = 1
end

function menu_update(dt)
  -- body
end

function menu_draw()
  love.graphics.draw(title_img, 0, 0)
  -- Draw menu
  center_v_offset = 150
  offset = 0
  for i = 1, #menu_items do
    -- Set menu text colour depending on of it is selected
    if menuselection == i then
      love.graphics.setColor(255, 255, 255)
    else
      love.graphics.setColor(0, 0, 0)
    end

    love.graphics.print(menu_items[i], width/2, height/2 + center_v_offset  + offset)
    offset = offset + 20
  end
  love.graphics.setColor(255, 255, 255)

end

function menu_keypressed(key, isrepeat)
  if key == "escape" then
      love.event.quit()
  end

  -- if (key == "up") and menuselection > 1 then
  --   menuselection = menuselection - 1
  -- elseif (key == "down") and menuselection < #menu_items then
  --     menuselection = menuselection + 1
  -- end

  if (key == "up") and menuselection > 1 then
    menuselection = menuselection - 1
    menu_sound:stop()
    menu_sound:play()
  elseif (key == "up") and menuselection == 1 then
    menuselection = #menu_items
    menu_sound:stop()
    menu_sound:play()
  elseif (key == "down") and menuselection < #menu_items then
    menuselection = menuselection + 1
    menu_sound:stop()
    menu_sound:play()
  elseif (key == "down") and menuselection == #menu_items then
    menuselection = 1
    menu_sound:stop()
    menu_sound:play()
  end

  if key == "return" and menuselection == 1 then
    music:stop()
    changegamestate("game")
  elseif key == "return" and menuselection == 4 then
    love.event.quit()
  end
end

