local external   = require "luafile.external"
local storyboard = require "storyboard"
local scene      = storyboard.newScene()
local w_         = display.contentWidth / 2
local h_         = display.contentHeight / 2 
local group      = nil
local object_    = nil
local button     = nil
local pages      = nil
local count      = 0
local count_     = 0
local level      = 1
local textlabel  = ""
local goto       = ""
local powers     = nil
local star_      = nil
local over_      = nil
local def_       = nil 
local id_        = nil
local scenestats = false
local numvolume
local sql
local bg 

local function none_2 (event)
    
    if event.phase == "down" and event.keyName == "back" and scenestats == true then
        audio.play(external.sfx.clicksound)
        local scenefrom = {
                            effect  = "fade",
                            time    = 500,
                            params  = 
                            {
                                soundv = numvolume.soundv,
                            }
       }
        storyboard.gotoScene( "luafile.gametype",scenefrom)
    return true
    end
    
end

local function onSceneTouch(event)
        local phase = event.phase
        local switch = event.target
        audio.play(external.sfx.clicksound)

    if switch.id == "back" then
        local option = {
                            effect  = "fade",
                            time    = 500,
                            params  = 
                            {
                                soundv = numvolume.soundv,
                                scenename = "menu",
                            }
       }
       storyboard.gotoScene( "luafile.gametype",option)
        --adshow.callflurry("Start Game")
    elseif switch.id == "start" and switch.status_ == "unlocked" then
        goto = "start"
           local scenefrom = {
                            effect  = "fade",
                            time    = 500,
                            params  = 
                            {
                                stage           = switch.stage_,
                                monsternum      = switch.monsternum,
                                damage          = switch.damage,
                                soundv          = numvolume.soundv,
                                speed           = switch.speed,
                                masstatus       = switch.masstatus,
                                mastermon       = switch.mastermon,
                                masdamage       = switch.masdamage,
                                masspeed        = switch.masspeed,
                                highscore       = switch.highscore,
                                level           = switch.level,
                                rowid           = switch.rowid,
                                bigmas          = switch.bigmas,
                                bignum          = switch.bignum,
                                bigdamage       = switch.bigdamage,
                                bigspeed        = switch.bigspeed,
                                star            = switch.star,
                                monmovstats     = switch.monmovstats,
                                movnum          = switch.movnum,
                                tutorial        = switch.tutorial,
                                laser           = powers.laser,
                                car             = powers.car,
                                barrel          = powers.barrel,
                                screenfrom      = "mission",
                                bossing         = switch.bossing,
                                bossbol         = switch.bossbol,
                            }
       }
        storyboard.gotoScene( "luafile.store",scenefrom)
        --audio.stop()
    end
     
end

function scene:createScene( event )
group = self.view
bg = display.newImageRect("background/levelsScreen.png",display.contentWidth,display.contentHeight)
bg.x = w_
bg.y = h_
group:insert(bg)
end

function scene:willEnterScene(event)
pages = {
            s_1 = display.newGroup(), 
            --s_2 = display.newGroup(),
            scroller_1 = nil,
            scroller_2 = nil,
        }
button = {
            back= nil,
            }    
  
star_ = {
        num = nil,
        }
powers = {
            laser = nil,
            car   = nil,
            barrel= nil,
            }
            
end

function scene:enterScene( event )
group = self.view  
numvolume = event.params
object_ = display.newGroup() 
storyboard.purgeAll()
storyboard.removeAll() 
level = numvolume.level

pages.scroller_1 = external.widget.newScrollView
            {
                width = display.contentWidth*.90,
                height = display.contentHeight*0.4,
                hideBackground = true,
                hideScrollBar = true,
            }
pages.scroller_1:setReferencePoint(display.CenterReferencePoint)
pages.scroller_1.x = display.contentWidth*0.5
pages.scroller_1.y = display.contentHeight*0.5
pages.s_1:insert(pages.scroller_1)

--pages.scroller_2 = external.widget.newScrollView
--            {
--                width = display.contentWidth*.90,
--                height = display.contentHeight*0.4,
--                hideBackground = true,
--                hideScrollBar = true,
--            }
--pages.scroller_2:setReferencePoint(display.CenterReferencePoint)
--pages.scroller_2.x = display.contentWidth + display.contentWidth*0.5
--pages.scroller_2.y = display.contentHeight*0.5
--pages.s_2:insert(pages.scroller_2)

local x_ = 0
local y_ = 0
local row
count = 0
count_ = 0
sql = "SELECT * FROM button WHERE level="..level;

for row in external.adshow.db:nrows(sql) do
count = count + 1

if row.stats == "unlocked" then
    textlabel = count
    def_ = "button/woodbutton/def_.png"
    over_= "button/woodbutton/over_.png"
    id_  = "unlocked"
    star_.num =  row.star
elseif row.stats == "locked" then
    textlabel = ""
    def_ = "button/woodbutton/defL_.png"
    over_= "button/woodbutton/overL_.png"
    id_  = "locked"
    star_.num =  0
end

button[count] = external.widget.newButton
    {
    defaultFile = def_,
    overFile    = over_,
    label       = textlabel,
    id          = "start",
    width       = 100, 
    height      = 100,
    font        = "Dimitri",
    fontSize    = 70,
    labelColor  = { default={51, 51, 51,255}, over={153, 255, 255} },
    params      = "hello",
    onRelease   = onSceneTouch,
    }
button[count]:setReferencePoint(display.CenterReferencePoint)
button[count].x = (button[count].width*0.5) + x_
button[count].y = (button[count].height*0.5)+ y_
button[count].status_       = id_
button[count].stage_        = count
button[count].speed         = row.speed
button[count].damage        = row.damage
button[count].masspeed      = row.masspeed
button[count].mastermon     = row.mastermon
button[count].masstatus     = row.masstatus
button[count].masdamage     = row.masdamage
button[count].monsternum    = row.monsternum
button[count].highscore     = row.score
button[count].level         = level
button[count].rowid         = row.id
button[count].bigmas        = row.bigmas
button[count].bignum        = row.bignum
button[count].bigdamage     = row.bigdamage 
button[count].bigspeed      = row.bigspeed
button[count].star          = star_.num 
button[count].monmovstats   = row.monmovstats
button[count].movnum        = row.movnum
button[count].tutorial      = row.tutorial
button[count].bossing       = row.bossing
button[count].bossbol       = row.bossbol

if row.stats == "locked" then
 button[count].alpha = 0.6
else
 button[count].alpha = 1   
end

--
--if count > 20 then
--    
--for i = 1 ,star_.num  , 1 do
--    star_[i] = display.newImageRect("items/star.png", 30, 30)  
--    star_[i]:setReferencePoint(display.CenterReferencePoint)
--    if i == 1 then
--        star_[i].x  = button[count].x
--    elseif i == 2 then
--        star_[i].x  = button[count].x + 30  
--    elseif i == 3 then
--        star_[i].x  = button[count].x - 30 
--    end
--    star_[i].y = button[count].y + 30
--    pages.scroller_2:insert(star_[i]) 
--end
--    x_ = x_ + 120
--    pages.scroller_2:insert(button[count])  
--    
--else
--
--end
pages.scroller_1:insert(button[count])  
for i = 1 ,star_.num  , 1 do
    star_[i] = display.newImageRect("items/star.png", 30, 30)  
    star_[i]:setReferencePoint(display.CenterReferencePoint)
    if i == 1 then
        star_[i].x  = button[count].x
    elseif i == 2 then
        star_[i].x  = button[count].x + 30  
    elseif i == 3 then
        star_[i].x  = button[count].x - 30 
    end
    star_[i].y = button[count].y + 30
    pages.scroller_1:insert(star_[i]) 
end
x_ = x_ + 120  


count_ = count_ + 1
if count_ == 5 then
y_ = y_ + 120    
x_ = 0
count_ = 0
end

end

--transition.to(pages.scroller_2,{x = display.contentWidth*0.5,delay = 1000,time = 10000,transition=easing.outExpo,alpha = 1}) 

sql = "SELECT * FROM item WHERE id="..1;

for row in external.adshow.db:nrows(sql) do
    powers.laser = row.laser
    powers.car   = row.car
    powers.barrel = row.barrel
    
    if powers.car  ==  0 then
    powers.car  = 2
    end
    
    if powers.barrel ==  0 then
    powers.barrel = 4
    end
    
    if powers.laser ==  0 then
    powers.laser = 2
    end
    
end

button.back = external.widget.newButton
    {
        defaultFile = "button/orange/left.png",
        overFile    = "button/orange/lefttap.png",
        id          = "back",
        width       = 80, 
        height      = 80,
        emboss      = true,
        onRelease   = onSceneTouch,
    }
button.back.x = w_ - 240
button.back.y = 80
object_:insert(button.back)

timer.performWithDelay(1000, function ()
if numvolume.scenename == "mainrestart" then
external.adshow.loading("hide")  
end
end, 1)
group:insert(pages.s_1)
--group:insert(pages.s_2)
group:insert(object_)
Runtime:addEventListener( "key", none_2 )
scenestats = true
end

function scene:exitScene( event )
--external.adshow.loading("show")  
--db:close() 
if goto == "start" then 
--external.adshow.loading("show")    
end
goto = ""
end

function scene:destroyScene( event )
object_:removeSelf()
object_ = nil 
Runtime:removeEventListener( "key", none_2 )
scenestats = false
group:removeSelf()
group = nil 
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "willEnterScene",scene)
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )


return scene
