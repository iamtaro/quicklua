local OtherLayer  = class("OtherLayer", function()
    return display.newLayer()
end)

local newLabel

function OtherLayer:ctor()
	newLabel = ui.newTTFLabel({
	        text = "剩余怪物数量：" ..RobotCount,
	        color = display.COLOR_WHITE,
	        size = 16,
	        align = ui.TEXT_ALIGN_CENTER,
	        x = display.cx - 200,
	        y = display.cy + 150
	    }):addTo(self, 1)
	
end

function OtherLayer:setString(tmp)
	return newLabel:setString("剩余怪物数量：" ..tmp)
end

return OtherLayer