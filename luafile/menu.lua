local external      = require "luafile.external"
local storyboard    = require "storyboard"
local store         = require "store"
local w             = display.contentWidth / 2
local h             = display.contentHeight / 2
local scene         = storyboard.newScene()
local numvolume     = 1
local showpopevent
local timertrans
local timerstop
local constatus
local scenefrom
local scroller
local buttons
local adsbutton
local texting
local switch
local group
local popup
local color
local bg
local products

local function transactionCallback( event )
    print("transactionCallback: Received event " .. tostring(event.name))
    print("state: " .. tostring(event.transaction.state))
    print("errorType: " .. tostring(event.transaction.errorType))
    print("errorString: " .. tostring(event.transaction.errorString))
    
    local productID= event.transaction.productIdentifier;
    if event.transaction.state == "purchased" then
        
        external.adshow.storealert ("Product Purchased: "..productID)
        local bolss = "false"
        local tablesave_1 = [[UPDATE info SET adstats=']].. bolss ..[[' WHERE rowid = 1]]
        external.adshow.db:exec( tablesave_1 )
        external.adshow.callflurry("remove ads")
           local function onComplete( event )
                if "clicked" == event.action then
                    local i = event.index
                    if 1 == i then
                    native.requestExit() 
                    elseif 2 == i then
                    end
                end
            end 
          local alert = native.showAlert( "Exit", "Need to REOPEN the Game to removed ads", { "YES", "Later" }, onComplete )
        native.showAlert("You Buy Product",productID, {"OK"})  
        
    elseif event.transaction.state == "restored" then
        print("Product Restored", productID)
    elseif event.transaction.state == "refunded" then
        print("Product Refunded")
    elseif event.transaction.state == "cancelled" then
        print("Transaction cancelled")
    elseif event.transaction.state == "failed" then
        external.adshow.storealert ("Transaction Failed")
    else
        external.adshow.storealert ("Some unknown event occured. This should never happen.")
    end
    store.finishTransaction( event.transaction )
end

local function audiovolume (event)  
if event.phase == "ended" then
    if event.target.id == "mute" then
        audio.setVolume( 0 )
        buttons.playpause:removeSelf()
        buttons.playpause = nil
        buttons.playpause = external.widget.newButton
            {
            defaultFile = "button/orange/mute.png",
            overFile    = "button/orange/playaudio.png",
            id          = "soundon",
            width       = 80, 
            height      = 80,
            emboss      = true,
            onRelease   = audiovolume,
            }
        buttons.playpause.x = buttons.playpause.width
        buttons.playpause.y = buttons.playpause.height
        group[2]:insert(buttons.playpause) 
        external.adshow.audiostats = false
    elseif event.target.id == "soundon" then
        audio.setVolume(numvolume)

        buttons.playpause:removeSelf()
        buttons.playpause = nil
        buttons.playpause = external.widget.newButton
            {
            defaultFile = "button/orange/playaudio.png",
            overFile    = "button/orange/mute.png",
            id          = "mute",
            width       = 80, 
            height      = 80,
            emboss      = true,
            onRelease   = audiovolume,
            }
        buttons.playpause.x = buttons.playpause.width
        buttons.playpause.y = buttons.playpause.height
        group[2]:insert(buttons.playpause)
        external.adshow.audiostats = true
    end
end 
end

local function onSceneTouch(event)
    
    switch = event.target
    audio.play(external.sfx.clicksound)
    if switch.id == "game" then
        local option = {
                            effect  = "fade",
                            time    = 500,
                            params  = 
                            {
                                soundv = numvolume,
                                scenename = "menu",
                            }
       }
       storyboard.gotoScene( "luafile.gametype",option)
        external.adshow.callflurry("New Game")
       elseif switch.id == "highscore" then
           local scenefrom = {
                            effect  = "fade",
                            time    = 500,
                            params  = 
                            {
                                scenename = "menu"
                            }
       }
        storyboard.gotoScene( "luafile.highscore",scenefrom)
        external.adshow.callflurry("View HighScore")
       elseif switch.id == "instruction" then
           local scenefrom = {
                            effect  = "fade",
                            time    = 500,
                            params  = 
                            {
                                scenename = "menu"
                            }
       }
        storyboard.gotoScene( "luafile.howto", scenefrom )
        external.adshow.callflurry("Instruction")
    end
end

local function ExitAppss (event)
local keyName = event.keyName   
if keyName == "back" and event.phase == "down" then
    audio.play(external.sfx.clicksound)
    local function onComplete( event )
        if "clicked" == event.action then
            local i = event.index
            if 1 == i then
--                if devname == "Android" then
--                    native.requestExit()
--                else
--                   
--                end
            native.requestExit() 
            elseif 2 == i then
            end
        end
    end 
  local alert = native.showAlert( "Exit Game", "Are You Sure?", { "YES", "NO" }, onComplete )
  return true
elseif keyName == "volumeUp" and event.phase == "down" then
      numvolume = numvolume + 0.1
      if numvolume > 1 then
          numvolume = 1
      end
      if numvolume > 0 then
          
            buttons.playpause:removeSelf()
            buttons.playpause = nil
            buttons.playpause = external.widget.newButton
                {
                        defaultFile = "button/orange/playaudio.png",
                        overFile    = "button/orange/mute.png",
                        id          = "soundon",
                        width       = 80, 
                        height      = 80,
                        emboss      = true,
                        onRelease   = audiovolume,
                }
            buttons.playpause.x = buttons.playpause.width
            buttons.playpause.y = buttons.playpause.height
            group[2]:insert(buttons.playpause) 
            
      end
      audio.setVolume(numvolume)
    return false  
elseif keyName == "volumeDown" and event.phase == "down" then
      numvolume = numvolume - 0.1
      if numvolume < 0 then
          numvolume = 0
            buttons.playpause:removeSelf()
            buttons.playpause = nil
            buttons.playpause = external.widget.newButton
                {
                    defaultFile = "button/orange/mute.png",
                    overFile    = "button/orange/playaudio.png",
                    id          = "soundon",
                    width       = 80, 
                    height      = 80,
                    emboss      = true,
                    onRelease   = audiovolume,
                }
            buttons.playpause.x = buttons.playpause.width
            buttons.playpause.y = buttons.playpause.height
            group[2]:insert(buttons.playpause) 
      end
      audio.setVolume(numvolume)
    return false
  elseif keyName == "menu" then
      return true
    end
end

function scene:createScene(event)
external.adshow.callflurry("MENU")
group = {}
group[1] = self.view
group[2] = display.newGroup()
bg = display.newImageRect("background/cover.png",display.contentWidth,display.contentHeight)
bg.x = w
bg.y = h
group[1]:insert(bg)
buttons = {
        aboutbutton     = nil,
        storebutton     = nil,
        facebutton      = nil,
        twitbutton      = nil,
        insbutton       = nil,
        newbutton       = nil,
        highbutton      = nil,
        appbutton       = nil,
        playpause       = nil,
            }
timertrans = false
constatus = false
popup = false

local function loadproducts (store_use)
    if store_use == "apple" then
    products = "eight.app.studio.aliendisruption.myproductname4"
    elseif store_use == "google" then
    products = "eight.app.studio.aliendisruption.myproductname4"   
    end
end            
            
-- Identifies the device and will initialize according to type.
if store.availableStores.apple then
    store.init("apple", transactionCallback)
    loadproducts ("apple")
elseif store.availableStores.google then
    store.init("google", transactionCallback)
    loadproducts ("google")
end

end

function scene:enterScene(event)
--storyboard.purgeAll()
storyboard.removeAll() 

group[1] = self.view
scenefrom = event.params
Runtime:addEventListener( "key", ExitAppss )
timertrans = false
if external.backmusic == true then

audio.play(external.sfx.backmusic,{loops = 99,channel = 1})
audio.setVolume(0.3, {channel = 1})
end


scroller = external.widget.newScrollView
{
    width = 240,
    height = 320,
    maskFile= "background/mask160x120.png",
    hideBackground = true,
    hideScrollBar = true,
    verticalScrollDisabled  = true,
    horizontalScrollDisabled = true,
}
scroller:setReferencePoint(display.CenterReferencePoint)
scroller.x = (w/2) - 10
scroller.y = scroller.y  + h - 30

--texting = display.newEmbossedText("Team\n8 Apps Studio\n\nOur Site:\nwww.8appstudio.com\n\nDeveloper:\nDominic Wagas\n\nGraphic Artist:\nBea Jimenez \n\n", 10, 10,640, 0,  "BadaBoom BB", 28,{ 0, 0, 0, 255 });
texting = display.newEmbossedText("Team\n8 Apps Studio\n\nOur Site:\nwww.8appstudio.com\n\n", 10, 10,640, 0,  "BadaBoom BB", 28,{ 0, 0, 0, 255 });
texting:setReferencePoint(display.BottomCenterReferencePoint);
texting.x =  texting.width/2 + 20 
texting.y = scroller.height + texting.height
texting:setTextColor( 0, 0, 0 )
color = 
{
    highlight = 
    {
        r =255, g = 255, b = 255, a = 100
    },
    shadow =
    {
        r = 255, g = 255, b = 255, a = 100
    }
}
texting:setEmbossColor( color )
scroller:insert(texting)

local function aboutustop (object)
    local function mustdone ()
        timertrans = false      
        
    end
--transition.to(buttons.facebutton,{time = 1000,alpha = 1,onComplete = mustdone})
--transition.to(buttons.twitbutton,{time = 1000,alpha = 1,onComplete = mustdone})
buttons.appbutton.y = texting.y + 10
transition.to(buttons.appbutton,{time = 1000,alpha = 1,onComplete = mustdone})
end
 
buttons.aboutbutton = external.widget.newButton
{
    defaultFile = "button/woodbutton/aboutbtn.png",
    overFile    = "button/woodbutton/aboutbtnover.png",
    width       = 200, 
    height      = 60,
    onRelease   = function (event)
        audio.play(external.sfx.clicksound)  
        if event.phase == "ended" and timertrans == false then
            buttons.facebutton.alpha = 0
            buttons.twitbutton.alpha = 0
            buttons.appbutton.alpha = 0
            texting.y = scroller.height + texting.height
            timerstop = transition.to(texting,{time = 3000,y = texting.height + 50,alpha = 0.9,onComplete = aboutustop})
            timertrans = true   
        end
    end,
}
buttons.aboutbutton:setReferencePoint(display.CenterReferencePoint)
buttons.aboutbutton.x = w/2 - 10
buttons.aboutbutton.y = h + 300
buttons.aboutbutton.alpha = 0
group[2]:insert(buttons.aboutbutton)

buttons.facebutton = external.widget.newButton
{
    defaultFile = "button/facebook/tap.png",
    overFile    = "button/facebook/over.png",
    id          = "facebook",
    width       = 80, 
    height      = 80,
    onRelease   = function (event)
    audio.play(external.sfx.clicksound)
    if event.phase == "ended" then
        local function listineralert (event)
         ----print(event.action)
         if event.action == "clicked" then
                local i = event.index
                if i == 1 then

                    local function networkListener_1( event )
                        if ( event.isError ) then
                               -- --print( "Network error!")
                                external.adshow.storealert ("Network Error")
                        else
                                system.openURL("https://www.facebook.com/8AppStudio?ref=stream")
                                -- print ( "Connected share" )      
                        end
                    end
                    if constatus == false then
                        network.request( "https://encrypted.google.com", "GET", networkListener_1 )
                        constatus = true
                    elseif constatus == true then
                        constatus = false
                    end
                    external.adshow.storealert ("Check internet connection") 
                elseif i == 2 then

                    local function networkListener_2( event )
                        if ( event.isError ) then
                            external.adshow.storealert ("Network Error")
                        else
                            native.showWebPopup(20, 20, display.contentWidth - 40, display.contentHeight - 160, "https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Fwww.facebook.com/pages/Home-Invation-Community/612653745441523")
                            popup = true     
                        end
                    end
                    if constatus == false then
                        network.request( "https://encrypted.google.com", "GET", networkListener_2 )
                        constatus = true
                    elseif constatus == true then
                        constatus = false
                    end
                external.adshow.storealert ("Check internet connection") 
                elseif i == 3 then  

                end
            end
        end
        native.showAlert( "Facebook", " Visit and Share", { "LIKE US!","Share","Cancel" },listineralert )             
    end
    end,}
buttons.facebutton:setReferencePoint(display.CenterLeftReferencePoint)
buttons.facebutton.x = 20
buttons.facebutton.y = 110
buttons.facebutton.alpha = 0
scroller:insert(buttons.facebutton)

buttons.twitbutton = external.widget.newButton
{
    defaultFile = "button/twitter/tap.png",
    overFile    = "button/twitter/over.png",
    id          = "twitter",
    width       = 80, 
    height      = 80,
    onRelease   = function (event)
        audio.play(external.sfx.clicksound)
        if event.phase == "ended" then
            local function networkListener( event )
                if ( event.isError ) then
                    --print( "Network error!")
                    external.adshow.storealert ("Network Error")
                else
                    print ( "Connected" )
                    system.openURL("https://twitter.com/8appstudio")

                end
            end
            network.request( "https://encrypted.google.com", "GET", networkListener )
            external.adshow.storealert ("Check internet connection")   
        end
    end,

}
buttons.twitbutton:setReferencePoint(display.CenterLeftReferencePoint)
buttons.twitbutton.x = buttons.facebutton.x + buttons.facebutton.width
buttons.twitbutton.y = buttons.facebutton.y
buttons.twitbutton.alpha = 0
scroller:insert(buttons.twitbutton)

buttons.appbutton = external.widget.newButton
{
    defaultFile = "button/8app/tap.png",
    overFile    = "button/8app/over.png",
    id          = "game",
    width       = 150, 
    height      = 60,
    onRelease   = function (event)
        if event.phase == "ended" then
        
         local function networkListener_3( event )
            if ( event.isError ) then
                --print( "Network error!")
                external.adshow.storealert ("Network Error")
            else
                print ( "Connected" )
                system.openURL("http://8appstudio.com")

            end
        end
        network.request( "https://encrypted.google.com", "GET", networkListener_3 )
        external.adshow.storealert ("Check internet connection")         
    end
            end,}
buttons.appbutton:setReferencePoint(display.CenterLeftReferencePoint)
buttons.appbutton.x = 20
buttons.appbutton.y = buttons.twitbutton.y  + 90
buttons.appbutton.alpha = 0
scroller:insert(buttons.appbutton)

buttons.newbutton = external.widget.newButton
{
    defaultFile = "button/woodbutton/newgamebtn.png",
    overFile    = "button/woodbutton/newgamebtnover.png",
    id          = "game",
    width       = 250, 
    height      = 80,
    onRelease   = onSceneTouch,
}
buttons.newbutton:setReferencePoint(display.TopLeftReferencePoint)
buttons.newbutton.x = display.contentWidth
buttons.newbutton.y = h 

buttons.insbutton = external.widget.newButton
{
    defaultFile = "button/woodbutton/howtoplaybtn.png",
    overFile    = "button/woodbutton/howtoplaybtnover.png",
    id          = "instruction",
    width       = 250, 
    height      = 80,
    onRelease   = onSceneTouch,
}
buttons.insbutton:setReferencePoint(display.TopLeftReferencePoint)
buttons.insbutton.x = buttons.newbutton.x
buttons.insbutton.y = buttons.newbutton.y + 100 

if external.adshow.audiostats == true then
    
buttons.playpause = external.widget.newButton
{
        defaultFile = "button/orange/playaudio.png",
        overFile    = "button/orange/mute.png",
        id          = "mute",
        width       = 80, 
        height      = 80,
        emboss      = true,
        onRelease   = audiovolume,
    }
buttons.playpause.x = buttons.playpause.width
buttons.playpause.y = buttons.playpause.height

elseif external.adshow.audiostats == false then
buttons.playpause = external.widget.newButton
{
        defaultFile = "button/orange/mute.png",
        overFile    = "button/orange/playaudio.png",
        id          = "soundon",
        width       = 80, 
        height      = 80,
        emboss      = true,
        onRelease   = audiovolume,
    }
buttons.playpause.x = buttons.playpause.width
buttons.playpause.y = buttons.playpause.height    
end

buttons.highbutton = external.widget.newButton
{
    defaultFile = "button/woodbutton/highscoresbtn.png",
    overFile    = "button/woodbutton/highscoresbtnover.png",
    id          = "highscore",
    width       = 250, 
    height      = 80,
    onRelease   = onSceneTouch,
}
buttons.highbutton:setReferencePoint(display.TopLeftReferencePoint)
buttons.highbutton.x = buttons.insbutton.x
buttons.highbutton.y = buttons.insbutton.y + 100

buttons.storebutton = external.widget.newButton
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
                external.adshow.showmore()
                external.adshow.calltapfortap ("appwall")
            end
        end
        network.request( "https://encrypted.google.com", "GET", networkListener )
        external.adshow.storealert ("Check internet connection")
    end
end,
}
buttons.storebutton:setReferencePoint(display.CenterRightReferencePoint)
buttons.storebutton.x = display.contentWidth - 10
buttons.storebutton.y =  buttons.storebutton.height
buttons.storebutton.alpha = 0

adsbutton = external.widget.newButton
        {
            defaultFile     = "button/ads/adstap.png",
            overFile        = "button/ads/adsover.png",
            width           = 200, 
            height          = 60,
            onRelease       = function (event) 
                if event.phase == "ended" then
                    
                    local function onComplete( event )
                  
                        if "clicked" == event.action then
                            local i = event.index
                            if 1 == i then
                                store.purchase({products})
                            elseif 2 == i then
                            
                            end
                        end
                    end 
                  local alert = native.showAlert( "Remove Ads", "Remove Ads for $0.99, Are you Sure?", { "YES", "NO" }, onComplete )
                end
            end,
        }
adsbutton:setReferencePoint(display.TopRightReferencePoint)
adsbutton.x = display.contentWidth 
adsbutton.y = -13
adsbutton.alpha  = 0

timer.performWithDelay( 1000, function() 
if (scenefrom.scenename == "gametype") or (scenefrom.scenename == "highscore") or (scenefrom.scenename == "howto") or (scenefrom.scenename == "store") then
else
    external.adshow.loading("hide") 
    
end
timer.performWithDelay( 1000, function() 
    if external.adshow.sqlload == false then
        external.adshow.loadsql  ()
        external.adshow.sqlload = true
    end
end,1)

transition.to(buttons.newbutton, { time=1000, x= display.contentWidth - 320, transition=easing.inOutQuad})  
transition.to(buttons.insbutton, { delay = 500,time=1000, x= display.contentWidth - 320, transition=easing.inOutQuad}) 
transition.to(buttons.highbutton, { delay = 300,time=1000, x= display.contentWidth - 320, transition=easing.inOutQuad}) 
transition.to(buttons.aboutbutton, { delay = 1000,time=2000, alpha = 1}) 
transition.to(buttons.storebutton, { delay = 1000,time=2000, alpha = 0}) 
if external.adshow.ads == true then
    transition.to(adsbutton, { delay = 1000,time=2000, alpha = 1}) 
end
external.adshow.callrevmob("320x50")
end, 1 )

function showpopevent(event)
    if popup == true then
        native.cancelWebPopup()
        popup = false
    end
end

Runtime:addEventListener( "touch", showpopevent )
group[2]:insert(adsbutton) 
group[2]:insert(buttons.playpause) 
group[2]:insert(scroller)
group[2]:insert(buttons.newbutton)
group[2]:insert(buttons.insbutton)
group[2]:insert(buttons.highbutton)  
group[2]:insert(buttons.storebutton)
group[1]:insert(group[2])
--external.adshow.callrevmob("fullscreen")
end

function scene:exitScene(event)
Runtime:removeEventListener( "touch", showpopevent )
if popup == true then
    native.cancelWebPopup()
    popup = false
end
Runtime:removeEventListener( "key", ExitAppss )
popup = false
group[2]:removeSelf()
group[2] = nil
--external.adshow.callrevmob("hide")

end

function scene:destroyScene(event)  
group[1]:removeSelf()
group[1] = nil
end

scene:addEventListener( "createScene",  scene )
scene:addEventListener( "enterScene",   scene )
scene:addEventListener( "exitScene",    scene )
scene:addEventListener( "destroyScene", scene )

return scene