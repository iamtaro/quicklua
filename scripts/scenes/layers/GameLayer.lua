require("config")
require("scenes.define")

local GameLayer  = class("GameLayer", function()
    return display.newLayer()
end)

local TileMap
local Hero
local Delegate = require("scenes.Controller.SimpleDPadDelegate"):extend()
local Robot = require("scenes.GameObjects.Robot")
local DisabledRect
--local RobotCount = 10 --生成怪物数量
local TimeVal = 0


local newLabel

function GameLayer:ctor()

	self.Actors = display.newBatchNode(CONFIG_ROLE_SHEET_IMAGE2)
	self:addChild(self.Actors,1)
	self.ActorList = {}
	self.RobotList = {}
	self.CurrentIndex = 0
	self:initTileMap()
	self:initHero();
	self:initRobots();

  self:addTouchEventListener(handler(self, self.onTouch))
  self:setNodeEventEnabled(true)

	--self.touchLayer = display.newLayer()
	--self:addChild(self.touchLayer,2)
	--self:setNodeEventEnabled(true)


	local updateFunc = function(dt) self:onUpdate(dt) end
	self:scheduleUpdate(updateFunc)

  newLabel = ui.newTTFLabel({        --创建一个面板调试
          text = "剩余怪物数量：" ..RobotCount,
          color = display.COLOR_WHITE,
          size = 16,
          align = ui.TEXT_ALIGN_CENTER,
          --x, y = Hero:getPosition()
          x = Hero:getPositionX() + 50,
          y = Hero:getPositionY() + 100
      }):addTo(self, 1)

end

function GameLayer:onEnter()
    self:setTouchEnabled(true)
end

function GameLayer:onExit()
    self:removeAllEventListeners()
end

function GameLayer:onTouch(event, x, y)
    local count = #self.RobotList --获取到机器人数量
    local heroPosition = ccp(Hero:getPositionX(),Hero:getPositionY()) --获取到英雄位置
    --print("-----------have a touch---------------"..x.."----"..y) --处理触摸事件
    if x > (CONFIG_SCREEN_WIDTH/2) then --如果在屏幕右侧
        local heroHurt = Hero:getHurtPoint()
        print("heroHurt : "..heroHurt)
        if heroHurt > 0 then --如果死了就不能攻击了
            Hero:attack() --主角攻击
            Hero:playAttackSound()

            for i = 1, count do --遍历所有的机器人
              local robot = self.RobotList[i]
              if robot:getHurtPoint() >0 then   --先判断还存活
                local getPositionX=robot:getPositionX()
                local getPositionY=robot:getPositionY()
                local robotPosition = ccp(getPositionX,getPositionY)  --获取机器人位置
                print(robot:getName().." x="..getPositionX.." y="..getPositionY)
                if math.abs(heroPosition.y - robotPosition.y) < 20 then --判断英雄和机器人坐标差是否小于20
                  if robot:getHitBox().actual:intersectsRect(Hero:getAttackBox().actual) then
                    robot:hurtWithDamage(Hero:getDamage()) --调用机器人掉血逻辑
                  end                 
                end
              end
            end
        end 
    end
end


function GameLayer:initHero()
    Hero = require("scenes.GameObjects.Hero").new("Hero")
    self:addActors(Hero)
    Hero.getClass().setPosition(Hero,Hero:getCenterToSides(),80)
    --Hero.setPosition(Hero,Hero:getCenterToSides(),80)
    local x, y = Hero:getPosition()
    Hero:setDesiredPosition(ccp(x,y))
    Hero:idle()    
end

function GameLayer:initRobots() --创建机器人
	for RobotIndex = 1, RobotCount do
		local RobotCell = Robot.new("Robot"..RobotIndex)
		self:addActors(RobotCell)
		self.RobotList[#self.RobotList + 1] = RobotCell
		local minX = SCREEN_SIZE.width + RobotCell:getCenterToSides()
		local maxX = TileMap:getMapSize().width * TileMap:getTileSize().width - RobotCell:getCenterToSides()
		local minY = RobotCell:getCenterToBottom()
		local maxY = 3 * TileMap:getTileSize().height + RobotCell:getCenterToBottom()
		RobotCell.getClass().setPosition(RobotCell,math.random(minX, maxX),math.random(minY, maxY)) --在地图上随机
		RobotCell:setScaleX(-1) --还是要缩放一下
		RobotCell:setDesiredPosition(ccp(RobotCell:getPositionX(),RobotCell:getPositionY()))
		RobotCell:idle()
	end
end

function GameLayer:GetRebotCount()  --返回怪物数量
  return RobotCount
end

function GameLayer:GetRebotLVCount()  --返回剩余怪物数量
  return RebotLVCount
end

function GameLayer:updateRobots(dt)
  TimeVal = TimeVal + dt
  local alive = 0
  local distanceSQ
  local randomChoice
  local curTime = TimeVal * 1000
  local count = #self.RobotList
  local heroPosition = ccp(Hero:getPositionX(),Hero:getPositionY()) --获取到英雄位置
  local RebotLVCount = RobotCount  --获取还存活的机器人数量
  for i = 1, count do --遍历所有的机器人
    local robot = self.RobotList[i]
    local robotPosition = ccp(robot:getPositionX(),robot:getPositionY())  --获取机器人位置
    robot:update(dt)
    if robot:getActionState() ~= ACTION_STATE_KNOCKOUT then
      alive = alive + 1
      if curTime > robot:getNextDecisionTime() then
        distanceSQ = ccpDistanceSQ(robotPosition,heroPosition)
        if distanceSQ <= 250 then
          robot:setNextDecisionTime(curTime + math.random() * 1000)
          randomChoice = math.random(0,1)
          
          if randomChoice <= 0.2 then
            if heroPosition.x > robotPosition.x then
              robot:setScaleX(1*scaleFactor)
            else
              robot:setScaleX(-1*scaleFactor)
            end
            
            robot:setNextDecisionTime(curTime + math.random() * 2000)
            robot:attack()
            if robot:getActionState()  == ACTION_STATE_ATTACK then
              if math.abs(heroPosition.y - robotPosition.y) < 20 then
                if Hero:getHitBox().actual:intersectsRect(robot:getAttackBox().actual) then
                  Hero:hurtWithDamage(robot:getDamage())
                end
              end
            end
         else
           robot:idle()
         end
       elseif distanceSQ <= SCREEN_SIZE.width * SCREEN_SIZE.width then
         robot:setNextDecisionTime(curTime + math.random() * 1000)
         randomChoice = math.random(0,2)
         if randomChoice == 0 then
           local moveDirection = ccpNormalize(ccpSub(heroPosition,robotPosition))
           robot:walkWithDirection(moveDirection)
         else
           robot:idle()
         end

       end
     end
    else
    RebotLVCount =  RebotLVCount - 1
   end
 end
 newLabel:setString("剩余怪物数量：" ..RebotLVCount)
end

function GameLayer:initTileMap()
    TileMap = CCTMXTiledMap:create(CONFIG_TILEMAP_FILE)
    self:addChild(TileMap,0)
end

function Delegate:didChangeDirectionTo(SimpleDPad,Direction) 
    Hero:walkWithDirection(Direction)
end

function Delegate:isHoldingDirection(SimpleDPad,Direction)
    Hero:walkWithDirection(Direction)
end

function Delegate:simpleDPadTouchEnded(SimpleDPad, Direction)
    if Hero:getActionState() == ACTION_STATE_WALK then
        Hero:idle()
    end
end

function GameLayer:getClass()
	return Delegate
end

function GameLayer:addActors(actor)
  self.Actors:addChild(actor)
  self.ActorList[#self.ActorList + 1] = actor
end

function GameLayer:onUpdate(dt)
	Hero:update(dt)
	self:updatePositions()
	self:setViewPointCenter(Hero:getPosition());
	self:renderActors()
	self:updateRobots(dt)
end

function GameLayer:updatePositions()
	local position = Hero:getDesiredPosition()
	local posX
	local posY
	if position.x ~= Hero:getPositionX() or position.y ~= Hero:getPositionY() then
		posX = math.min(TileMap:getMapSize().width * TileMap:getTileSize().width - Hero:getCenterToSides(),
		math.max(Hero:getCenterToSides(), position.x))

		posY = math.min(3 * TileMap:getTileSize().height + Hero:getCenterToBottom(),
		math.max(Hero:getCenterToBottom(), position.y))

		Hero.getClass().setPosition(Hero,posX,posY)
	end

	local count = #self.RobotList
	for i = 1, count do
		local robot = self.RobotList[i]
		position = robot:getDesiredPosition()
		if position.x ~= robot:getPositionX() or position.y ~= robot:getPositionY() then
			posX = math.min(TileMap:getMapSize().width * TileMap:getTileSize().width - robot:getCenterToSides(),
			math.max(robot:getCenterToSides(), position.x))

			posY = math.min(3 * TileMap:getTileSize().height + robot:getCenterToBottom(),
			math.max(robot:getCenterToBottom(), position.y))

			robot.getClass().setPosition(robot,posX,posY)
		end
	end
end

function GameLayer:setViewPointCenter(heroPosX, heroPosY)
  local x = math.max(heroPosX,SCREEN_SIZE.width/2)
  local y = math.max(heroPosY,SCREEN_SIZE.height/2)
  x = math.min(x,(TileMap:getMapSize().width * TileMap:getTileSize().width) - SCREEN_SIZE.width/2)
  y = math.min(y,(TileMap:getMapSize().height * TileMap:getTileSize().height) - SCREEN_SIZE.height/2)
  local actualPosition = ccp(x,y)
  local viewPoint = ccpSub(CENTER,actualPosition)
  self:setPosition(viewPoint)
end

function GameLayer:renderActors()
  local count = #self.ActorList
    for i = 1, count do
      local actor = self.ActorList[i]
        local zOrder = (TileMap:getMapSize().height * TileMap:getTileSize().height) - actor:getPositionY()
        self.Actors:reorderChild(actor,zOrder)
    end
end

return GameLayer