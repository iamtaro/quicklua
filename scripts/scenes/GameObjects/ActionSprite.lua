require("scenes.Define")

local ActionSprite = {}

function ActionSprite:extend()
    local o = o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

function ActionSprite:getName()
  return self:getName()
end

function ActionSprite:idle()
  local ActionState = self:getActionState()
    if ActionState ~= ACTION_STATE_IDLE then
        self:stopAllActions()
        self:createIdleAction()
        local action = self:getIdleAction()
        self:runAction(action)
        ActionState = ACTION_STATE_IDLE
        self:setActionState(ActionState)
    end
end

function ActionSprite:attack()
  local ActionState = self:getActionState()
    if ActionState ~= ACTION_STATE_ATTACK then
        self:stopAllActions()
        self:createAttackAction()
        self:runAction(self:getAttackAction())
        ActionState = ACTION_STATE_ATTACK
        self:setActionState(ActionState)
        if opensound== 1 then
            self:playAttackSound()
        end 
    end
end

function ActionSprite:hurtWithDamage(damage) --攻击受伤
    local ActionState = self:getActionState()
    local HurtPoint = self:getHurtPoint()
    if ActionState ~= ACTION_STATE_KNOCKOUT then
        self:stopAllActions()
        self:createHurtAction();
        self:runAction(self:getHurtAction())
        ActionState = ACTION_STATE_HURT
        self:setActionState(ActionSprite)
    
        local oldPoint = HurtPoint
        HurtPoint = HurtPoint - damage

        print (oldPoint.." --> "..HurtPoint)

        self:setHurtPoint(HurtPoint)
        if HurtPoint <= 0 then
            ActionSprite.knockout(self)
        end
    end
end

function ActionSprite:knockout()
    self:stopAllActions()
    self:createKnockOutAction()
    self:runAction(self:getKnockOutAction())
    self:setActionState(ACTION_STATE_KNOCKOUT)
    if opensound== 1 then
        self:playDeathSound()  
    end
end

function ActionSprite:walkWithDirection(direction)
  local ActionState = self:getActionState()
  local Velocity = self:getVelocity()
  local WalkSpeed = self:getWalkSpeed()
    if ActionState == ACTION_STATE_IDLE then
        self:stopAllActions()
        self:createWalkAction()
        self:runAction(self:getWalkAction())
        ActionState = ACTION_STATE_WALK
        self:setActionState(ActionState)
    end
    
    if ActionState == ACTION_STATE_WALK then
        Velocity = ccp(direction.x * WalkSpeed, direction.y * WalkSpeed)
        self:setVelocity(Velocity)
        if Velocity.x >= 0 then
            self:setScaleX(1*scaleFactor)
        else
            self:setScaleX(-1*scaleFactor)
        end
    end
end

function ActionSprite:update(dt)
  local ActionState = self:getActionState()
  local Velocity = self:getVelocity()
    if ActionState == ACTION_STATE_WALK then
        local DesiredPosition = ccpAdd(ccp(self:getPositionX(),self:getPositionY()),ccpMult(Velocity,dt))
        self:setDesiredPosition(DesiredPosition)
    end
end

function ActionSprite:createBoundingBoxWithOrigin(origin,size)
    local boundingBox = {}
    boundingBox.original = CCRect()
    boundingBox.actual = CCRect()

    boundingBox.original.origin = origin
    boundingBox.original.size = size
    boundingBox.actual.origin = ccpAdd(ccp(self:getPositionX(),self:getPositionY()),ccp(boundingBox.original.origin.x,boundingBox.original.origin.y))
    boundingBox.actual.size = size
    return boundingBox
end

function ActionSprite:transformBoxes()
    local hitBox = self:getHitBox()
    local attackBox = self:getAttackBox()
    local originX

    --if self:getScaleX() == -1 * scaleFactor then
    if self:getScaleX() == -1 * scaleFactor then
        originX = - attackBox.original.size.width - hitBox.original.size.width
    else
        originX = 0
    end

    local position = ccp(self:getPositionX(),self:getPositionY())
    hitBox.actual.origin = ccpAdd(position, ccp(hitBox.original.origin.x, hitBox.original.origin.y));
    attackBox.actual.origin = ccpAdd(position, ccp(attackBox.original.origin.x + originX, attackBox.original.origin.y));

    self:setHitBox(hitBox)
    self:setAttackBox(attackBox)
end

function ActionSprite:setPosition(posX,posY)
    self:setPosition(posX,posY)
    ActionSprite.transformBoxes(self)
end



return ActionSprite