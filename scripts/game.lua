require("config")
require("framework.init")

-- define global module
game = {}

function game.startup()
	
	for k, v in pairs(GAME_SFX) do
		audio.preloadSound(v)
	end

    CCFileUtils:sharedFileUtils():addSearchPath("res/")
    --display.addSpriteFramesWithFile(CONFIG_ROLE_SHEET_FILE,CONFIG_ROLE_SHEET_IMAGE)
    display.addSpriteFramesWithFile(CONFIG_ROLE_SHEET_FILE2,CONFIG_ROLE_SHEET_IMAGE2)

    game.enterMainScene()
end

function game.exit()
    CCDirector:sharedDirector():endToLua()
end

function game.enterMainScene()
    display.replaceScene(require("scenes.GameScene").new(), "fade", 0.6, display.COLOR_WHITE)
end