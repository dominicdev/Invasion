local external = {}

external.adshow        = require "luafile.adshow"
external.widget        = require "widget"
external.sfx           = require "luafile.sfx"
external.sprite        = require "sprite";
external.spritefactory = require "luafile.spritefactory";
external.sqlite3       = require "sqlite3"
external.physics       = require "physics";
external.store         = require "store";

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
                    local i = event.index
                    if 1 == i then
                    native.requestExit() 
                    elseif 2 == i then
                    
                    end
                end
            end 
          local alert = native.showAlert( "You Buy Product", "Need to Reopen the Game to removed ads", { "OK" }, onComplete )
        --native.showAlert("You Buy Product",productID, {"OK"})  
    elseif event.transaction.state == "restored" then
        print("Product Restored", productID)
    elseif event.transaction.state == "refunded" then
        print("Product Refunded")
    elseif event.transaction.state == "cancelled" then
        print("Transaction cancelled")
    elseif event.transaction.state == "failed" then
        external.adshow.storealert ("Transaction Failed")
        external.adshow.callflurry("Transaction Failed")
           local function onComplete( event )
                if "clicked" == event.action then
                    local i = event.index
                    if 1 == i then
                    native.requestExit() 
                    
                    elseif 2 == i then
                    
                    end
                end
            end 
          local alert = native.showAlert( "Transaction Failed", "Need to REOPEN the Game", { "YES" }, onComplete )
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

return external
