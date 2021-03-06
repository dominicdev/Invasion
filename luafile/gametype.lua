local external   = require "luafile.external"
local storyboard = require "storyboard"
local scene      = storyboard.newScene()
local w_         = display.contentWidth / 2
local h_         = display.contentHeight / 2 
local group      = nil
local object_    = nil
local button     = nil
local sql
local count = 0
local bg 
local numvolume 
local def_ 
local over_
local id_  
local textlabel
local level
local textalign 
local textsize
local scenestats = false
local goto = ""

local function none_1 (event)
    if event.phase == "down" and event.keyName == "back" and scenestats == true then
        audio.play(external.sfx.clicksound)
        local scenefrom = {
            effect  = "fade",
            time    = 500,
            params  = 
            {   scenename   = "gametype",
                soundv      = numvolume.soundv,
                }
            }
        storyboard.gotoScene( "luafile.menu",scenefrom)
        end
    return true
    end

local function onSceneTouch(event)
    
    local switch = event.target
    audio.play(external.sfx.clicksound)
    
    --adstatus.hideads ()
    if switch.id == "survival" and switch.stats == "unlocked" and event.phase == "ended" then
        local option = {
            effect  = "fade",
            time    = 500,
            params  = 
            {
                soundv = numvolume.soundv,
                scenename = "gametype",
                screenfrom = "survival",
                }
            }
        storyboard.gotoScene( "luafile.store",option)
        --external.adshow.callflurry("Play Survival")
    elseif switch.id == "levels" and switch.stats == "unlocked" and event.phase == "ended" then
        local scenefrom = {
            effect  = "fade",
            time    = 500,
            params  = 
            {   scenename = "gametype",
                soundv    = numvolume.soundv,
                level     = switch.level,
                }
            }
        storyboard.gotoScene( "luafile.levels",scenefrom)
        --external.adshow.callflurry("Play Mission")
    elseif switch.id == "bonus" and switch.stats == "unlocked" and event.phase == "ended" then
        local scenefrom = {
            effect  = "fade",
            time    = 500,
            params  = 
            {   scenename = "gametype",
                soundv    = numvolume.soundv,
                level     = switch.level,
            }
                }
        storyboard.gotoScene( "luafile.bonus",scenefrom)
        goto = "bonus"
        
        external.adshow.loading("show")
        external.adshow.callflurry("Play Bonus")
        external.adshow.callrevmob("hide")
    elseif switch.id == "back" or event.phase == "down" and event.keyName == "back" then
        local scenefrom = {
            effect  = "fade",
            time    = 500,
            params  = 
            {
                scenename = "gametype",
                soundv    = numvolume.soundv,
                }
            }
        storyboard.gotoScene( "luafile.menu",scenefrom)
    elseif switch.id == "survival" and switch.stats == "locked" and event.phase == "ended" then
        external.adshow.storealert ("Finish the Mission 1 to Unlocked Survival")
    elseif switch.id == "levels" and switch.stats == "locked" and event.phase == "ended" then 
        external.adshow.storealert ("Finish the Mission 1 to Unlocked Mission 2")
    elseif switch.id == "bonus" and switch.stats == "locked" and event.phase == "ended" then
        external.adshow.storealert ("Finish the Mission 2 to Unlocked Mini Game")
        end
    
    end

function scene:createScene( event )
    
    group = self.view
    bg = display.newImageRect("background/levelsScreen.png",display.contentWidth,display.contentHeight)
    bg.x = w_
    bg.y = h_
    group:insert(bg)
    Runtime:addEventListener( "key", none_1 )
    
    end

function scene:willEnterScene(event)
    button = {
        survival    = nil,
        mission_1   = nil,
        mission_2   = nil,
        back        = nil,
        morebutton  = nil,
        }    
    object_ = display.newGroup()    
    end

function scene:enterScene( event )
    group = self.view  
    storyboard.purgeAll()
    storyboard.removeAll() 
    external.adshow.callrevmob("showpop")
    numvolume = event.params
    local y_ = 0
    if external.backmusic == true then
    external.backmusic = false
    audio.play(external.sfx.backmusic,{loops = 99,channel = 1})
    audio.setVolume(0.3, {channel = 1})

    end
    scenestats = true
    count = 0
    sql = "SELECT * FROM gamestats ";
    local row
    for row in external.adshow.db:nrows(sql) do
        
        count = count + 1
        
        if row.stats == "unlocked" then
            
            if row.gametype == "mission_1" then
                id_  = "levels"
                level = 1
                def_ = "button/woodbutton/m1btn.png"
                over_= "button/woodbutton/m1btnover.png"
            elseif row.gametype == "mission_2" then
                id_  = "levels"
                level = 2
                def_ = "button/woodbutton/m2btn.png"
                over_= "button/woodbutton/m2btnover.png"
            elseif row.gametype == "survival" then
                id_  = "survival"
                level = 0
                def_ = "button/woodbutton/survivalbtn.png"
                over_= "button/woodbutton/survivalbtnover.png"
            elseif row.gametype == "bonus" then
                id_  = "bonus"
                level = 0
                def_ = "button/woodbutton/minigame.png"
                over_= "button/woodbutton/minigameover.png"
                end
            textalign = "center"
            textsize = 50
        elseif row.stats == "locked" then
            if row.gametype == "mission_1" then
                textlabel = " Mission 1"
                
            elseif row.gametype == "mission_2" then
                textlabel = "  Mission 2" 
                id_  = "levels"
            elseif row.gametype == "survival" then
                textlabel = "   Survival" 
                id_  = "survival"
            elseif row.gametype == "bonus" then
                textlabel = "   Bonus" 
                id_  = "bonus"
                end
            
            def_ = "button/woodbutton/locked.png"
            over_= "button/woodbutton/lockedover.png"
            textalign = "left"
            textsize = 35
            level = 0
            end
        
        button[count] = external.widget.newButton
        {
            defaultFile = def_,
            overFile    = over_,
            id          = id_,
            width       = 250, 
            height      = 80,
            onRelease   = onSceneTouch,
            }
        button[count]:setReferencePoint(display.CenterReferencePoint)
        button[count].x = w_
        button[count].y = h_ + y_ - 160
        button[count].stats = row.stats
        button[count].level = level
        
        object_:insert(button[count])
        y_ = y_ + 100
        end
    
    button.morebutton = external.widget.newButton
        {
        defaultFile = "button/woodbutton/moregamesbtn.png",
        overFile    = "button/woodbutton/moregamesbtnover.png",
        width       = 211, 
        height      = 50,
        onRelease = function(event)
            audio.play(external.sfx.clicksound)
            if event.phase == "ended" then
                local function networkListener( event )
                    if ( event.isError ) then
                        print( "Network error!")
                        external.adshow.storealert ("Network Error")
                    else
                        print ( "Connected" )
                        external.adshow.showmore("more_games")
                        external.adshow.callflurry("Show more games",name.text)
                        --external.adshow.callplayhaven ("more_games")
                    end
                end
                network.request( "https://encrypted.google.com", "GET", networkListener )
                external.adshow.storealert ("Check internet connection")
            end
        end,
        }
        button.morebutton:setReferencePoint(display.CenterRightReferencePoint)
        button.morebutton.x = display.contentWidth - 10
        button.morebutton.y =  button.morebutton.height *0.8
        button.morebutton.alpha = 1
        object_:insert(button.morebutton)
    
    button.back = external.widget.newButton
    {
        defaultFile = "button/orange/home.png",
        overFile    = "button/orange/hometap.png",
        id          = "back",
        width       = 80, 
        height      = 80,
        emboss      = true,
        onRelease   = onSceneTouch,
        }
    button.back.x = w_ - 240
    button.back.y = 80
    button.back.stats = "back"
    object_:insert(button.back)
    external.adshow.calltapfortap("show")
    
    timer.performWithDelay( 1000, function() 
        if numvolume.scenename == "mainrestart" or numvolume.scenename == "buymenu"  then
            external.adshow.loading("hide")  
            end
        end,1)
    
    group:insert(object_)
    end

function scene:exitScene( event )
    external.adshow.calltapfortap("hide")
    Runtime:removeEventListener( "key", none_1 )
    object_:removeSelf()
    object_ = nil 
    end

function scene:destroyScene( event )
    if goto == "bonus" then
        audio.stop()
        end
    goto = ""
    group:removeSelf()
    group = nil 
    scenestats = false
    
    end

scene:addEventListener( "createScene", scene )
scene:addEventListener("willEnterScene",scene)
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

return scene
