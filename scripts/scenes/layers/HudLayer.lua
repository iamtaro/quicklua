local HudLayer  = class("HudLayer", function()
    return display.newLayer()
end)

local DPad
function HudLayer:ctor()
    DPad = require("scenes.Controller.SimpleDPad").new() --创建一个摇杆对象
    DPad:setRadius(64)
    DPad:setPosition(64,64)
    DPad:setOpacity(150)
    self:addChild(DPad)
end

function HudLayer:getDPad()  --返回摇杆对象
    return DPad
end

return HudLayer