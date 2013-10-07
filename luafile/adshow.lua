    local adshow = {}
local loadingscreen
local loadingwid
local widget = require "widget"
local sqlite3    = require "sqlite3"

local w_ = display.contentWidth / 2
local h_ = display.contentHeight / 2 
local file
local row

adshow.audiostats = true

function adshow.loadall ()
    loadingscreen = 
    {
        loadingscreen_1 = nil,
        loadingscreen_2 = nil,
        loadingscreen_3 = nil,
        loadingscreen_4 = nil,
        loadingscreen_5 = nil,
        status_         = 0,
        }    
    loadingscreen.loadingscreen_1 = display.newImageRect("background/loadingscreen.png",display.contentWidth,display.contentHeight)
    loadingscreen.loadingscreen_1:setReferencePoint(display.CenterReferencePoint)
    loadingscreen.loadingscreen_1.x = w_                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
    loadingscreen.loadingscreen_1.y = h_
    loadingscreen.loadingscreen_1.alpha = 0
    loadingscreen.loadingscreen_2 = display.newImageRect("background/load_1.png",display.contentWidth,display.contentHeight)
    loadingscreen.loadingscreen_2:setReferencePoint(display.CenterReferencePoint)
    loadingscreen.loadingscreen_2.x = w_
    loadingscreen.loadingscreen_2.y = h_    
    loadingscreen.loadingscreen_2.alpha = 0
    loadingscreen.loadingscreen_3 = display.newImageRect("background/load_2.png",display.contentWidth,display.contentHeight)
    loadingscreen.loadingscreen_3:setReferencePoint(display.CenterReferencePoint)
    loadingscreen.loadingscreen_3.x = w_
    loadingscreen.loadingscreen_3.y = h_
    loadingscreen.loadingscreen_3.alpha = 0
    loadingscreen.loadingscreen_4 = display.newImageRect("background/load_3.png",display.contentWidth,display.contentHeight)
    loadingscreen.loadingscreen_4:setReferencePoint(display.CenterReferencePoint)
    loadingscreen.loadingscreen_4.x = w_
    loadingscreen.loadingscreen_4.y = h_
    loadingscreen.loadingscreen_4.alpha = 0
    loadingscreen.loadingscreen_5 = display.newImageRect("background/load_4.png",display.contentWidth,display.contentHeight)
    loadingscreen.loadingscreen_5:setReferencePoint(display.CenterReferencePoint)
    loadingscreen.loadingscreen_5.x = w_
    loadingscreen.loadingscreen_5.y = h_
    loadingscreen.loadingscreen_5.alpha = 0
    
    loadingwid = widget.newSpinner
    {
        left = 0,
        top = 0,
        width = 100,
        height = 100,
        }
    loadingwid:setReferencePoint(display.CenterReferencePoint)
    loadingwid.x = display.contentWidth / 2
    loadingwid.y = display.contentHeight - 100
    loadingwid:start()  
    loadingwid.alpha = 0
    
    end

function adshow.loading (info)
    
    if info == "show" then
        local showing = math.random (1,5)
        if showing == 1 then
            loadingscreen.loadingscreen_1 = display.newImageRect("background/loadingscreen.png",display.contentWidth,display.contentHeight)
            loadingscreen.loadingscreen_1:setReferencePoint(display.CenterReferencePoint)
            loadingscreen.loadingscreen_1.x = w_                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
            loadingscreen.loadingscreen_1.y = h_
            loadingscreen.status_ = showing
        elseif showing == 2 then 
            loadingscreen.loadingscreen_2 = display.newImageRect("background/load_1.png",display.contentWidth,display.contentHeight)
            loadingscreen.loadingscreen_2:setReferencePoint(display.CenterReferencePoint)
            loadingscreen.loadingscreen_2.x = w_
            loadingscreen.loadingscreen_2.y = h_    
            loadingscreen.status_ = showing
        elseif showing == 3 then
            loadingscreen.loadingscreen_3 = display.newImageRect("background/load_2.png",display.contentWidth,display.contentHeight)
            loadingscreen.loadingscreen_3:setReferencePoint(display.CenterReferencePoint)
            loadingscreen.loadingscreen_3.x = w_
            loadingscreen.loadingscreen_3.y = h_
            loadingscreen.status_ = showing
        elseif showing == 4 then
            loadingscreen.loadingscreen_4 = display.newImageRect("background/load_3.png",display.contentWidth,display.contentHeight)
            loadingscreen.loadingscreen_4:setReferencePoint(display.CenterReferencePoint)
            loadingscreen.loadingscreen_4.x = w_
            loadingscreen.loadingscreen_4.y = h_
            loadingscreen.status_ = showing
        elseif showing == 5 then
            loadingscreen.loadingscreen_5 = display.newImageRect("background/load_4.png",display.contentWidth,display.contentHeight)
            loadingscreen.loadingscreen_5:setReferencePoint(display.CenterReferencePoint)
            loadingscreen.loadingscreen_5.x = w_
            loadingscreen.loadingscreen_5.y = h_
            loadingscreen.status_ = showing
            end
        loadingwid = widget.newSpinner
        {
            left = 0,
            top = 0,
            width = 100,
            height = 100,
            }
        loadingwid:setReferencePoint(display.CenterReferencePoint)
        loadingwid.x = display.contentWidth / 2
        loadingwid.y = display.contentHeight - 100
        loadingwid:start()  
    elseif info == "hide" then
        if loadingscreen.status_ == 1 then
            loadingscreen.loadingscreen_1:removeSelf()
            loadingscreen.loadingscreen_1 = nil
        elseif loadingscreen.status_ == 2 then
            loadingscreen.loadingscreen_2:removeSelf()
            loadingscreen.loadingscreen_2 = nil
        elseif loadingscreen.status_ == 3 then
            loadingscreen.loadingscreen_3:removeSelf()
            loadingscreen.loadingscreen_3 = nil
        elseif loadingscreen.status_ == 4 then
            loadingscreen.loadingscreen_4:removeSelf()
            loadingscreen.loadingscreen_4 = nil
        elseif loadingscreen.status_ == 5 then
            loadingscreen.loadingscreen_5:removeSelf()
            loadingscreen.loadingscreen_5 = nil
            end
        loadingwid:removeSelf()
        loadingwid = nil
        end
    
    end

adshow.sqlload = false

function adshow.loadsql  ()
    
    end

adshow.path = system.pathForFile("records.db", system.DocumentsDirectory )
file = io.open( adshow.path )
if( file == nil )then
    print("NO FILE")
    -- Doesn't Already Exist, So Copy it In From Resource Directory                          
    local pathSource     = system.pathForFile( "records.db", system.ResourceDirectory )  
    local fileSource = io.open( pathSource, "r" ) 
    local contentsSource = fileSource:read( "*a" )                                  
    --Write Destination File in Documents Directory                                  
    local pathDest = system.pathForFile( "records.db", system.DocumentsDirectory )                 
    local fileDest = io.open( pathDest, "w" )                 
    fileDest:write( contentsSource )                 
    -- Done                      
    io.close( fileSource )        
    io.close( fileDest )  
    
    
else
    print("FILE Already Exist")
    
    end

adshow.db = sqlite3.open( adshow.path )

local createTable = [[CREATE TABLE IF NOT EXISTS info (id INTEGER PRIMARY KEY, adstats );]]
adshow.db:exec (createTable )

adshow.ads = true
local sql = "SELECT * FROM info";
local row

for row in adshow.db:nrows(sql) do
    
    if tostring(row.adstats) == "true" then
        adshow.ads = true
        
    elseif tostring(row.adstat) == "false" then
        adshow.ads = false
        
        end
    
    end

local _H = display.contentHeight
local _W = display.contentWidth

local AMAZON_APK = false

local RevMob = require("luafile.revmob")                                        
local REVMOB_IDS = { ["Android"] = "51a6f392433111f6e90000f7", ["iPhone OS"] = "51a6f380433111f6e90000e8" }
if AMAZON_APK then REVMOB_IDS[REVMOB_ID_ANDROID] = '51a6f3a601858a2d7e0000e7' end
RevMob.startSession(REVMOB_IDS)
local banner_1 = nil

banner_1 = RevMob.createBanner({x = display.contentWidth / 2, y = _H - 50, width = _W, height = 100 })
banner_1:hide()
local banner_2 = nil
banner_2 = RevMob.createFullscreen()
banner_2:hide()
local banner_3 = nil
banner_3 = RevMob.createPopup()
banner_3:hide()


adshow.banner = true

function adshow.callrevmob (bansize)
    if adshow.ads == true then
        if bansize == "320x50" then
            if adshow.banner == false then
                banner_1 = RevMob.createBanner({x = display.contentWidth / 2, y = _H - 50, width = _W, height = 100 })
                banner_1:show()
                adshow.banner = true
            else
                banner_1:show()
            end
            
        elseif bansize == "fullscreen" then
            banner_2:show()
        elseif bansize == "showpop" then
            banner_3:show()
        elseif bansize == "hide" then
            banner_1:hide()
        elseif bansize == "open" then    
           --- RevMob.openlinking ()
            end
        end
    end

--local TOP = 1
--local CENTER = 2
--local BOTTOM = 3
--local LEFT = 1
--local RIGHT = 3  
--local tapfortap = require "plugin.tapfortap"
--tapfortap.initialize("8e57b002ff2dfd221b5bcf968f5fe221")
--tapfortap.prepareAppWall()
--local tapfor = false 

function adshow.calltapfortap (banshow)
    --    if tapfor == false then
    --        tapfor = true
    --    end
    --
    --    if banshow == "show" then
    --        tapfortap.createAdView(BOTTOM, CENTER, 0, 0, 1)
    --    elseif banshow == "hide" then
    --        tapfortap.removeAdView()
    --    elseif banshow == "appwall" then
    --        tapfortap.showAppWall()
    --    end
    
    end


function adshow.inapppurchase (addcoin)
    print(addcoin)
    end

--flurry 

local analytics = require "analytics"
local application_key
local environment = system.getInfo( "platformName" )
if environment == "simulator" then
    print( "You're in the simulator." )
elseif environment == "Android" then
    application_key = "VDZQ4KQXDTWZGSCK7VKZ"
elseif environment == "iPhone OS" then
    application_key = "9S8NM34YBGMZG3KCSKQT"
    end
analytics.init(application_key )

function adshow.callflurry (action,params)
    analytics.logEvent(action,params)
    end

local cb = require "ChartboostSDK.chartboost"
local cbdata = require "ChartboostSDK.chartboostdata"

local appId 
local appSignature 

local environment = system.getInfo( "platformName" )
print(environment)
if environment == "simulator" or environment == "Win" then
    appId = "524a3b8f17ba47435b000004"
    appSignature = "8a01f0b66289588a98726924827f154ff88d1f69"
elseif environment == "Android" then
    appId = "524a3b8f17ba47435b000004"
    appSignature = "8a01f0b66289588a98726924827f154ff88d1f69"
elseif environment == "iPhone OS" then
    appId = "524a3b8f17ba47435b000004"
    appSignature = "8a01f0b66289588a98726924827f154ff88d1f69"
    end

local delegate = {
        shouldRequestInterstitial = function(location) print("Chartboost: shouldRequestInterstitial " .. location .. "?"); return true end,
        shouldDisplayInterstitial = function(location) print("Chartboost: shouldDisplayInterstitial " .. location .. "?"); return true end,
        didCacheInterstitial = function(location) print("Chartboost: didCacheInterstitial " .. location); return end,
        didFailToLoadInterstitial = function(location) print("Chartboost: didFailToLoadInterstitial " .. location); return end,
        didDismissInterstitial = function(location) print("Chartboost: didDismissInterstitial " .. location); return end,
        didCloseInterstitial = function(location) print("Chartboost: didCloseInterstitial " .. location); return end,
        didClickInterstitial = function(location) print("Chartboost: didClickInterstitial " .. location); return end,
        didShowInterstitial = function(location) print("Chartboost: didShowInterstitial " .. location); return end,
        shouldDisplayLoadingViewForMoreApps = function() return true end,
        shouldRequestMoreApps = function() print("Chartboost: shouldRequestMoreApps"); return true end,
        shouldDisplayMoreApps = function() print("Chartboost: shouldDisplayMoreApps"); return true end,
        didCacheMoreApps = function() print("Chartboost: didCacheMoreApps"); return end,
        didFailToLoadMoreApps = function() print("Chartboost: didFailToLoadMoreApps"); return end,
        didDismissMoreApps = function() print("Chartboost: didDismissMoreApps"); return end,
        didCloseMoreApps = function() print("Chartboost: didCloseMoreApps"); return end,
        didClickMoreApps = function() print("Chartboost: didClickMoreApps"); return end,
        didShowMoreApps = function() print("Chartboost: didShowMoreApps"); return end,
        shouldRequestInterstitialsInFirstSession = function() return true end
    }

cb.create{appId = appId,
    appSignature = appSignature,
    delegate = delegate,
    appVersion = "1.0.5",
    appBundle = "eight.app.studio.aliendisruption"}

cb.startSession()
cb.cacheMoreApps()
cbdata.cacheInterstitialData("Default", function(response)
    local ad_id = response["ad_id"]
    local link = response.link
    print ("Success requesting ad: "..tostring(link))
    cbdata.showInterstitialData(ad_id, function(response)
        print("Success showing ad "..ad_id)
    end, function(error)
        print("Error showing: "..error)
        end)
end, function(error)
    print("Error requesting: "..error)
    end)



function adshow.showmore (adsinfo)
    if adsinfo == "more_games" then
        
        cb.showMoreApps()
        end
    end

--local playhaven = require("plugin.playhaven")

--local playhavenListener = function(event)
--
--end
--
--local init_options = {
--    token = "bd6ee3ec8be1412291025eca1a00bc03",
--    secret = "7593d0fb0ecd4eae8e62dfc88f682fd3",
--    closeButton = system.pathForFile("button/close/close.png", system.ResourceDirectory),
--    closeButtonTouched = system.pathForFile("button/close/closetap.png", system.ResourceDirectory)
--}
--
--playhaven.init(playhavenListener, init_options)

function adshow.callplayhaven (action)
    --    if action == "fullscreen" and adshow.ads == true then
    --        playhaven.contentRequest("interstitial", true)
    --    elseif action == "more_games" then
    --        playhaven.contentRequest("more_games", true)
    --    end
    end

local buyobjects = nil
function adshow.prestart (event)
        buyobjects = {}
    end

function adshow.storealert (limiter)
    local trueDestroy;
    local destroy
    
    function trueDestroy(toast)
        toast:removeSelf();
        toast = nil;
        end
    
    local function new(pText, pTime)
        
        local text = pText or "nil";
        local pTime = pTime;
        local toast = display.newGroup();
        
        toast.text                      = display.newText(toast, pText, 14, 12, native.systemFont, 20);
        toast.background                = display.newRoundedRect( toast, 0, 0, toast.text.width + 24, toast.text.height + 24, 16 );
        toast.background.strokeWidth    = 4
        toast.background:setFillColor(72, 64, 72)
        toast.background:setStrokeColor(96, 88, 96)
        
        toast.text:toFront();
        
        toast:setReferencePoint(toast.width*.5, toast.height*.5)
        --utils.maintainRatio(toast);
        toast.alpha = 0;
            toast.transition = transition.to(toast, {time=250, alpha = 1});
        
        if pTime ~= nil then
                timer.performWithDelay(pTime, function() destroy(toast) end);
            end
        
        toast.x = display.contentWidth * .5
        toast.y = display.contentHeight * .8
        
        return toast;
        end
    
    function destroy(toast)
            toast.transition = transition.to(toast, {time=250, alpha = 0, onComplete = function() trueDestroy(toast) end});
        end    
    new(limiter, 1500)
    end

return adshow