require("config")

local GameScene  = class("GameScene", function()
    return display.newScene("GameScene")
end)

local GameLayer = require("scenes.layers.GameLayer").new()
local HudLayer = require("scenes.layers.HudLayer").new()

function GameScene:ctor()
    self:addChild(GameLayer)
    self:addChild(HudLayer)
    
    local DPad =  HudLayer:getDPad()
    DPad:setDelegate(GameLayer:getClass())
    if opensound== 1 then
    	audio.playEffect(GAME_SFX.BGM,true)
    end
end

return GameScene