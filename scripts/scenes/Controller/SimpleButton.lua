local SimpleDPad  = class("SimpleButton", function()
    return display.newLayer()
end)

function SimpleButton:ctor()
	self:addTouchEventListener(handler(self, self.onTouch))
	self:setNodeEventEnabled(true)
end 

function SimpleButton:onEnter()
    self:setTouchEnabled(true)
end

function SimpleButton:onExit()
    self:removeAllEventListeners()
end

function Board:onTouch(event, x, y)
    --处理触摸事件
end