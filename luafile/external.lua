    local external = {}

external.adshow        = require "luafile.adshow"
external.widget        = require "widget"
external.sfx           = require "luafile.sfx"
external.sprite        = require "sprite"
external.spritefactory = require "luafile.spritefactory"
external.sqlite3       = require "sqlite3"
external.physics       = require "physics"
external.store         = require "store"

external.backmusic = true
audio.reserveChannels(1)
audio.reserveChannels(18)
audio.reserveChannels(19)
external.stage = 0

function external.transactionCallback( event )
    print("transactionCallback: Received event " .. tostring(event.name))
    print("state: " .. tostring(event.transaction.state))
    print("errorType: " .. tostring(event.transaction.errorType))
    print("errorString: " .. tostring(event.transaction.errorString))
    local productID= event.transaction.productIdentifier;
    if event.transaction.state == "purchased" then
        external.adshow.storealert ("Product Purchased: "..productID)
        local value = "false"
        local tablefill =[[INSERT INTO info VALUES (1,']] ..value.. [[');]]
        external.adshow.db:exec(tablefill)
        external.adshow.callflurry("remove ads")
        local function onComplete( event )
            if "clicked" == event.action then
                i = event.index
                if 1 == i then
                    native.requestExit() 
                elseif 2 == i then
                    
                    end
                end
            end 
        --alert = native.showAlert( "You Buy Product", "Need to Reopen the Game to removed ads", { "OK" }, onComplete )
        --native.showAlert("You Buy Product",productID, {"OK"})  
        external.adshow.ads = false
        external.adshow.callrevmob ("hide")
    elseif event.transaction.state == "restored" then
        external.adshow.storealert ("Product Restored", productID)
        value = "false"
        tablefill =[[INSERT INTO info VALUES (1,']] ..value.. [[');]]
        external.adshow.db:exec(tablefill)
        external.adshow.callflurry("remove ads")
        local function onComplete( event )
            if "clicked" == event.action then
                i = event.index
                if 1 == i then
                    native.requestExit() 
                elseif 2 == i then
                    
                    end
                end
            end 
        --alert = native.showAlert( "You Buy Product", "Need to Reopen the Game to removed ads", { "OK" }, onComplete )
        --native.showAlert("You Buy Product",productID, {"OK"})  
        external.adshow.ads = false
        external.adshow.callrevmob ("hide")
    elseif event.transaction.state == "refunded" then
        print("Product Refunded")
    elseif event.transaction.state == "cancelled" then
        print("Transaction cancelled")
    elseif event.transaction.state == "failed" then
        external.adshow.storealert ("Transaction Failed")
        external.adshow.callflurry("Transaction Failed")
    else
        external.adshow.storealert ("Some unknown event occured. This should never happen.")
        end
    external.store.finishTransaction( event.transaction )
    end

function external.loadproducts (store_use)
    if store_use == "apple" then
        external.products = "eight.app.studio.aliendisruption.myproductname4"
    elseif store_use == "google" then
        external.products = "eight.app.studio.aliendisruption.myproductname4"   
        end
    end            

-- Identifies the device and will initialize according to type.
if external.store.availableStores.apple then
    external.store.init("apple", external.transactionCallback)
    external.loadproducts ("apple")
elseif external.store.availableStores.google then
    external.store.init("google", external.transactionCallback)
    external.loadproducts ("google")
    end

function external.purchaseItem()
    -- make sure that your iOS and Google In-App Products has the same product ID
        external.store.restore( {"eight.app.studio.aliendisruption.myproductname4"})
    --    value = "false"
    --    tablefill =[[INSERT INTO info VALUES (1,']] ..value.. [[');]]
    --    external.adshow.db:exec(tablefill)
    --    print(tablefill)
    --    external.adshow.ads = false
    end

local gameNetwork = require( "gameNetwork" )
local playerName
external.eventtype = nil

function external.loadLocalPlayerCallback( event )
    playerName = event.data.alias
    
    if external.eventtype == "survival" then
        
    elseif external.eventtype == "mini-game" then
        
        end
    --saveSettings()  --save player data locally using your own "saveSettings()" function
    end

function external.gameNetworkLoginCallback( event )
        gameNetwork.request( "loadLocalPlayer", { listener=external.loadLocalPlayerCallback } )
        if not event.isError then
        --loggedIntoGC = true
        native.showAlert( "Success!", "", { "OK"} )

    else
        native.showAlert( "Failed!", event.errorMessage, {"OK"})
        print("Error Code: ", event.errorCode)
    end

    return true
    end

function external.gpgsInitCallback( event )
        gameNetwork.request( "login", { userInitiated=true, listener=external.gameNetworkLoginCallback } )
    end

function external.showLeaderboards(event )
    if ( system.getInfo("platformName") == "Android" ) then
        gameNetwork.show( "leaderboards" )
    else
            gameNetwork.show( "leaderboards", { leaderboard = {timeScope="AllTime"} } )
        end
    return true
    end

function external.showAchievements( event )
    gameNetwork.show( "achievements" )
    return true
    end

function external.gameNetworkSetup()
    if ( system.getInfo("platformName") == "Android" ) then
        gameNetwork.init( "google", external.gpgsInitCallback )
    else
        gameNetwork.init( "gamecenter", external.gameNetworkLoginCallback )
        end
    end


return external
