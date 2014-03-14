require("config")

local GameScene  = class("GameScene", function()
    return display.newScene("GameScene")
end)

local GameLayer = require("scenes.layers.GameLayer").new()  --对象层
local HudLayer = require("scenes.layers.HudLayer").new() --操作层
--local OtherLayer = require("scenes.layers.OtherLayer").new() --操作层

function GameScene:ctor()
	RobotCount=GameLayer:GetRebotCount()
    self:addChild(GameLayer,0) --对象在2
    self:addChild(HudLayer,1)  --摇杆在1
    --self:addChild(OtherLayer,2)  --其他在3
    
    local DPad =  HudLayer:getDPad() --获取到摇杆
    DPad:setDelegate(GameLayer:getClass())

    if opensound== 1 then
    	audio.playEffect(GAME_SFX.BGM,true)
    end

end
return GameScene