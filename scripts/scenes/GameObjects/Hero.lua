local Hero  = class("Hero", function()
  --return display.newSprite("#hero_idle_00.png")
  return display.newSprite("#bdhero002-stand2-0000.png")
end)

require("scenes.Define")
require("config")
local Prototype = require("scenes.GameObjects.ActionSprite"):extend(Hero)
--Animation Cache
local HERO_IDLE = "heroIdle"  --待机
local HERO_ATTACK ="heroAttack"  --攻击
local HERO_WALK = "heroWalk"  --行走
local HERO_HURT = "heroHurt"  --受伤
local HERO_KNOCKOUT = "heroKnockOut" --被击杀
  
--attribute
local WalkSpeed
local Damage

--measurements
local CenterToSide
local CenterToBottom

function Hero:ctor(name)
  self:setScale(scaleFactor)  -- 设置初始缩放大小
  WalkSpeed = 150 --移动速度
  self.HurtPoint = 200 --初始血量
  Damage = 20 --伤害
  CenterToSide = 29
  CenterToBottom = 39
  self.Name = name
  
  self.HitBox = Prototype.createBoundingBoxWithOrigin(self,ccp(-self:getCenterToSides(), -self:getCenterToBottom()),
    CCSizeMake(self:getCenterToSides() * 2, self:getCenterToBottom() * 2))
  self.AttackBox = Prototype.createBoundingBoxWithOrigin(self,ccp(self:getCenterToSides(), -10), CCSizeMake(20, 20));
end

function Hero:getName()
  return self.Name
end

function Hero:getClass()
  return Prototype
end

function Hero:update(dt)
  Prototype.update(self,dt)
end

function Hero:createIdleAction()
  --local frames = display.newFrames("hero_idle_%02d.png",0,6)
  local frames = display.newFrames("bdhero002-stand2-00%02d.png",0,5)
  local animation = display.newAnimation(frames,1/12)
  display.setAnimationCache(HERO_IDLE,animation)
  self.IdleAction = CCRepeatForever:create(CCAnimate:create(animation))
end

function Hero:createAttackAction()
  --local frames = display.newFrames("hero_attack_00_%02d.png",0,3)
  local frames = display.newFrames("bdhero002-atk1-00%02d.png",0,8)
  local animation = display.newAnimation(frames,1/24)
  display.setAnimationCache(HERO_ATTACK,animation)
  local idelFunc = CCCallFunc:create(function() self:idle() end)
  self.AttackAction = CCSequence:createWithTwoActions(CCAnimate:create(animation),idelFunc)
end

function Hero:createWalkAction()
  --local frames = display.newFrames("hero_walk_%02d.png",0,8)
  local frames = display.newFrames("bdhero002-run2-00%02d.png",0,7)
  local animation = display.newAnimation(frames,1/12)
  display.setAnimationCache(HERO_WALK,animation)
  local idelFunc = CCCallFunc:create(function() self:idle() end)
  self.WalkAction = CCRepeatForever:create(CCAnimate:create(animation))
end

function Hero:createHurtAction()
  --local frames = display.newFrames("hero_hurt_%02d.png",0,3)

  local frames = display.newFrames("bdhero002-hit-00%02d.png",1,1)

  local animation = display.newAnimation(frames,1/2)
  display.setAnimationCache(HERO_HURT,animation)
  local idelFunc = CCCallFunc:create(function() self:idle() end)
  self.HurtAction = CCSequence:createWithTwoActions(CCAnimate:create(animation),idelFunc)
end

function Hero:createKnockOutAction()
  --local frames = display.newFrames("hero_knockout_%02d.png",0,5)

  local frames = display.newFrames("bdhero002-die-00%02d.png",1,9)
  local animation = display.newAnimation(frames,1/12)
  display.setAnimationCache(HERO_KNOCKOUT,animation)
  self.KnockOutAction = CCSequence:createWithTwoActions(CCAnimate:create(animation),CCBlink:create(2,10))
end

function Hero:getWalkSpeed()
  return WalkSpeed
end

function Hero:getCenterToSides()
  return CenterToSide
end

function Hero:getCenterToBottom()
  return CenterToBottom
end

function Hero:getDesiredPosition()
  return self.DesiredPosition
end

function Hero:setDesiredPosition(param)
  self.DesiredPosition = param
end

function Hero:getActionState()
  return self.ActionState
end

function Hero:setActionState(param)
  self.ActionState = param
end

function Hero:getVelocity()
  return self.Velocity
end

function Hero:setVelocity(param)
  self.Velocity = param
end

function Hero:getWalkAction()
  return self.WalkAction
end

function Hero:getAttackAction()
  return self.AttackAction
end

function Hero:getIdleAction()
  return self.IdleAction
end

function Hero:getHurtAction()
  return self.HurtAction
end

function Hero:getKnockOutAction()
  return self.KnockOutAction
end

function Hero:setHitBox(box)
  self.HitBox = box
end

function Hero:getHitBox()
  return self.HitBox
end

function Hero:setAttackBox(box)
  self.AttackBox = box
end

function Hero:getAttackBox()
  return self.AttackBox
end

function Hero:getHurtPoint()
  return self.HurtPoint
end

function Hero:setHurtPoint(param)
  self.HurtPoint = param
end

function Hero:getDamage()
  return Damage
end
  
function Hero:idle()
  Prototype.idle(self)
end

function Hero:attack()
  Prototype.attack(self)
end

function Hero:playAttackSound()
  if opensound == 1 then
    print("play heroAttackSound")
    audio.playSound(GAME_SFX.HIT0)
  end
end

function Hero:playDeathSound()
  audio.playSound(GAME_SFX.HERO_DEATH)
end

function Hero:hurtWithDamage(damage)
  Prototype.hurtWithDamage(self,damage)
end

function Hero:walkWithDirection(direction)
  Prototype.walkWithDirection(self,direction)
end
return Hero