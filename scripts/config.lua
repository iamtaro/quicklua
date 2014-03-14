-- 0 - disable debug info, 1 - less debug info, 2 - verbose debug info
DEBUG = 2
DEBUG_FPS = true

-- design resolution
CONFIG_SCREEN_WIDTH  = 640
CONFIG_SCREEN_HEIGHT = 960

--资源
CONFIG_ROLE_SHEET_IMAGE = "pd_sprites.pvr.ccz"
CONFIG_ROLE_SHEET_FILE = "pd_sprites.plist"

CONFIG_ROLE_SHEET_IMAGE2 = "hero002_sprites.png"
CONFIG_ROLE_SHEET_FILE2 = "hero002_sprites.plist"

--地图
CONFIG_TILEMAP_FILE = "pd_tilemap5.tmx"

--音效
GAME_SFX = {
	HIT0 = "pd_hit0.wav",
	HIT1 = "pd_hit1.wav",
	HERO_DEATH = "pd_herodeath.wav",
	BOT_DEATH = "pd_botdeath.wav",
	BGM = "LevelWinSound.mp3",
}

-- auto scale mode
CONFIG_SCREEN_AUTOSCALE = "FIXED_WIDTH"

scaleFactor = 0.65 --Sprite缩放系数

opensound = 0 --开启音乐

RobotCount = 10 --怪物数量

debuginfo = ""