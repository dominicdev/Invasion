local external      = require "luafile.external"
local storyboard    = require "storyboard";
local scene         = storyboard.newScene();
local environment   = system.getInfo("environment")
local mastersprite  = {};
local laserbutton   = {};
local playexplode   = {};
local crackxplode   = {};
local spritesset    = {};
local deadtable     = {};
local callfence     = {};
local cardead       = {};
local nicehit       = {};
local designs       = {};
local master        = {};
local ticker        = {}; --ticker[21]
local carpow        = {};  --carpow[10]
local flash         = {};
local score         = {};
local level         = {}; --level[3]
local lives         = {}; --lives[3]
local carup         = {}; 
local sound         = {};
local group         = {}; --group[4]
local trans         = {};
local game          = {}; --game[6]
local bump          = {};
local dead          = {};
local time          = {};
local den           = {}; --start den[20] 
local w             = display.contentWidth / 2;
local h             = display.contentHeight / 2;
local boss          = nil
local bullet        = nil
local masternumbertable;
local carpowbutton;
local pausebutton;
local backobject;
local controller;
local directnum_;
local updateText;
local timecount;
local barelrep;
local functions = {}
local display_;
local numbers;
local counter;
local barrel;
local carrun; 
local mobrun;
local params;
local heart;
local human;
local tick2;
local tick;
local coin;
local bg;

local function none ()
print("NONE")
return true
end

function functions.notouch (event)
print(event.phase)

local function spritehuman (event)
    if event.phase == "end" then   
    event.sprite:removeSelf()
    event.sprite.myName = nil
    end
end
    
if event.phase == "began" then
    
    master[1].humanstats = false
    master[1].humanum = master[1].humanum + 1
    if event.target.id == "boy" then
        human[master[1].humanum] =  external.sprite.newSprite(external.spritefactory.spritedeadboy);   
        human[master[1].humanum]:prepare("dboy")     
    elseif event.target.id == "girl" then
        human[master[1].humanum] =  external.sprite.newSprite(external.spritefactory.spritedeadgirl);   
        human[master[1].humanum]:prepare("dgirl") 
    end
    
    human[master[1].humanum].x = event.target.x
    human[master[1].humanum].y = event.target.y
    
    human[master[1].humanum]:play()
    group[5]:insert(human[master[1].humanum]);
    human[master[1].humanum]:addEventListener("sprite",spritehuman)
    event.target:removeSelf()
    event.target.myName = nil
    event.target:removeEventListener("touch",functions.notouch)
    master[1].humanum = master[1].humanum + 1
    human[master[1].humanum] = display.newText("-1 Life",0,0,"BadaBoom BB",40)
    human[master[1].humanum].x = event.target.x
    human[master[1].humanum].y = event.target.y
    human[master[1].humanum]:setTextColor (255, 255, 255)
    group[5]:insert(human[master[1].humanum])
    local function deletetext_ (objecttxt)
        objecttxt:removeSelf()
        objecttxt = nil
    end
    transition.to(human[master[1].humanum],{time = 2000,y=human[master[1].humanum].y - 70,onComplete = deletetext_})
    heart[lives[3]]:removeSelf()
    lives[3] = lives[3] - 1
    audio.play(external.sfx.humanfail)
    if lives[3] == -1 then
    lives[3] = 0
    elseif lives[3] == 0 then
    functions.gameoverscreen()
    ticker[15] = true
    carpow[4] = true
    carpow[5] = true
    end
    updateText()
end

end

function functions.runninghumen ()
    

master[1].humanum = master[1].humanum + 1
local humanused = math.random(1,2)
if humanused == 1 then
    audio.play(external.sfx.boy)
    human[master[1].humanum] =  external.sprite.newSprite(external.spritefactory.spriteboy);
    human[master[1].humanum]:prepare("boy")  
    human[master[1].humanum].id = "boy"
elseif humanused == 2 then
    audio.play(external.sfx.girl)
    human[master[1].humanum] =  external.sprite.newSprite(external.spritefactory.spritegirl);
    human[master[1].humanum]:prepare("girl")  
    human[master[1].humanum].id = "girl"   
end
human[master[1].humanum].x = (math.random(50,(display.contentWidth - 150)))
human[master[1].humanum].y = -40
human[master[1].humanum]:play()

external.physics.addBody(human[master[1].humanum],{density = den[5] , bounce = 0,firction = 0,isSensor = false})
human[master[1].humanum].isFixedRotation = true
human[master[1].humanum].myName = "human"
group[5]:insert(human[master[1].humanum]);
human[master[1].humanum]:addEventListener("touch",functions.notouch)
master[1].humanstats = true

end

function ending ()
print("end")
end

function functions.shakingeffect ()
    
local stage = display.getCurrentStage()
local originalX = stage.x
local originalY = stage.y
local moveRightFunction
local moveLeftFunction
local rightTrans
local leftTrans
local originalTrans
local shakeTime = 80
local shakeRange = {min = 1, max = 3}
local endShake   	

moveRightFunction = function(event) rightTrans = transition.to(stage, {x = math.random(shakeRange.min,shakeRange.max), y = math.random(shakeRange.min, shakeRange.max), time = shakeTime, onComplete=moveLeftFunction}); end 
 
moveLeftFunction = function(event) leftTrans = transition.to(stage, {x = math.random(shakeRange.min,shakeRange.max) * -1, y = math.random(shakeRange.min,shakeRange.max) * -1, time = shakeTime, onComplete=endShake});  end 

moveRightFunction();

endShake = function(event) originalTrans = transition.to(stage, {x = originalX, y = originalY, time = 100}); end

end

function functions.onSceneTouch (event)

local switch = event.target

    if switch.id == "restart" then
        local option = 
            {
            effect = "fade",
            time = 400,
            params = 
                {
                    soundv = params.soundv,
                }
            }
            storyboard.gotoScene( "luafile.restart",option)
    elseif switch.id == "quit_1" then
       local scenefrom = 
            {
                effect = "fade",
                time = 1000,
                params = 
                {
                    scenename = "game"
                }
            }
            storyboard.gotoScene( "luafile.menu",scenefrom )
            
    elseif switch.id == "quit_2" then
        local stats = 
                {
                    effect = "fade",
                    time   = 300,
                    params = 
                    {
                        uscore  = score[2],
                        utime   = time[2],
                        ucar    = carup[2],
                        ubarrel = barrel[10],
                        ulevel  = level[2],
                        ulaser  = carup[11],
                        ucoin   = coin,
                        gametype    = "survival",
                        
                    }
                }
        storyboard.gotoScene( "luafile.records",stats)
    end
end

function functions.callfenceslevel ()
lives[2] = 6  
callfence[1]   = external.sprite.newSprite(external.spritefactory.spritefence);
callfence[1].x = w;
callfence[1].y = h + 130;
callfence[1]:prepare("fence1");
callfence[1]:play();
external.physics.addBody(callfence[1],"static",{density = 1, bounce = 0,isSensor = true});
callfence[1].myName = "remove";
group[2]:insert(callfence[1]);
callfence[2] = false;

end

local function spriteListener_ (event)
    if event.phase == "end" then   
    event.sprite:removeSelf()
    end
end

function functions.crackentouch (event)
    
local object = event.target
if event.phase == "began" then
    object.damage = object.damage - 1
    audio.play(external.sfx.sound_2 ,{channel = 1})
    numbers.crackernum = numbers.crackernum + 1;
    flash[numbers.crackernum] = external.sprite.newSprite(external.spritefactory.spriteflash)
    flash[numbers.crackernum].x = event.target.x
    flash[numbers.crackernum].y = event.target.y
    flash[numbers.crackernum]:prepare("flash")
    flash[numbers.crackernum]:play()
    group[3]:insert(flash[numbers.crackernum])
    flash[numbers.crackernum]:addEventListener( "sprite", spriteListener_ )

    if object.damage == 0 then
        crackxplode[1] = crackxplode[1] + 1
        local cracknum = crackxplode[1]
        audio.play(external.sfx.sound_1)
        spritesset[14] = false
        crackxplode[cracknum] = external.sprite.newSprite(external.spritefactory.spritexplode)
        crackxplode[cracknum].x = object.x
        crackxplode[cracknum].y = object.y
        crackxplode[cracknum]:prepare("explode")
        crackxplode[cracknum]:play()
        group[2]:insert(crackxplode[cracknum])
        crackxplode[cracknum]:addEventListener( "sprite", spriteListener_ )
        event.target.id = nil
        object:removeSelf()
        group[2]:remove(object)
        score[2] = score[2] + 200
    end
audio.stop( sound[15])
    if object.damage == -1 then
        object.damage = 0
    end
end
    
end

function functions.cracken ()
level[6].num_ = level[6].num_ + 1
if level[6].num_ == 4 then
    level[6].bol_ = false
    level[6].num_ = 0
    level[6].time_ = nil
end

spritesset[14] = true  
spritesset[13] = external.sprite.newSprite(external.spritefactory.boss_2)
spritesset[13] :prepare("boss_2")
spritesset[13] .x = (math.random(50,(display.contentWidth - 50)))
spritesset[13] .y = -100
spritesset[13] :play()

sound[15] = audio.play( external.sfx.sound_14, {channel = 32,loops=2 }  )
external.physics.addBody(spritesset[13],"statc",{density  = 0.1,bounce = 0,friction = 0,isSensor = true})
spritesset[15] = transition.to(spritesset[13], {y = display.contentHeight + 50, time = 15000})
spritesset[16] = timer.performWithDelay(15000, ending, 1)
spritesset[13] .myName = "cracken"
spritesset[13] .id = "cracken"
spritesset[13] .damage = den[12]
spritesset[13]:addEventListener("touch",functions.crackentouch)
spritesset[13].isFixedRotation = true
group[2]:insert(spritesset[13])

end

function functions.move_4 (moves_4)
    
backobject = moves_4
trans[6].id_4 = false
trans[4] = transition.to(moves_4,{y = h + 200, time = 1000})
trans[6].id_5 = true
end

function functions.move_3 (moves_3)
    
backobject = moves_3
trans[6].id_3 = false
trans[3] = transition.to(moves_3,{x = (math.random(50,(display.contentWidth - 50))),y = h - 100 , time = 1800, onComplete = functions.move_4})
trans[6].id_4 = true
end

function functions.move_2 (moves_2)
    
trans[6].id_2 = false
backobject = moves_2
local directnum = math.random(1,3)
if directnum == 1 then
 trans[2] = transition.to(moves_2,{x = w + 220,y = h - 200 , time = 2000, onComplete = functions.move_3})      
elseif directnum == 2 then
 trans[2] = transition.to(moves_2,{x = w - 220,y = h - 200 , time = 2000, onComplete = functions.move_3})      
elseif directnum == 3 then
 trans[2] = transition.to(moves_2,{x = (math.random(50,(display.contentWidth - 50))),y = math.random(h - 200) , time = 4000, onComplete = functions.move_3})      
end
trans[6].id_3 = true
end

function functions.move_1 (moves_1)
    
trans[6].id_1 = false
backobject = moves_1
local directnum = math.random(1,3)
if directnum == 1 then
 trans[1] = transition.to(moves_1,{x = w - 220, time = 2000, onComplete = functions.move_2})   
elseif directnum == 2 then
 trans[1] = transition.to(moves_1,{x = w + 220, time = 2000, onComplete = functions.move_2})
elseif directnum == 3 then
trans[1] = transition.to(moves_1,{x = (math.random(50,(display.contentWidth - 50))), time = 2000, onComplete = functions.move_2}) 
end
trans[6].id_2 = true
end


function functions.removerunner(event) -- REMOVEmaster

local bossing = event.target
local x1 = bossing.x
local y1 = bossing.y

if event.phase == "began" then
    bossing.damage = bossing.damage - 1
    audio.play(external.sfx.sound_2)
    numbers.flasnum = numbers.flasnum + 1;
    flash[numbers.flasnum] = external.sprite.newSprite(external.spritefactory.spriteflash)
    flash[numbers.flasnum].x = x1
    flash[numbers.flasnum].y = y1
    flash[numbers.flasnum]:prepare("flash")
    flash[numbers.flasnum]:play()
    group[9]:insert(flash[numbers.flasnum])
    flash[numbers.flasnum]:addEventListener( "sprite", spriteListener_ )
    if bossing.damage == 0 then
        if boss.bol_ == true then
            transition.cancel(boss.move_)
            timer.cancel(boss.timer_)
            boss.bol_ = false 
        end
        if boss.bol_1 == true then
            transition.cancel(boss.move_1)
            timer.cancel(boss.timer_1)
            boss.bol_1 = false 
        end
        if boss.bol_2 == true then
            transition.cancel(boss.move_2)
           timer.cancel(boss.timer_2)
           boss.bol_2 = false 
        end
        numbers.deadnum = numbers.deadnum + 1
        score[2] = score[2] + 500
        dead[numbers.deadnum] = external.sprite.newSprite(external.spritefactory.spritexplode)
        dead[numbers.deadnum].x = x1
        dead[numbers.deadnum].y = y1
        dead[numbers.deadnum]:prepare("explode")  
        dead[numbers.deadnum]:play()
        group[7]:insert(dead[numbers.deadnum])
        dead[numbers.deadnum]:addEventListener( "sprite", spriteListener_ )
        event.target:removeSelf() 
        event.target.myName = nil
        audio.play(external.sfx.sound_1)
        boss.stats_ = false
    elseif bossing.damage == -1 then
        bossing.damage = 0
    end
end
end

function functions.firingboss (xloc,yloc)
    bullet.num = bullet.num + 1
    bullet[bullet.num] = display.newImageRect("items/ammu.png",18,18)
    bullet[bullet.num].x = xloc
    bullet[bullet.num].y = yloc + (bullet[bullet.num].height + 50)
    bullet[bullet.num].myName = "bullet"
    external.physics.addBody(bullet[bullet.num],{isSensor = true})
    bullet[bullet.num]:applyForce(0,10, bullet[bullet.num].x, bullet[bullet.num].y)
    group[6]:insert(bullet[bullet.num])
end

function functions.move2 (object_2)
boss.locy = math.random(1,5)
boss.bol_1 = false
if boss.locy == 1 then
    boss.move_2 = transition.to(object_2,{time = boss.time_1,x = display.contentWidth / 2,onComplete = functions.move1}) 
elseif boss.locy == 2 then
    boss.move_2 = transition.to(object_2,{time = boss.time_1,x = (display.contentWidth / 2)  + (display.contentWidth*.25),onComplete = functions.move1}) 
elseif boss.locy == 3 then    
    boss.move_2 = transition.to(object_2,{time = boss.time_1,x = (display.contentWidth / 2)  - (display.contentWidth*.25),onComplete = functions.move1}) 
elseif boss.locy == 4 then
    boss.move_2 = transition.to(object_2,{time = boss.time_1,x = (display.contentWidth / 2)  + (display.contentWidth*.25) + (display.contentWidth*.125),onComplete = functions.move1}) 
elseif boss.locy == 5 then    
    boss.move_2 = transition.to(object_2,{time = boss.time_1,x = (display.contentWidth / 2)  - (display.contentWidth*.25) - (display.contentWidth*.125),onComplete = functions.move1}) 
end
boss.timer_2 = timer.performWithDelay (boss.time_1,none,1)
boss.bol_2 = true
boss.locv  = math.random(1,3)
    if boss.locv == 1 then
    elseif boss.locv == 2 then 
        functions.firingboss (object_2.x,object_2.y)
    elseif boss.locv == 3 then 
    end
print("wtf_2")
end

function functions.move1 (object_1)
boss.locx = math.random(1,5)
boss.bol_2 = false
boss.bol_ = false
if boss.locx == 1 then
    boss.move_1 = transition.to(object_1,{time = boss.time_1,x = display.contentWidth / 2,onComplete = functions.move2}) 
elseif boss.locx == 2 then
    boss.move_1 = transition.to(object_1,{time = boss.time_1,x = (display.contentWidth / 2)  + (display.contentWidth*.25),onComplete = functions.move2}) 
elseif boss.locx == 3 then    
    boss.move_1 = transition.to(object_1,{time = boss.time_1,x = (display.contentWidth / 2)  - (display.contentWidth*.25),onComplete = functions.move2}) 
elseif boss.locx == 4 then
    boss.move_1 = transition.to(object_1,{time = boss.time_1,x = (display.contentWidth / 2)  + (display.contentWidth*.25) + (display.contentWidth*.125),onComplete = functions.move2}) 
elseif boss.locx == 5 then    
    boss.move_1 = transition.to(object_1,{time = boss.time_1,x = (display.contentWidth / 2)  - (display.contentWidth*.25) - (display.contentWidth*.125),onComplete = functions.move2}) 
end
boss.timer_1 = timer.performWithDelay (boss.time_1,none,1)
boss.bol_1 = true
boss.locv  = math.random(1,5)
    if boss.locv == 1 then

    elseif boss.locv == 2 then 
        functions.firingboss (object_1.x,object_1.y)
    elseif boss.locv == 3 then 
        functions.firingboss (object_1.x,object_1.y)
    elseif boss.locv == 4 then 
    elseif boss.locv == 5 then 
    end
print("wtf_1")
end

function functions.start()
boss.num = boss.num + 1
boss[boss.num] = external.sprite.newSprite(external.spritefactory.boss_1);
boss[boss.num]:setReferencePoint(display.CenterReferencePoint)
boss.locz = math.random(1,3)
if boss.locz == 1 then
boss[boss.num].x = display.contentWidth / 2
elseif boss.locz == 2 then
boss[boss.num].x = (display.contentWidth / 2)  + (display.contentWidth*.25)
elseif boss.locz == 3 then    
boss[boss.num].x = (display.contentWidth / 2)  - (display.contentWidth*.25)
end
boss[boss.num].y = -10
boss[boss.num]:prepare("boss_1"); 
boss[boss.num]:play()  
boss[boss.num].myName = "bossing"
boss[boss.num].damage = 5
boss[boss.num]:addEventListener("touch",functions.removerunner)
group[8]:insert(boss[boss.num])
boss.move_ = transition.to(boss[boss.num],{time = boss.time_1,y = display.contentHeight*.25,onComplete = functions.move1})
boss.timer_ = timer.performWithDelay (boss.time_1,none,1)
boss.bol_ = true
boss.stats_ = true
boss.starting = false
end

function scene:createScene ( event )
group[1] = self.view
params = event.params
bg = display.newImageRect("background/Lvl_1.png",display.contentWidth + 20,display.contentHeight + 20)
bg:setReferencePoint(display.CenterReferencePoint)  
bg.x = w
bg.y = h
group[1]:insert(bg)

end

function scene:willEnterScene( event )
group[1] = self.view
local value = event.params

group[2] = display.newGroup(); group[3] = display.newGroup();
group[4] = display.newGroup(); group[5] = display.newGroup();
group[6] = display.newGroup(); group[7] = display.newGroup();
group[8] = display.newGroup(); group[9] = display.newGroup(); 

directnum_        = false
tick2             = 1500;
masternumbertable = 0;
lives[2]          = 6;
level[5]          = 0;
barrel            = {};
mobrun            = {};
carrun            = {};
barelrep          = {};
human             = {};
heart             = {};

numbers       = {
        barrelbacknum = 0,
        lasernumber   = 1,
        cardeadnum    = 1,
        nicehitnum    = 1,
        numbermobs    = 0,
        crackernum    = 0,
        carrunnum     = 0,
        mobcount      = 0,
        barelnum      = 0,
        flasnum       = 0,
        deadnum       = 1,
        loop          = 0,
        deadmon       = 0,
            };


master[1] = {
        stats  = false;
        stats2 = false;
        humanstats = false,
        humanum= 0,
        humantime = 0,
            };    
master[2] = {
        number  = 0;
        deadnum = 0;
        
            };
            
trans[6] = {
        id_1 = false;
        id_2 = false;
        id_3 = false;
        id_4 = false;
        id_5 = false;
        id_6 = nil,
        id_7 = nil,
            };
level[6] = {
        time_   = nil,
        time_2  = nil,
        bol_    = false,
        num_    = 0,
        wavestats = false,
            };
display_ = {
        dark            = nil,
        fogleft         = nil,
        fogright        = nil,
        earlynight      = nil,
        lateafternoon   = nil,
        num             = 0,
        darkbol         = false,
        fogleftbol      = false,
        fogrightbol     = false,
        earlynightbol   = false,
        lateafternoonbol= false
            };

coin       = value.coin_;
tick       = value.tick_;
time[4]    = value.time_;
carup[2]   = value.car_;
lives[3]   = 5;
score[2]   = value.score_;
level[2]   = value.wave_;
carup[11]  = value.laser_;
barrel[10] = value.barrel_;
level[4]   = level[2]
time[2]    = 3; 
flash[2]   = 1;  
carpow[7]  = 1; 
carpow[6]  = 1;
carpow[8]  = 1; 
carpow[9]  = 1;
ticker[3]  = 1; 
ticker[1]  = 0;
ticker[2]  = 0; 
ticker[20] = 3000;
crackxplode[1] = 1 ; 

carpow[3]       = false;
carpow[4]       = false;
carpow[5]       = false; 
ticker[9]       = false;
ticker[14]      = false;
ticker[15]      = false;
ticker[21]      = false; 
ticker[22]      = false;
ticker[23]      = false;
spritesset[14]  = false;

den[1]  = 1; 
den[2]  = 2;
den[3]  = 3; 
den[4]  = 4;
den[11] = 2; 
den[12] = 5;
den[15] = .5;       

boss = {
            num         = 0,
            time_1      = 1000,
            move_       = nil,
            move_1      = nil,
            move_2      = nil,
            bol_        = false,
            bol_1       = false,
            bol_2       = false,
            pause       = false,
            timer_      = nil,
            timer_1     = nil,
            timer_2     = nil,
            timepause   = nil,
            timepause_1 = nil,
            timepause_2 = nil,
            locx        = nil,
            locy        = nil,
            locz        = nil,
            locv        = nil,
            stats_      = false,
            starting    = false,
            starttime   = nil,
            }
bullet =  {
            num = 0,
            }  
end

function scene:enterScene ( event )
group[1] = self.view
numbers.crackernum = 0  
--physics.setDrawMode("hybrid")
if environment == "simulator" then
print("You're in the simulator.")
else 
system.activate("multitouch")
end

local gamestatus = false;
local isPaused   = false;
external.physics.start()
external.physics.setGravity(0,1.5)
params = event.params

time[3] = display.newText(" ", 0, 0,"Agent Orange", 80)
time[3]:setReferencePoint(display.CenterReferencePoint)
time[3].x = w
time[3].y = h

level[1] = display.newText(" ", 0, 0,"Dimitri Swank", 60)
level[1]:setReferencePoint(display.CenterReferencePoint)
level[1].y = h - 260
level[1]:setTextColor(255, 204, 0)

storyboard.purgeAll()
storyboard.removeAll()

local function newText()
    
gamestatus = true
sound[16] = audio.play( external.sfx.sound_13,{loops= -1,channel = 18} )

local house_ = display.newRect(0, 0, w - 50, 10)
house_:setReferencePoint(display.CenterReferencePoint)
house_.x = w - 180;
house_.y = display.contentHeight - 110;
external.physics.addBody(house_,"static",{density = 1, bounce = 0});
house_.myName = "end"
house_.alpha = 0
group[3]:insert(house_)

local house_1 = display.newRect(0, 0, w + 30, 10)
house_1:setReferencePoint(display.CenterReferencePoint)
house_1.x = w + 140;
house_1.y = display.contentHeight - 40;
external.physics.addBody(house_1,"static",{density = 1, bounce = 0});
house_1.myName = "end"
house_1.alpha = 0
group[3]:insert(house_1)

for r = 1, 6 , 1 do
    if r == 1 then
        designs[r] = display.newImage("items/tress.png", 0, 0)
        designs[r].x = w + 50
    elseif r == 2 then
        designs[r] = display.newImage("items/tress.png", 0, 0)
        designs[r].x = w - 50
    elseif r == 3 then
        designs[r] = display.newImage("items/tress.png", 0, 0)
        designs[r].x = w + 150
    elseif r == 4 then
        designs[r] = display.newImage("items/tress.png", 0, 0)
        designs[r].x = w - 150
    elseif r == 5 then
        designs[r] = display.newImage("items/tress.png", 0, 0)
        designs[r].x = w + 250
    elseif r == 6 then
        designs[r] = display.newImage("items/tress.png", 0, 0)
        designs[r].x = w - 250
    end
designs[r].y = 30
group[7]:insert(designs[r])
end
local x_ = 0
local y_ = 0

for q = 1 , lives[3] ,1 do
    
    heart[q] = display.newImageRect("items/heart.png", 25, 25)
    if q >= 7 then
    y_ = y_ + 30
    heart[q].x = 30 + y_   
    heart[q].y = display.contentHeight - 20; 
    else
    x_ = x_ + 30
    heart[q].x = 30 + x_
    heart[q].y = display.contentHeight - 50;
    end
group[7]:insert(heart[q])
end

lives[1]   = display.newText("Lives: "..lives[3], 0, 0, "Consolas", 30);
lives[1]:setReferencePoint(display.CenterLeftReferencePoint);
lives[1].x = 50;
lives[1].y = display.contentHeight - 50;
lives[1].alpha = 0

level[3]   = display.newText("Wave: "..level[2],0,0,"Consolas",30);
level[3]:setReferencePoint(display.CenterLeftReferencePoint);
level[3].x = 50;
level[3].y = display.contentHeight - 80;

time[1]   = display.newText("Time: "..time[2],0,0,"Consolas", 32);
time[1]:setReferencePoint(display.CenterLeftReferencePoint);
time[1].x = w - 300;
time[1].y = 40;
time[1].alpha = 0

score[1]   = display.newText("Score: "..score[2], 0, 0, "BadaBoom BB", 32);
score[1]:setReferencePoint(display.CenterLeftReferencePoint);
score[1].x = w - 300;  
score[1].y = 40;

carup[1]   = display.newText("x"..carup[2],  0, 0, "BadaBoom BB", 25); -- car
carup[1]:setReferencePoint(display.TopRightReferencePoint);
carup[1].x = display.contentWidth - 10;
carup[1].y = h + (h/2) + 55;

carup[10]   = display.newText("x"..carup[11], 0, 0, "BadaBoom BB", 25); --laser
carup[10]:setReferencePoint(display.TopRightReferencePoint);
carup[10].x = display.contentWidth - 10;
carup[10].y = h + (h/2) - 13;

barrel[11]   = display.newImageRect("button/barrelbut/barreltap.png", 55, 60)
barrel[11]:setReferencePoint(display.CenterReferencePoint)
barrel[11].x = display.contentWidth - 60;
barrel[11].y = h + (h/2) + 120;

barrel[12]   = display.newText("x"..barrel[10],  0, 0, "BadaBoom BB", 25); -- barrel
barrel[12]:setReferencePoint(display.TopRightReferencePoint);
barrel[12].x = display.contentWidth - 10;
barrel[12].y = h + (h/2) + 120;

for k = 1,7,1 do
barrel[k]   = display.newImageRect("button/barrelbut/barrel.png", 64, 64);
barrel[k].y = h + 60;

if k == 1 then
    barrel[k].x = w;
elseif k == 2 then
    barrel[k].x = w - 100;
elseif k == 3 then
    barrel[k].x = w + 100;
elseif k == 4 then
    barrel[k].x = w - 190;
elseif k == 5 then
    barrel[k].x = w + 190;
elseif k == 6 then
    barrel[k].x = w + 290;
elseif k == 7 then
    barrel[k].x = w - 290;
end

external.physics.addBody(barrel[k],"static",{density  = 0,bounce = 0,friction = 0,isSensor = true});
barrel[k].myName = "barrel";
barrel[k].id = "barrel #"..k;
group[3]:insert(barrel[k]);
end

callfence[1] = external.sprite.newSprite(external.spritefactory.spritefence);
callfence[1]:prepare("fence1");
callfence[1].x = w;
callfence[1].y = h + 130;
callfence[1]:play();
external.physics.addBody(callfence[1],"static",{density = 1, bounce = 0,isSensor = true});
callfence[1].myName = "remove";
callfence[2] = false;
group[2]:insert(callfence[1]);

time[1]   :setTextColor(255, 255, 53);
level[3]  :setTextColor(255, 204, 51);
lives[1]  :setTextColor(255, 204, 51);
score[1]  :setTextColor(255, 204, 51);
carup[1]  :setTextColor(255, 204, 51);
carup[1]  :setTextColor(255, 255, 255);
carup[10] :setTextColor(255, 255, 255);
barrel[12]:setTextColor(255, 255, 255);

group[8]:insert(time[1]);
group[8]:insert(level[3]);
group[9]:insert(score[1]);
group[8]:insert(lives[1]);
group[3]:insert(carup[1]);
group[3]:insert(carup[10]);
group[8]:insert(barrel[11]);
group[3]:insert(barrel[12]);

transition.to(carpowbutton,{alpha = 1,time = 600});
transition.to(pausebutton,{alpha = 1,time = 600});
transition.to(laserbutton[numbers.lasernumber],{alpha = 1,time = 600});
transition.to(trans[6].id_6,{alpha = 0.6,time = 600});
transition.to(trans[6].id_7,{alpha = 1,time = 600});

end

function updateText(event)
     
lives[1].text = "Lives: "..lives[3]
lives[1]:setReferencePoint(display.CenterLeftReferencePoint)
lives[1].x = 50

level[3].text = "Wave: "..level[2]
level[3]:setReferencePoint(display.CenterLeftReferencePoint)
level[3].x = 50    
    
carup[1].text = "x"..carup[2]
carup[1]:setReferencePoint(display.TopRightReferencePoint)
carup[1].x = display.contentWidth - 10;

barrel[12].text = "x"..barrel[10]
barrel[12]:setReferencePoint(display.TopRightReferencePoint)
barrel[12].x = display.contentWidth - 10;

carup[10].text   = "x"..carup[11] 
carup[10]:setReferencePoint(display.TopRightReferencePoint);
carup[10].x = display.contentWidth - 10;

score[1].text = "Score: "..score[2]
score[1]:setReferencePoint(display.CenterLeftReferencePoint)
score[1].x =  w - 300;  

end

trans[6].id_6 = display.newRect(0,0,320,10)
trans[6].id_6:setReferencePoint(display.CenterLeftReferencePoint)
trans[6].id_6.x = display.contentWidth / 2 - 60
trans[6].id_6.y = display.contentHeight - 25
trans[6].id_6:setFillColor(255, 153, 0)
trans[6].id_6.alpha = 0
group[3]:insert(trans[6].id_6);

trans[6].id_7 = display.newImageRect("button/icon/smallship.png",60,60)
trans[6].id_7:setReferencePoint(display.CenterReferencePoint)
trans[6].id_7.x = display.contentWidth - 60
trans[6].id_7.y = display.contentHeight - 30
trans[6].id_7.alpha = 0
group[3]:insert(trans[6].id_7);
local o1 = 0

local function gametime (event)
    
time[1].text = "Time: "..time[2]
time[1]:setReferencePoint(display.CenterLeftReferencePoint)
time[1].x = w - 300

if level[6].wavestats == true then
trans[6].id_7.x = display.contentWidth - 60   
level[6].wavestats = false
trans[6].id_6.width = 320
trans[6].id_6:setReferencePoint(display.CenterLeftReferencePoint)
trans[6].id_6.x = display.contentWidth / 2 - 60
else
trans[6].id_7.x = trans[6].id_7.x - 2.5
trans[6].id_6.width = trans[6].id_6.width - 2.5
trans[6].id_6:setReferencePoint(display.CenterLeftReferencePoint)
trans[6].id_6.x = display.contentWidth / 2 - 60
end

master[1].humantime = master[1].humantime + 1

if master[1].humantime == 20 then
functions.runninghumen ()    
master[1].humantime = 0    
end

end

local function fancestatus()
if lives[2] == 4 then
    callfence[1]:prepare("fence2")
    callfence[1].x = w
    callfence[1].y = h + 130;
    callfence[1]:play()
elseif lives[2] == 2 then
    callfence[1]:pause()
    callfence[1]:prepare("fence3")
    callfence[1].x = w
    callfence[1].y = h + 130;
    callfence[1]:play()
elseif lives[2] == 0 then
    callfence[1]:removeSelf()
    callfence[2] = true
end
end

local function removebump (bumpobject)
    if carpow[5]  == false then
    bumpobject:removeSelf()
    bumpobject = nil 
    end
end

local function removecar (carobject)
if carpow[5]  == false then
    if carobject.id ~= nil then
        carobject.id = nil
        carobject:removeSelf()
        carobject = nil
    end
end
ticker[14] = false
end
local function removecarpow (carobjectpow)
    audio.stop({channel = 19})
    if carpow[5]  == false then
    carobjectpow.id = nil
    carobjectpow:removeSelf()
    carobjectpow  = nil
    end
    carpow[4]  = false
    carpow[3]  = false
    ticker[14] = false 
end

local function carrunning (event)
ticker[14]= true
ticker[22] = true
numbers.carrunnum  = numbers.carrunnum + 1
local carnum =  math.random(1,4)
carrun[numbers.carrunnum] = external.sprite.newSprite(external.spritefactory.spritecar)
carrun[numbers.carrunnum].rotation = 0

if carnum == 1 then
    carrun[numbers.carrunnum]:setReferencePoint(display.CenterLeftReferencePoint);
    carrun[numbers.carrunnum].x = w + 300
    carrun[numbers.carrunnum].y = h - 50
    carrun[numbers.carrunnum]:prepare("car1")
    carrun[numbers.carrunnum]:play()
    bump[numbers.carrunnum] = display.newRect( 0, 0, 16, 70)
    bump[numbers.carrunnum]:setReferencePoint(display.CenterLeftReferencePoint);
    bump[numbers.carrunnum].x = carrun[numbers.carrunnum].x - 20
    bump[numbers.carrunnum].y = carrun[numbers.carrunnum].y
    bump[numbers.carrunnum].id = "bump "..numbers.carrunnum
    ticker[16] = w - 600
    ticker[17] = w - 600
    audio.play(external.sfx.sound__3,{channel = 11 })
elseif carnum == 2 then
    carrun[numbers.carrunnum]:setReferencePoint(display.CenterRightReferencePoint);
    carrun[numbers.carrunnum] .x = w - 500
    carrun[numbers.carrunnum] .y = h - 50
    carrun[numbers.carrunnum] :prepare("car2")
    carrun[numbers.carrunnum] :play()
    bump[numbers.carrunnum] = display.newRect( 0, 0, 16, 70)
    bump[numbers.carrunnum]:setReferencePoint(display.CenterRightReferencePoint);
    bump[numbers.carrunnum].x = carrun[numbers.carrunnum].x + 20
    bump[numbers.carrunnum].y = carrun[numbers.carrunnum].y
    bump[numbers.carrunnum].id = "bump "..numbers.carrunnum
    ticker[16] = w + 600
    ticker[17] = w + 600
    audio.play(external.sfx.sound_3,{channel = 12 })
elseif carnum == 3 then
    carrun[numbers.carrunnum]:setReferencePoint(display.CenterLeftReferencePoint);
    carrun[numbers.carrunnum] .x = w + 300
    carrun[numbers.carrunnum] .y = h - 250
    carrun[numbers.carrunnum] :prepare("car3")
    carrun[numbers.carrunnum] :play()
    bump[numbers.carrunnum] = display.newRect( 0, 0, 16, 70)
    bump[numbers.carrunnum]:setReferencePoint(display.CenterLeftReferencePoint);
    bump[numbers.carrunnum].x = carrun[numbers.carrunnum].x - 20
    bump[numbers.carrunnum].y = carrun[numbers.carrunnum].y
    bump[numbers.carrunnum].id = "bump "..numbers.carrunnum
    ticker[16] = w - 600
    ticker[17] = w - 600
    audio.play(external.sfx.sound_3,{channel = 13 })
elseif carnum == 4 then
    carrun[numbers.carrunnum]:setReferencePoint(display.CenterRightReferencePoint);
    carrun[numbers.carrunnum] .x = w - 500
    carrun[numbers.carrunnum] .y = h - 250
    carrun[numbers.carrunnum] :prepare("car4")
    carrun[numbers.carrunnum] :play()  
    bump[numbers.carrunnum] = display.newRect( 0, 0, 16, 70)
    bump[numbers.carrunnum]:setReferencePoint(display.CenterRightReferencePoint);
    bump[numbers.carrunnum].x = carrun[numbers.carrunnum].x + 20
    bump[numbers.carrunnum].y = carrun[numbers.carrunnum].y
    bump[numbers.carrunnum].id = "bump "..numbers.carrunnum
    ticker[16] = w + 600
    ticker[17] = w + 600
    audio.play(external.sfx.sound_3,{channel = 14 })
    
end
carrun[numbers.carrunnum].id = "car "..numbers.carrunnum
audio.setVolume( 0.25, { channel=11 } )
audio.setVolume( 0.25, { channel=12 } )
audio.setVolume( 0.25, { channel=13 } )
audio.setVolume( 0.25, { channel=14 } )
bump[numbers.carrunnum].alpha = 0
external.physics.addBody(carrun[numbers.carrunnum],"static",{density = 5, bounce = 0,isSensor = true})
external.physics.addBody(bump[numbers.carrunnum],"static",{density = 10, bounce = 15,isSensor = true})
carrun[numbers.carrunnum].myName = "car";
bump[numbers.carrunnum].myName = "bumper";
ticker[12] = transition.to(carrun[numbers.carrunnum], {x = ticker[16], y = carrun.y,time = 2500,onComplete = removecar});
ticker[13] = transition.to(bump[numbers.carrunnum]  , {x = ticker[17], y = carrun.y,time = 2500,onComplete = removebump});
den[8] = timer.performWithDelay(2500, none, 1)
group[3]:insert(carrun[numbers.carrunnum]);
group[3]:insert(bump[numbers.carrunnum]);
end

function stopnow (event)
audio.stop({channel = 29})
ticker[9] = false
carup[12]:pause()
carup[12]:removeSelf()
carup[12] = nil
laserbutton[numbers.lasernumber]:addEventListener( "touch", functions.onTouch )
end

function functions.striker (locy)
    
if carup[11] ~= 0 then
    
ticker[9] = true
audio.play(external.sfx.sound_7,{channel = 29})
audio.setVolume(0.2,{channel = 29})
carup[12] = external.sprite.newSprite(external.spritefactory.spritelaser)
carup[12].x = w 
carup[12].y = locy
carup[12]:prepare("strike")  
carup[12]:play()
group[5]:insert(carup[12])
external.physics.addBody(carup[12],"static",{density = 1, bounce = 0,isSensor = true});
carup[12].myName = "house"
carup[12].alpha = 0.8
carup[11] = carup[11] - 1
if carup[11] == -1 then
    carup[11] = 0
end
den[13] = timer.performWithDelay(8000, stopnow, 1) 
end
updateText()
end

local function spriteListener (event)
if event.phase == "end" then   
event.sprite:removeSelf()
end
end

local function hitcar (left,right,hitting,spriteid)
trans[6].id_5 = false
if hitting == "runner" then
    cardead[numbers.cardeadnum]= external.sprite.newSprite(external.spritefactory.spritedeadmob)
if spriteid == "runner 1" then
   cardead[numbers.cardeadnum]:prepare("dead_1")
elseif spriteid == "runner 2" then
    cardead[numbers.cardeadnum]:prepare("dead_2")
elseif spriteid == "runner 3" then
    cardead[numbers.cardeadnum]:prepare("dead_3")
elseif spriteid == "runner 4" then
    cardead[numbers.cardeadnum]:prepare("dead_4")
end
elseif hitting == "master" then
cardead[numbers.cardeadnum]= external.sprite.newSprite(external.spritefactory.spritedeadmob)
cardead[numbers.cardeadnum]:prepare("dead_3")  
end
cardead[numbers.cardeadnum].x = left
cardead[numbers.cardeadnum].y = right
cardead[numbers.cardeadnum]:play()
group[2]:insert(cardead[numbers.cardeadnum])
cardead[numbers.cardeadnum]:addEventListener( "sprite", spriteListener ) 
audio.play(external.sfx.splat)
end

local function explodeevent(locx,locy) -- EXPLODE
functions.shakingeffect ()   
trans[6].id_5 = false
ticker[3] = ticker[3] + 1
playexplode[ticker[3]] = external.sprite.newSprite(external.spritefactory.spritexplode)
playexplode[ticker[3]].x = locx
playexplode[ticker[3]].y = locy
playexplode[ticker[3]]:prepare("explode")
playexplode[ticker[3]]:play()
group[2]:insert(playexplode[ticker[3]])
playexplode[ticker[3]]:addEventListener( "sprite", spriteListener )
    
end

local function explodeevent_1(locx,locy) -- EXPLODE
functions.shakingeffect ()    
ticker[3] = ticker[3] + 1
playexplode[ticker[3]] = external.sprite.newSprite(external.spritefactory.spritexplode)
playexplode[ticker[3]].x = locx
playexplode[ticker[3]].y = locy
playexplode[ticker[3]]:prepare("explode")
playexplode[ticker[3]]:play()
group[2]:insert(playexplode[ticker[3]])
playexplode[ticker[3]]:addEventListener( "sprite", spriteListener )
    
end

local function masterremove (event) -- REMOVEmaster

local masterdead = event.target
master[2].deadnum = master[2].deadnum + 1
local x1 = masterdead.x
local y1 = masterdead.y

local masdead = 11 + master[2].deadnum
if event.phase == "began" then
    masterdead.damage = masterdead.damage - 1
    audio.play(external.sfx.sound_2)
    numbers.flasnum = numbers.flasnum + 1;
    flash[numbers.flasnum] = external.sprite.newSprite(external.spritefactory.spriteflash)
    flash[numbers.flasnum].x = x1
    flash[numbers.flasnum].y = y1
    flash[numbers.flasnum]:prepare("flash")
    flash[numbers.flasnum]:play()
    group[3]:insert(flash[numbers.flasnum])
    flash[numbers.flasnum]:addEventListener( "sprite", spriteListener )
    if masterdead.damage == 0 then
        audio.play(external.sfx.splat)
        master[masdead] = external.sprite.newSprite(external.spritefactory.spritedeadmob)
        master[masdead].x = x1
        master[masdead].y = y1
        master[masdead]:prepare("dead_1")
        master[masdead]:play()
        group[2]:insert(master[masdead])
        master[masdead]:addEventListener( "sprite", spriteListener )
        masterdead.id = nil
        masterdead:removeSelf()
        score[2] = score[2] + 200
    elseif masterdead.damage == -1 then
        masterdead.damage = 0
    end
end
end

local function removerunner(event) -- REMOVERUNNER
local hit = event.target
local holder = hit.id  

if holder == "runner 1" then
    score[2] = score[2] + 10
    updateText()
elseif holder == "runner 2" then
    score[2] = score[2] + 30
    updateText()
elseif holder == "runner 3" then
    score[2] = score[2] + 60
    updateText()
elseif holder== "runner 4" then
    score[2] = score[2] + 100
    updateText()    
end

if event.phase == "began" then
    hit.damage = hit.damage - 1
    local x1 = hit.x
    local y1 = hit.y
    audio.play(external.sfx.sound_2)
    numbers.flasnum = numbers.flasnum + 1;
    flash[numbers.flasnum] = external.sprite.newSprite(external.spritefactory.spriteflash)
    flash[numbers.flasnum].x = x1
    flash[numbers.flasnum].y = y1
    flash[numbers.flasnum]:prepare("flash")
    flash[numbers.flasnum]:play()
    group[3]:insert(flash[numbers.flasnum])
    flash[numbers.flasnum]:addEventListener( "sprite", spriteListener )
    
    if hit.damage == 0 then
        trans[6].id_5 = false
        audio.play(external.sfx.splat)
        deadtable[numbers.deadnum] = external.sprite.newSprite(external.spritefactory.spritedeadmob)
        deadtable[numbers.deadnum].x = x1
        deadtable[numbers.deadnum].y = y1

        if hit.id == "runner 1" then
          deadtable[numbers.deadnum]:prepare("dead_2")  
        elseif hit.id == "runner 2" then
          deadtable[numbers.deadnum]:prepare("dead_2")
        elseif hit.id == "runner 3" then
          deadtable[numbers.deadnum]:prepare("dead_3")
        elseif hit.id == "runner 4" then
          deadtable[numbers.deadnum]:prepare("dead_4") 
        end

        deadtable[numbers.deadnum]:play()
        group[2]:insert(deadtable[numbers.deadnum])
        deadtable[numbers.deadnum]:addEventListener( "sprite", spriteListener )
        event.target:removeSelf() 
        event.target.id = nil
    end    
end

numbers.deadnum = numbers.deadnum + 1
end

function functions.mobmoving (event)
    
local mobnum = math.random(1,2)
numbers.mobcount = numbers.mobcount + 1

if mobnum == 1 then
    mobrun[numbers.mobcount] = external.sprite.newSprite(external.spritefactory.alien_2)
    mobrun[numbers.mobcount]:prepare("alien_2")  
    mobrun[numbers.mobcount].id = "runner 1"
    mobrun[numbers.mobcount].damage = carpow[6]
    den[5] = den[1]
elseif mobnum == 2 then 
    mobrun[numbers.mobcount] = external.sprite.newSprite(external.spritefactory.alien_1)
    mobrun[numbers.mobcount]:prepare("alien_1")  
    mobrun[numbers.mobcount].id = "runner 2"
    den[5] = den[2]
    mobrun[numbers.mobcount].damage = carpow[7]
--elseif mobnum == 3 then  
--    mobrun[numbers.mobcount]:prepare("running3")  
--    mobrun[numbers.mobcount]:play()
--    mobrun[numbers.mobcount].id = "runner 3"
--    mobrun[numbers.mobcount].damage = carpow[8]
--    den[5] = den[3]
--elseif mobnum == 4 then 
--    mobrun[numbers.mobcount]:prepare("running4")  
--    mobrun[numbers.mobcount]:play()
--    mobrun[numbers.mobcount].id = "runner 4"
--    mobrun[numbers.mobcount].damage = carpow[9]
--    den[5] = den[4]
end
mobrun[numbers.mobcount]:setReferencePoint(display.CenterReferencePoint);
local locationx = math.random(1,4)
if locationx == 1 then
    mobrun[numbers.mobcount].x = (display.contentWidth/2) - (display.contentWidth*0.25) + mobrun[numbers.mobcount].width 
elseif locationx == 2 then    
    mobrun[numbers.mobcount].x = mobrun[numbers.mobcount].width
elseif locationx == 3 then
    mobrun[numbers.mobcount].x = (display.contentWidth/2) + (display.contentWidth*0.25) - mobrun[numbers.mobcount].width
elseif locationx == 4 then    
    mobrun[numbers.mobcount].x = display.contentWidth - mobrun[numbers.mobcount].width
end
mobrun[numbers.mobcount].y = -mobrun[numbers.mobcount].height
mobrun[numbers.mobcount]:play()
external.physics.addBody(mobrun[numbers.mobcount],{density = den[5] , bounce = 0,firction = 0})
mobrun[numbers.mobcount].isFixedRotation = true
mobrun[numbers.mobcount].myName = "runner"
group[2]:insert(mobrun[numbers.mobcount])
mobrun[numbers.mobcount]:addEventListener("touch",removerunner)

if master[1].stats == true then
    
    local function masterout ()
     --    local masternum = 1--math.random(1,2)   
    masternumbertable = masternumbertable  + 1
    local masternumber = masternumbertable
    mastersprite[masternumber] = external.sprite.newSprite(external.spritefactory.alien_3)
    mastersprite[masternumber]:setReferencePoint(display.CenterReferencePoint);
    local locationx_ = math.random(1,3)
    if locationx_ == 1 then
        mastersprite[masternumber].x = display.contentWidth - mastersprite[masternumber].width*2
    elseif locationx_ == 2 then    
        mastersprite[masternumber].x = mastersprite[masternumber].width*2
    elseif locationx_ == 3 then
        mastersprite[masternumber].x = (display.contentWidth/2) 
    end
    
    mastersprite[masternumber].y = -mastersprite[masternumber].height
    mastersprite[masternumber]:prepare("alien_3")
    mastersprite[masternumber]:play()
    mastersprite[masternumber]:addEventListener("touch",masterremove)
    external.physics.addBody(mastersprite[masternumber],{density = 5 , bounce = 0,firction = 0})
    mastersprite[masternumber].damage = den[11]
    mastersprite[masternumber].myName = "master"
    mastersprite[masternumber].id = "master" ..masternumber
    mastersprite[masternumber].isFixedRotation = true
    group[2]:insert(mastersprite[masternumber])

    if masternumbertable == 30 then
    masternumbertable  = 0
    master[2].deadnum = 0
    master[1].stats2 = false
    
    end
    
    end
master[1].stats = false
ticker[19] = timer.performWithDelay(ticker[20], masterout, 30)
master[1].stats2 = true

end

end

function functions.movingaline ()
if directnum_ == true then

numbers.mobcount = numbers.mobcount + 1
local xlocation = (math.random(50,(display.contentWidth - 150)))
mobrun[numbers.mobcount] = external.sprite.newSprite(external.spritefactory.spritealienship)
mobrun[numbers.mobcount].y = - 100
mobrun[numbers.mobcount].x = xlocation
mobrun[numbers.mobcount]:prepare("shipfront")  
mobrun[numbers.mobcount]:play()
mobrun[numbers.mobcount].id = "runner 1"
mobrun[numbers.mobcount].damage = carpow[6]
external.physics.addBody(mobrun[numbers.mobcount],{density = den[5] , bounce = 0,firction = 0,isSensor = true})
mobrun[numbers.mobcount].isFixedRotation = true
mobrun[numbers.mobcount].myName = "runner"
group[9]:insert(mobrun[numbers.mobcount])
mobrun[numbers.mobcount]:addEventListener("touch",removerunner)
trans[5] = transition.to(mobrun[numbers.mobcount],{x = (math.random(20,(display.contentWidth - 50))),y = h - 400, time = 1000, onComplete = functions.move_1})--isSensor = true})
mobrun[numbers.mobcount].isSensor = true
trans[6].id_1 = true
directnum_ = false

end
end

function functions.addbarrel (event)
    
local locbarrel = event.target
if numbers.barrelbacknum == 7 then
    numbers.barrelbacknum = 0
end
numbers.barrelbacknum = numbers.barrelbacknum + 1 
if numbers.barelnum == 0 or numbers.barelnum == -1 then
    numbers.barelnum = 0
end
if barrel[10] == 0 then
    
else
audio.play(external.sfx.sound_6)
barrel[numbers.barrelbacknum] = display.newImageRect("button/barrelbut/barrel.png", 64, 64)
barrel[numbers.barrelbacknum].x = locbarrel.x
barrel[numbers.barrelbacknum].y = locbarrel.y
external.physics.addBody(barrel[numbers.barrelbacknum],"static",{density  = 0,bounce = 0,friction = 0,isSensor = true})
barrel[numbers.barrelbacknum].myName = "barrel"
barrel[numbers.barrelbacknum].id = event.target.id
group[2]:insert(barrel[numbers.barrelbacknum])
locbarrel.id = nil
locbarrel:removeSelf()
group[2]:remove(locbarrel)
end
barrel[10] = barrel[10] - 1
if barrel[10] == -1 then
    barrel[10] = 0
end
updateText()
end

local function addcarpower(event)
    local car = event.target
print(car.id)
local function deltext (dtext)
        dtext:removeSelf()
        dtext = nil
end
    if event.phase == "began" and car.id == "friend" then
    carpow[3] = false
    
    audio.play(external.sfx.sound_10)
    audio.stop({channel = 19})

    ticker[7] = 1
    ticker[8] = math.random (1,3)

    if ticker[8] == 1 then
        ticker[10] = "BARREL +"
        ticker[11] = ticker[10]
        barrel[10] = barrel[10] + ticker[7] + 2
    elseif ticker[8] == 2 then
        ticker[10] = "CAR +"
        ticker[11] = ticker[10]
        carup[2] = carup[2] + ticker[7] 
    elseif ticker[8] == 3 then
        ticker[10] = "Laser +"
        ticker[11] = ticker[10]
        carup[11] = carup[11] + ticker[7] + 1
    end
    ticker[5] = display.newText(ticker[11]..ticker[7],0,0,"Consolas",30)
    ticker[5].x = event.target.x
    ticker[5].y = event.target.y
    transition.to(ticker[5], {y =(car.y - 50),alpha = 0, time = 2500,onComplete = deltext})
    transition.cancel(carpow[2])
    carpow[4] = false
    car:removeSelf()
    car = nil
    updateText()
    elseif event.phase == "began" and car.id == "alien" then
        audio.play(external.sfx.sound_12, { channel=21 })
        carpow[3] = false
        ticker[11] = "Life "
        ticker[7] = -1
        heart[lives[3]]:removeSelf()
        lives[3] = lives[3] - 1
        if lives[3] == -1 then
            lives[3] = 0
        elseif lives[3] == 0 then
            functions.gameoverscreen()
            ticker[15] = true
            carpow[4] = true
            carpow[5] = true
        end
        audio.play(external.sfx.sound_12, { channel=21 })
        audio.setVolume( 0.6, { channel=21 } )
    ticker[5] = display.newText(ticker[11]..ticker[7],0,0,"Consolas",30)
    ticker[5].x = event.target.x
    ticker[5].y = event.target.y
    transition.to(ticker[5], {y =(car.y - 50),alpha = 0, time = 2500,onComplete = deltext})
    transition.cancel(carpow[2])
    carpow[4] = false
    car:removeSelf()
    car = nil
    updateText()
    end
end

function functions.countdown ()
timecount = timer.performWithDelay(1000,function()
time[2] = time[2] + 1
gametime ()
if 2 <= level[2] then
 numbers.numbermobs = numbers.numbermobs + 1
if numbers.numbermobs == 10 then
   directnum_ = true
   functions.movingaline ()
   numbers.numbermobs = 0
end     
end

level[5] = level[5] + 1

if 2 <= level[2] then
    if level[5] == 5 then
    end
end
ticker[1] = ticker[1] + 1
ticker[2] = ticker[2] + 1

if ticker[1] == 8 then
counter = true
ticker[1] = 0
end

if ticker[2] == 50 then
    ticker[2] = 0
    carpow[3] = true
    
    local carlocs = math.random(1,4)

    if carlocs == 1 then
        carpow[1] = external.sprite.newSprite(external.spritefactory.spritepowcar)
        carpow[1].x = w + 500
        carpow[1].y = h - math.random(50,250)
        carpow[1]:prepare("powercar_1")
        carpow[1].id = "friend"
        ticker[6] = w - 600
        audio.play(external.sfx.sound_11,{channel = 19})
    elseif carlocs == 2 then
        carpow[1] = external.sprite.newSprite(external.spritefactory.spritealienship)
        carpow[1].x = w + 500
        carpow[1].y = h + math.random(50,500)
        carpow[1]:prepare("shipleft")
        carpow[1].id = "alien"
        ticker[6] = w - 600
    elseif carlocs == 3 then
        carpow[1] = external.sprite.newSprite(external.spritefactory.spritealienship)
        carpow[1].x = w - 500
        carpow[1].y = h - math.random(50,250)
        carpow[1]:prepare("shipright")
        carpow[1].id = "alien"
        ticker[6] = w + 600
    elseif carlocs == 4 then
        carpow[1] = external.sprite.newSprite(external.spritefactory.spritepowcar)
        carpow[1].x = w - 500
        carpow[1].y = h - math.random(50,500)
        carpow[1]:prepare("powercar_2")
        carpow[1].id = "friend"
        ticker[6] = w + 600
        audio.play(external.sfx.sound_11,{channel = 19})
    end
    
    carpow[1]:scale( 1.4, 1.6 )
    carpow[1]:play()
    external.physics.addBody(carpow[1],"static",{density = 10, bounce = 0,isSensor = true});
    carpow[1].isFixedRotation = true
    carpow[2] = transition.to(carpow[1], {x = ticker[6],y = h - math.random(50,500),time = 4000,onComplete = removecarpow})
    den[6] = timer.performWithDelay(4000, none, 1)
    carpow[4] = true
    
    carpow[1]:addEventListener("touch",addcarpower)
    group[9]:insert(carpow[1])

end
end,0)

end

function functions.gameloop (event) -- GAMELOOP
functions.mobmoving()

if counter == true then

tick = tick + 100
if tick >= tick2 then
tick = 0
level[2] = level[2] + 1 
level[6].wavestats = true

if level[4] >= 36 then 
level[4] = 1
else
level[4] = level[4] + 1
end

    if level[4] == 1 then
        
    elseif level[4] == 2 then
        master[1].stats = true
        level[6].bol_ = true
        level[6].time_ = timer.performWithDelay(15000, functions.cracken, 4)
    elseif level[4] == 3 then
        external.physics.setGravity(0,2)
        master[1].stats = true
        level[6].bol_ = true
        level[6].time_ = timer.performWithDelay(15000, functions.cracken, 4)
    elseif level[4] == 4 then
        master[1].stats = true
        level[6].bol_ = true
        level[6].time_ = timer.performWithDelay(15000, functions.cracken, 4)
    elseif level[4] == 5 then
        den[15] = .5
        master[1].stats = true
        --lives[3] = lives[3] + 2
        tick2 = 1700
        boss.starttime = timer.performWithDelay(10000,functions.start,1)
        boss.starting = true
    elseif level[4] == 6 then
        level[6].time_ = timer.performWithDelay(15000, functions.cracken, 4)
        level[6].bol_ = true
        external.physics.setGravity(0,2.5)
    elseif level[4] == 7 then
        level[6].time_ = timer.performWithDelay(15000, functions.cracken, 4)
        level[6].bol_ = true
    elseif level[4] == 8 then
        master[1].stats = true
        level[6].time_ = timer.performWithDelay(15000, functions.cracken, 4)
        level[6].bol_ = true
    elseif level[4] == 9 then
        external.physics.setGravity(0,2.8)
        level[6].time_ = timer.performWithDelay(15000, functions.cracken, 4)
        level[6].bol_ = true
    elseif level[4] == 10 then
        tick2 = 1500
        den[15] = 1
        master[1].stats = true
        --lives[3] = lives[3] + 2
        level[6].time_ = timer.performWithDelay(15000, functions.cracken, 4)
        level[6].bol_ = true
        boss.starttime = timer.performWithDelay(10000,functions.start,1)
        boss.starting = true
    elseif level[4] == 11 then
        master[1].stats = true
        external.physics.setGravity(0,3)
        level[6].time_ = timer.performWithDelay(15000, functions.cracken, 4)
        level[6].bol_ = true
    elseif level[4] == 12 then
        master[1].stats = true
        den[12] =8
        level[6].time_ = timer.performWithDelay(15000, functions.cracken, 4)
        level[6].bol_ = true
    elseif level[4] == 14 then
        external.physics.setGravity(0,3.5)
        master[1].stats = true
        level[6].time_ = timer.performWithDelay(15000, functions.cracken, 4)
        level[6].bol_ = true
    elseif level[4] == 15 then
        tick2 = 1700
        master[1].stats = true
        den[15] = .9
        --lives[3] = lives[3] + 2
        boss.starttime = timer.performWithDelay(10000,functions.start,1)
        boss.starting = true
    elseif level[4]== 16 then
        external.physics.setGravity(0,2.5)
    elseif level[4]== 17 then
        level[6].time_ = timer.performWithDelay(15000, functions.cracken, 4)
        level[6].bol_ = true
    elseif level[4] == 18 then
        master[1].stats = true
        level[6].time_ = timer.performWithDelay(15000, functions.cracken, 4)
        level[6].bol_ = true
    elseif level[4] == 19 then
        external.physics.setGravity(0,3)
        master[1].stats = true
        level[6].time_ = timer.performWithDelay(15000, functions.cracken, 4)
        level[6].bol_ = true
    elseif level[4]== 20 then
        tick2 = 1700
        external.physics.setGravity(0,3.5)
        den[15] = 1.5
       -- lives[3] = lives[3] + 2
       boss.starttime = timer.performWithDelay(10000,functions.start,1)
        boss.starting = true
    elseif level[4] == 21 then
        external.physics.setGravity(0,1.5)
        master[1].stats = true
        level[6].time_ = timer.performWithDelay(15000, functions.cracken, 4)
        level[6].bol_ = true
    elseif level[4] == 22 then
        level[6].time_ = timer.performWithDelay(15000, functions.cracken, 4)
        level[6].bol_ = true
    elseif level[4] == 23 then
        master[1].stats = true
        external.physics.setGravity(0,2.5)
        level[6].time_ = timer.performWithDelay(15000, functions.cracken, 4)
        level[6].bol_ = true
    elseif level[4] == 24 then
        level[6].time_ = timer.performWithDelay(15000, functions.cracken, 4)
        level[6].bol_ = true
    elseif level[4] == 25 then
        master[1].stats = true
        external.physics.setGravity(0,3.5)
        den[15] = 2.5
        level[6].time_ = timer.performWithDelay(15000, functions.cracken, 4)
        level[6].bol_ = true
        boss.starttime = timer.performWithDelay(10000,functions.start,1)
        boss.starting = true
    elseif level[4] == 26 then
        level[6].time_ = timer.performWithDelay(15000, functions.cracken, 4)
        level[6].bol_ = true
    elseif level[4] == 27 then
        master[1].stats = true
        external.physics.setGravity(0,4.5)
        level[6].time_ = timer.performWithDelay(15000, functions.cracken, 4)
        level[6].bol_ = true
    elseif level[4] == 28 then
        level[6].time_ = timer.performWithDelay(15000, functions.cracken, 4)
        level[6].bol_ = true
    elseif level[4] == 29 then
        master[1].stats = true
        level[6].time_ = timer.performWithDelay(15000, functions.cracken, 4)
        level[6].bol_ = true
    elseif level[4] == 30 then
        master[1].stats = true
        den[15] = .5
        level[6].time_ = timer.performWithDelay(15000, functions.cracken, 4)
        level[6].bol_ = true
        external.physics.setGravity(0,1.5)
        boss.starttime = timer.performWithDelay(10000,functions.start,1)
        boss.starting = true
    elseif level[4] == 31 then
        level[6].time_ = timer.performWithDelay(15000, functions.cracken, 4)
        level[6].bol_ = true
    elseif level[4] == 32 then
        external.physics.setGravity(0,2.5)
        master[1].stats = true
        level[6].time_ = timer.performWithDelay(15000, functions.cracken, 4)
        level[6].bol_ = true
    elseif level[4] == 33 then
        den[15] = .5
        level[6].time_ = timer.performWithDelay(15000, functions.cracken, 4)
        level[6].bol_ = true
        boss.starttime = timer.performWithDelay(10000,functions.start,1)
        boss.starting = true
    elseif level[4] == 34 then
        level[6].time_ = timer.performWithDelay(15000, functions.cracken, 4)
        level[6].bol_ = true
    elseif level[4] == 35 then
        master[1].stats = true
        level[6].time_ = timer.performWithDelay(15000, functions.cracken, 4)
        level[6].bol_ = true
        boss.starttime = timer.performWithDelay(10000,functions.start,1)
        boss.starting = true
    end
    
if callfence[2] == true then
functions.callfenceslevel ()
callfence[2] = false 
end

den[1] = 1 + den[15]
den[2] = 2 + den[15]
den[3] = 3 + den[15]
den[4] = 4 + den[15]

functions.waveup ()
end

timer.cancel  (event.source)
functions.startmob ()
counter = false
end

end

function functions.startmob ()
controller = timer.performWithDelay(2000 - tick,functions.gameloop,0)
end

function functions.waveup ()
    
local function levelevent (textfile)
transition.to(textfile, {alpha = 0, time = 3000})
time[3].text = ""
print(level[2].." "..display_.num)

local function objectdel (objects_)
objects_:removeSelf()
objects_ = nil

end

display_.num = display_.num + 1
if display_.num == 1 then
    if display_.earlynightbol == true then
        display_.earlynightbol = false
        transition.to(display_.earlynight,{alpha = 0,time = 3000,onComplete = objectdel});
    end
display_.lateafternoon = display.newImageRect("background/lateafternoon.png",display.contentWidth,display.contentHeight)
display_.lateafternoon:setReferencePoint(display.CenterReferencePoint)  
display_.lateafternoon.x =  w 
display_.lateafternoon.y = h
display_.lateafternoon.alpha = 0
group[9]:insert(display_.lateafternoon)
transition.to(display_.lateafternoon,{alpha = 0.8,time = 3000});
display_.lateafternoonbol = true
elseif display_.num == 5 then   

    if display_.lateafternoonbol == true then
        transition.to(display_.lateafternoon,{alpha = 0,time = 3000,onComplete = objectdel});   
        display_.lateafternoonbol = false
    end
display_.dark = display.newImageRect("background/dark.png",display.contentWidth,display.contentHeight)
display_.dark:setReferencePoint(display.CenterReferencePoint)  
display_.dark.x =  w 
display_.dark.y = h
display_.dark.alpha = 0
group[9]:insert(display_.dark)
transition.to(display_.dark,{alpha = 0.8,time = 3000});
display_.darkbol = true
elseif display_.num == 10 then
display_.num = 0

display_.fogleft = display.newImageRect("background/fn-leftfog.png",display.contentWidth,display.contentHeight)
display_.fogleft:setReferecePoint(display.CenterReferencePoint)  
display_.fogleft.x =  w 
display_.fogleft.y = h
display_.fogleft.alpha = 0
group[9]:insert(display_.fogleft)
 
display_.fogright = display.newImageRect("background/fn-rightfog.png",display.contentWidth,display.contentHeight)
display_.fogright:setReferencePoint(display.CenterReferencePoint)  
display_.fogright.x = w 
display_.fogright.y = h
display_.fogright.alpha = 0
group[9]:insert(display_.fogright)

transition.to(display_.fogleft,{alpha = 0.8,time = 3000});
transition.to(display_.fogright,{alpha = 0.8,time = 3000});

display_.fogrightbol = true
display_.fogleftbol = true
elseif display_.num == 15 then
    if display_.fogrightbol == true and display_.fogleftbol == true then
        transition.to(display_.fogleft,{alpha = 0,time = 3000,onComplete = objectdel});
        transition.to(display_.fogright,{alpha = 0,time = 3000,onComplete = objectdel});
        display_.fogrightbol = false
        display_.fogleftbol = false
    end
display_.earlynight = display.newImageRect("background/earlynight.png",display.contentWidth,display.contentHeight)
display_.earlynight:setReferencePoint(display.CenterReferencePoint)  
display_.earlynight.x =  w 
display_.earlynight.y = h
display_.earlynight.alpha = 0
group[9]:insert(display_.earlynight)
transition.to(display_.earlynight,{alpha = 0.8,time = 3000});
display_.earlynightbol = true
display_.num = 0
end

end

level[1].alpha = 0
level[1].text = "Wave "..level[2]
transition.to(level[1], {alpha = 1, time = 2000,onComplete = levelevent})
level[1]:setReferencePoint(display.CenterReferencePoint)
level[1].x = w

end

local function startgame ()
Runtime:addEventListener( "key", functions.pausePhysics )
Runtime:removeEventListener( "key", none )
time[3].text = "Game On!"
time[3]:setReferencePoint(display.CenterReferencePoint)
time[3].x = w
time[3].y = h   
audio.play(external.sfx.sound_9)
time[2] = time[4] 
functions.countdown ()
functions.waveup ()
functions.startmob ()  
newText()
end

local function gamecount ()
    
time[3].text = time[2]
time[3]:setReferencePoint(display.CenterReferencePoint)
time[3].x = w
time[3].y = h

audio.play(external.sfx.star)

time[2] = time[2] - 1
if time[2] == 0 then
timer.performWithDelay(1000,startgame,1)
end

end

function start ()

timer.performWithDelay(1000,gamecount,3)
end

local function carpower (event)

carpowbutton:setEnabled(false)
local phase = event.phase
ticker[15] = true

if "ended" == phase then
    if carup[2] == 0 then
        
    else
        
    ticker[18] = timer.performWithDelay(2500,function(event)
    carrunning()
    numbers.loop = numbers.loop + 1
    if numbers.loop == 10 then
        ticker[15] = false
        ticker[22] = false
        carpowbutton:setEnabled(true)
        numbers.loop = 0
    end
    end,10) 
    
    end
end

carup[2] = carup[2] - 1

if carup[2] == -1 then
    carup[2] = 0
end
updateText()   
end

function functions.pausePhysics( event ) --PAUSEGAME
    
game[6] = false

if "ended" == event.phase or (event.keyName == "back" and event.phase == "down") then
    
    if isPaused == false then
        
    if spritesset[14] == true then
        spritesset[13]:pause()
        spritesset[13]:removeEventListener("touch",functions.crackentouch)
        transition.cancel(spritesset[15])
        spritesset[17] = timer.cancel( spritesset[16] )
    end
    audio.pause()
    if master[1].humanstats == true then
        human[master[1].humanum]:pause()
        human[master[1].humanum]:removeEventListener("touch",functions.notouch) 
    end

    if level[6].bol_ == true then
        timer.pause(level[6].time_)
    end
    
    if ticker[9] == true then
    timer.pause(den[13])
    carup[12]:pause()
    elseif ticker[9] == false then
    laserbutton[numbers.lasernumber]:removeEventListener( "touch", functions.onTouch )
    end
    
    if boss.starting == true then
        timer.pause(boss.starttime) 
     end
    
    if boss.bol_ == true then
        transition.cancel(boss.move_)
        boss.timepause_ = timer.pause(boss.timer_)

    end
    if boss.bol_1 == true then
        transition.cancel(boss.move_1)
        boss.timepause_1 = timer.pause(boss.timer_1)

    end
    if boss.bol_2 == true then
        transition.cancel(boss.move_2)
        boss.timepause_2 = timer.pause(boss.timer_2)

    end
    if boss.stats_ == true then
        for k = 1, #boss do
            if boss[k].myName ~= nil then
                boss[k]:pause()
                boss[k]:removeEventListener("touch",functions.removerunner)
            end
        end
    end
    
    for key,value in pairs(trans[6]) do

        if key == "id_1" and value == true then
            trans[7]= transition.cancel(trans[5])
        elseif key == "id_2" and value == true then
            trans[7]= transition.cancel(trans[1])
        elseif key == "id_3" and value == true then
            trans[7]= transition.cancel(trans[2])
        elseif key == "id_4" and value == true then
            trans[7] = transition.cancel(trans[3])
        elseif key == "id_5" and value == true then
            trans[7] = transition.cancel(trans[4])
        end
    end
    
    if master[1].stats2 == true then
        
        for t = 1 ,#mastersprite ,1 do
            
            if tostring(mastersprite[t].id) == "nil" then
                
            elseif tostring(mastersprite[t].id) ~= "nil" then
                
                mastersprite[t]:removeEventListener("touch",masterremove) 
            end
        end
        timer.pause(ticker[19])
     
    end
    
    timer.pause(controller)
    timer.pause(timecount)
    
    if ticker[15] == true then
        den[9] = timer.pause(ticker[18]) 
        if ticker[22] == true then
            den[10] = timer.pause(den[8])
            transition.cancel(ticker[12])
            transition.cancel(ticker[13])
            for f = 1 , #carrun, 1 do
               
                if tostring(carrun[f].id) == "nil" then
                    
                elseif tostring(carrun[f].id) ~= "nil" then
                    carrun[f]:pause()
                end
            end
       end
    end
    
    if carpow[4] == true then
    transition.cancel(carpow[2])
    den[7] = timer.cancel( den[6] )
    end
    
    carpowbutton:setEnabled(false)
    
    if carpow[3] == true then
    carpow[1]:removeEventListener("touch",addcarpower)
    end
    
    for j = 1 ,#barelrep, 1 do
        if tostring(barelrep[j].id) == "nil" then
            
        elseif tostring(barelrep[j].id) ~= "nil" then
        barelrep[j]:removeEventListener("tap",functions.addbarrel)

        end
    end

    for h = 1 ,#mobrun, 1 do

        if tostring(mobrun[h].id) == "nil" then
        elseif tostring(mobrun[h].id) ~= "nil" then
        mobrun[h]:pause()
        mobrun[h]:removeEventListener("touch",removerunner)
        
        end
    end
    external.physics.pause()
    game[1] = display.newImageRect("background/gamepause.png",300,300)
    game[1]:setReferencePoint(display.TopCenterReferencePoint)
    game[1].x = w
    game[1].y = h - 220
    group[5]:insert(game[1])
    
    game[2] = external.widget.newButton
        {
            defaultFile     = "button/woodbutton/playagainbtn.png",
            over            = "button/woodbutton/playagainbtnover.png",
            id              = "restart",
            width           = 200, 
            height          = 70,
            onRelease       = functions.onSceneTouch,
        }
    game[2]:setReferencePoint(display.TopCenterReferencePoint)    
    game[2].x = w - 120
    game[2].y = game[1].y + game[1].height + 50
    group[5]:insert(game[2])
    
    game[18] = external.widget.newButton
        {
            defaultFile     = "button/woodbutton/quitbtn.png",
            overFile        = "button/woodbutton/quitbtnover.png",
            id              = "quit_1",
            width           = 200, 
            height          = 70,
            onRelease       = functions.onSceneTouch,
        }
    game[18]:setReferencePoint(display.TopCenterReferencePoint)
    game[18].x = w + 120
    game[18].y = game[1].y + game[1].height + 50
    group[5]:insert(game[18])

    isPaused = true
    
    elseif isPaused == true then
    
    timer.resume( controller )
    timer.resume( timecount )
    
    if spritesset[14] == true then
        spritesset[13]:play()
        spritesset[13]:addEventListener("touch",functions.crackentouch)
        spritesset[15] = transition.to(spritesset[13],{y = display.contentHeight + 50, time = spritesset[17]})
        spritesset[16] = timer.performWithDelay(spritesset[17], ending, 1)
        
    end
    audio.resume()
    if master[1].humanstats == true then
        human[master[1].humanum]:play()
        human[master[1].humanum]:addEventListener("touch",functions.notouch) 
    end
    
    if level[6].bol_ == true then
        timer.resume(level[6].time_)
    end
    
    if boss.starting == true then
        timer.resume(boss.starttime) 
     end
    
    if boss.bol_ == true then
        boss.move_ = transition.to(boss[boss.num],{time = boss.timepause_,y = display.contentHeight*.25,onComplete = functions.move1})
        timer.resume(boss.timer_)

    end
    if boss.bol_1 == true then
        if boss.locx == 1 then
            boss.move_1 = transition.to(boss[boss.num],{time = boss.timepause_1,x = display.contentWidth / 2,onComplete = functions.move2}) 
        elseif boss.locx == 2 then
            boss.move_1 = transition.to(boss[boss.num],{time = boss.timepause_1,x = (display.contentWidth / 2)  + (display.contentWidth*.25),onComplete = functions.move2}) 
        elseif boss.locx == 3 then    
            boss.move_1 = transition.to(boss[boss.num],{time = boss.timepause_1,x = (display.contentWidth / 2)  - (display.contentWidth*.25),onComplete = functions.move2}) 
        elseif boss.locx == 4 then
            boss.move_1 = transition.to(boss[boss.num],{time = boss.timepause_1,x = (display.contentWidth / 2)  + (display.contentWidth*.25) + (display.contentWidth*.125),onComplete = functions.move2}) 
        elseif boss.locx == 5 then    
            boss.move_1 = transition.to(boss[boss.num],{time = boss.timepause_1,x = (display.contentWidth / 2)  - (display.contentWidth*.25) - (display.contentWidth*.125),onComplete = functions.move2}) 
        end
        timer.resume(boss.timer_1)
    end
    if boss.bol_2 == true then
        if boss.locy == 1 then
            boss.move_2 = transition.to(boss[boss.num],{time = boss.timepause_2,x = display.contentWidth / 2,onComplete = functions.move1}) 
        elseif boss.locy == 2 then
            boss.move_2 = transition.to(boss[boss.num],{time = boss.timepause_2,x = (display.contentWidth / 2)  + (display.contentWidth*.25),onComplete = functions.move1}) 
        elseif boss.locy == 3 then    
            boss.move_2 = transition.to(boss[boss.num],{time = boss.timepause_2,x = (display.contentWidth / 2)  - (display.contentWidth*.25),onComplete = functions.move1}) 
        elseif boss.locy == 4 then
            boss.move_2 = transition.to(boss[boss.num],{time = boss.timepause_2,x = (display.contentWidth / 2)  + (display.contentWidth*.25) + (display.contentWidth*.125),onComplete = functions.move1}) 
        elseif boss.locy == 5 then    
            boss.move_2 = transition.to(boss[boss.num],{time = boss.timepause_2,x = (display.contentWidth / 2)  - (display.contentWidth*.25) - (display.contentWidth*.125),onComplete = functions.move1}) 
        end
        timer.resume(boss.timer_2)
    end
    if boss.stats_ == true then
        for k = 1, #boss do
            if boss[k].myName ~= nil then
                boss[k]:play()
                boss[k]:addEventListener("touch",functions.removerunner)
            end
        end
    end 
    
    for key,value in pairs(trans[6]) do

        if key == "id_1" and value == true then
            trans[5] = transition.to(mobrun[numbers.mobcount],{x = (math.random(20,300)),y = h - 200, time = trans[7], onComplete = functions.move_1})
        elseif key == "id_2" and value == true then
            trans[1] = transition.to(backobject,{x = (math.random(20,300)), time = trans[7], onComplete = functions.move_2}) 
        elseif key == "id_3" and value == true then
            trans[2] = transition.to(backobject,{x = (math.random(20,300)),y = math.random(h - 100) , time = trans[7], onComplete = functions.move_3})      
        elseif key == "id_4" and value == true then
            trans[3] = transition.to(backobject,{x = (math.random(20,300)),y = h - 100 , time = trans[7], onComplete = functions.move_4})    
        elseif key == "id_5" and value == true then
            trans[4] = transition.to(backobject,{y = h + 200, time = trans[6].transtime})
        end
    end
    
    
    
    if ticker[9] == true then
    timer.resume(den[13])
    carup[12]:play()
    elseif ticker[9] == false then
    laserbutton[numbers.lasernumber]:addEventListener( "touch", functions.onTouch )
    end
    
    if master[1].stats2 == true then
        for t = 1 ,#mastersprite ,1 do
            if tostring(mastersprite[t].id) ~= "nil" then
                mastersprite[t]:addEventListener("touch",masterremove) 
            end
        end
        timer.resume(ticker[19])
        
    end
    
    if ticker[15] == true then
       timer.resume(ticker[18]) 
        if ticker[22] == true then
       
            for d = 1 , #carrun, 1 do
                if tostring(carrun[d].id) == "nil" then
                elseif tostring(carrun[d].id) ~= "nil" then
                    carrun[d]:play()
                    ticker[12] = transition.to(carrun[d], {x = ticker[16],time = den[10],onComplete = removecar});
                    ticker[13] = transition.to(bump[d], {x = ticker[17],time = den[10],onComplete = removebump});
                    den[8] = timer.performWithDelay(den[10], none, 1)
                end
            end
        end 
    end
    
    if ticker[22] == false then
        carpowbutton:setEnabled(true)
    end
    
    for h = 1 ,#mobrun, 1 do
        
        if tostring(mobrun[h].id) == "nil" then

        elseif tostring(mobrun[h].id) ~= "nil" then
        mobrun[h]:play()
        mobrun[h]:addEventListener("touch",removerunner)
        end
    end

    for j = 1 ,#barelrep, 1 do
        if tostring(barelrep[j].id) == "nil" then

        elseif tostring(barelrep[j].id) ~= "nil" then
        barelrep[j]:addEventListener("tap",functions.addbarrel)
        end
    end
    
    if carpow[3] == true then
    carpow[1]:addEventListener("touch",addcarpower)
    end
    
    if carpow[4] == true then
    carpow[2]= transition.to(carpow[1], {x = ticker[6],time = den[7],onComplete = removecarpow})
    den[6] = timer.performWithDelay(den[7], none, 1)
    end
    
    external.physics.start()
    isPaused = false
    game[1]:removeSelf()
    game[2]:removeSelf()
    game[18]:removeSelf()
    group[2]:remove(game[2])
    group[2]:remove(game[1])
    end
    return true
--    elseif event.keyName == "volumeUp" then
--        params.soundv = params.soundv + 0.1
--        if params.soundv == 1.1 then
--            params.soundv = 1
--        end
--        audio.setVolume(params.soundv)
--        return false
--    elseif event.keyName == "volumeDown" then
--        params.soundv = params.soundv - 0.1
--        if params.soundv == -0.1 then
--            params.soundv = 0
--        end
--        audio.setVolume(params.soundv)
--        return false
    end

end

function functions.gameoverscreen (event) ---GAMEOVER
Runtime:removeEventListener( "key", functions.pausePhysics )
print("remove")
Runtime:addEventListener( "key", none )
external.physics.pause()

laserbutton[numbers.lasernumber]:removeEventListener( "touch", functions.onTouch )

if master[1].humanstats == true then
    human[master[1].humanum]:pause()
    human[master[1].humanum]:removeEventListener("touch",functions.notouch) 
end

for key,value in pairs(trans[6]) do
    if key == "id_1" and value == true then
        trans[7]= transition.cancel(trans[5])
    elseif key == "id_2" and value == true then
        trans[7]= transition.cancel(trans[1])
    elseif key == "id_3" and value == true then
        trans[7]= transition.cancel(trans[2])
    elseif key == "id_4" and value == true then
        trans[7] = transition.cancel(trans[3])
    elseif key == "id_5" and value == true then
        trans[7] = transition.cancel(trans[4])
    end
    end

if master[1].stats2 == true then
    for b = 1 ,#mastersprite ,1 do
        if tostring(mastersprite[b].id) ~= "nil" then
            mastersprite[b]:removeEventListener("touch",masterremove) 
        end
    end
        timer.cancel(ticker[19])
end

if carpow[4] == true then
   transition.cancel(carpow[2])
   timer.cancel(den[6])
end

for h = 1 ,#mobrun, 1 do
    if tostring(mobrun[h].id) == "nil" then

    elseif tostring(mobrun[h].id) ~= "nil" then
    mobrun[h]:pause()
    mobrun[h]:removeEventListener("touch",removerunner)
    end
end

if spritesset[14] == true then
    spritesset[13]:pause()
    spritesset[13]:removeEventListener("touch",functions.crackentouch)
    transition.cancel(spritesset[15])
    spritesset[17] = timer.cancel( spritesset[16] )
end

if boss.starting == true then
   timer.cancel(boss.starttime) 
end
 
if level[6].bol_ == true then
    timer.cancel(level[6].time_)
    level[6].bol_ = false
end

if ticker[14] == true then
    transition.cancel(ticker[12])
    transition.cancel(ticker[13])
    ticker[14] = false
end

if ticker[15] == true then
   timer.cancel(ticker[18])
   ticker[15] = false
end

if boss.bol_ == true then
    transition.cancel(boss.move_)
    timer.cancel(boss.timer_)
end
if boss.bol_1 == true then
    transition.cancel(boss.move_1)
    timer.cancel(boss.timer_1)
end
if boss.bol_2 == true then
    transition.cancel(boss.move_2)
   timer.cancel(boss.timer_2)
end

game[6] = true
timer.cancel(controller)
timer.cancel(timecount)
pausebutton:setEnabled(false)
carpowbutton:setEnabled(false)

for j = 1 ,#barelrep, 1 do
    if tostring(barelrep[j].id) == "nil" then
    elseif tostring(barelrep[j].id) ~= "nil" then
    barelrep[j]:removeEventListener("tap",functions.addbarrel)
    end
end
  
local gameover = display.newImageRect("background/gameover.png",display.contentWidth - 200,300)
gameover:setReferencePoint(display.TopCenterReferencePoint)
gameover.x = w
gameover.y = h - 300
group[7]:insert(gameover)

local quitbutton = external.widget.newButton
    {
        defaultFile     = "button/woodbutton/quitbtn.png",
        overFile        = "button/woodbutton/quitbtnover.png",
        id              = "quit_2",
        width           = 200, 
        height          = 70,
        onRelease       = functions.onSceneTouch,
    }
quitbutton:setReferencePoint(display.TopCenterReferencePoint)
quitbutton.x = w + 120
quitbutton.y = gameover.y + gameover.height + 50
group[7]:insert(quitbutton)

local restartbutton = external.widget.newButton
    {
        defaultFile     = "button/woodbutton/playagainbtn.png",
        overFile        = "button/woodbutton/playagainbtnover.png",
        id              = "restart",
        width           = 180, 
        height          = 63,
        onRelease       = functions.onSceneTouch,
    }
restartbutton:setReferencePoint(display.TopCenterReferencePoint)
restartbutton.x = w - 120
restartbutton.y = gameover.y + gameover.height + 50
group[7]:insert(restartbutton)

laserbutton[numbers.lasernumber].x = display.contentWidth - 60;
laserbutton[numbers.lasernumber].y = h + (h/2) - 30;
end

laserbutton[numbers.lasernumber]  = display.newImageRect("button/laser/laser_1.png" ,display.contentWidth*0.125, display.contentHeight*0.0416666666666667)
laserbutton[numbers.lasernumber]:setReferencePoint(display.CenterReferencePoint)
laserbutton[numbers.lasernumber].x = display.contentWidth - 60;
laserbutton[numbers.lasernumber].y = h + (h/2) - 30;
laserbutton[numbers.lasernumber].alpha = 0
group[8]:insert(laserbutton[numbers.lasernumber])

function functions.onTouch( event )
local t = event.target

local phase = event.phase

    if "began" == phase then

        local parent = t.parent
        parent:insert( t )
        display.getCurrentStage():setFocus( t )
        t.isFocus = true
        t.x0 = event.x - t.x
        t.y0 = event.y - t.y

    elseif t.isFocus then
        if "moved" == phase then
            t.x = event.x - t.x0
            t.y = event.y - t.y0
            --print(t.x.." "..display.contentWidth - 70)
        elseif "ended" == phase or "cancelled" == phase then
            display.getCurrentStage():setFocus( nil )
            t.isFocus = false
            if t.y > (display.contentHeight - 120) then 
            t.x = display.contentWidth - 60;
            t.y = h + (h/2) - 30;
            elseif t.x > (display.contentWidth - 70) then
            t.x = display.contentWidth - 60;
            t.y = h + (h/2) - 30;
            else
            functions.striker (laserbutton[numbers.lasernumber].y)
            laserbutton[numbers.lasernumber]:removeSelf()
            laserbutton[numbers.lasernumber]:removeEventListener( "touch", functions.onTouch )
            numbers.lasernumber = numbers.lasernumber + 1
            laserbutton[numbers.lasernumber] = display.newImageRect("button/laser/laser_1.png" ,display.contentWidth*0.125, display.contentHeight*0.0416666666666667)
            laserbutton[numbers.lasernumber]:setReferencePoint(display.CenterReferencePoint)
            laserbutton[numbers.lasernumber].x = display.contentWidth - 60;
            laserbutton[numbers.lasernumber].y = h + (h/2) - 30;
            group[8]:insert(laserbutton[numbers.lasernumber])
            end  
        end
    end
    return true
end
 
laserbutton[numbers.lasernumber]:addEventListener( "touch", functions.onTouch )

carpowbutton = external.widget.newButton
    {
    defaultFile = "button/carbut/car.png",
    overFile    = "button/carbut/cartap.png",
    id          = "carpower",
    width       = 80, 
    height      = 50,
    onRelease   = carpower,
    }
carpowbutton:setReferencePoint(display.CenterReferencePoint)
carpowbutton.x = display.contentWidth - 60;
carpowbutton.y = h + (h/2) + 40;
carpowbutton.alpha = 0
group[8]:insert(carpowbutton)

pausebutton = external.widget.newButton   
    {
    defaultFile     = "button/orange/pause.png",
    overFile        = "button/orange/pausetap.png",
    id              = "Pause",
    width           = 80, 
    height          = 80,
    onRelease       = functions.pausePhysics,
    }
pausebutton:setReferencePoint(display.CenterReferencePoint)
pausebutton.x = display.contentWidth - 50
pausebutton.y = display.contentHeight - 50
pausebutton.alpha = 0
group[8]:insert(pausebutton)

function functions.gamecollision (event)
    
if ((event.object1.myName == "end" and event.object2.myName == "bullet") or 
    (event.object1.myName == "bullet" and event.object2.myName == "end")) then
    
        if event.object1.myName == "bullet" then
                event.object1:removeSelf()
                event.object1.myName = nil
        elseif event.object2.myName == "bullet" then
                event.object2:removeSelf()
                event.object2.myName = nil
        end
end
    
if ((event.object1.myName == "remove" and event.object2.myName == "bullet") or 
    (event.object1.myName == "bullet" and event.object2.myName == "remove")) then
        if event.object1.myName == "bullet" then
                event.object1:removeSelf()
                event.object1.myName = nil
        elseif event.object2.myName == "bullet" then
                event.object2:removeSelf()
                event.object2.myName = nil
        end
        lives[2] = lives[2] - 1
        trans[6].id_5 = false
        audio.play(external.sfx.sound_4, { channel=21 })
        fancestatus()
end    
    
if((event.object1.myName == "human"and event.object2.myName == "end") or 
    (event.object1.myName == "end" and event.object2.myName == "human")) then
    
    if event.object1.myName == "human" then
        event.object1:removeSelf()
        event.object1.myName = nil
    elseif event.object2.myName == "human" then
        event.object2:removeSelf()
        event.object2.myName = nil
    end
    master[1].humanstats = false
    score[2] = score[2] + 500
    coin = coin + 3
    updateText()
    
end
    
if( (event.object1.myName == "runner" and event.object2.myName == "remove")     or 
    (event.object1.myName == "remove" and event.object2.myName == "runner") )   or 
  ( (event.object1.myName == "master" and event.object2.myName == "remove")     or 
    (event.object1.myName == "remove" and event.object2.myName == "master") )   then

audio.play(external.sfx.sound_4, { channel=21 })
audio.setVolume( 0.6, { channel=21 } )

if event.object2.myName == "runner" or event.object2.myName == "master" then  
event.object2:removeSelf()
event.object2.myName=nil
event.object2.id = nil
elseif event.object1.myName == "runner" or event.object1.myName == "master" then 
event.object1:removeSelf()
event.object1.myName=nil   
event.object1.id = nil

end

lives[2] = lives[2] - 1
trans[6].id_5 = false
fancestatus()
end

if( (event.object1.myName == "remove"   and event.object2.myName == "cracken")  or 
    (event.object1.myName == "cracken"  and event.object2.myName == "remove") ) then

audio.play(external.sfx.sound_4, { channel=21 })
audio.setVolume( 0.6, { channel=21 } )
lives[2] = 0
fancestatus()

end

if( (event.object1.myName == "runner"   and event.object2.myName == "end")       or 
    (event.object1.myName == "end"      and event.object2.myName == "runner") )  or 
  ( (event.object1.myName == "master"   and event.object2.myName == "end")       or 
    (event.object1.myName == "end"      and event.object2.myName == "master") )  or 
  ( (event.object1.myName == "cracken"  and event.object2.myName == "end")       or 
    (event.object1.myName == "end"      and event.object2.myName == "cracken") ) then

audio.play(external.sfx.sound_12, { channel=21 })
audio.setVolume( 0.6, { channel=21 } )

if event.object2.myName == "runner" or event.object2.myName == "master" then -- 
    
event.object2:removeSelf()
event.object2.myName=nil
event.object2.id = nil

elseif event.object1.myName == "runner" or event.object1.myName == "master" then -- 

event.object1:removeSelf()
event.object1.myName=nil   
event.object1.id = nil

end
if event.object2.myName == "cracken" then
    event.object2:removeSelf()
    event.object2.myName=nil
    event.object2.id = nil 
    spritesset[14] = false
elseif event.object1.myName == "cracken" then
    event.object1:removeSelf()
    event.object1.myName = nil   
    event.object1.id = nil 
    spritesset[14] = false
end
trans[6].id_5 = false
heart[lives[3]]:removeSelf()
lives[3] = lives[3] - 1
if lives[3] == -1 then
    lives[3] = 0
elseif lives[3] == 0 then
    functions.gameoverscreen()
    ticker[15] = true
    carpow[4] = true
    carpow[5] = true
end

updateText()
end

if( (event.object1.myName == "runner"   and event.object2.myName == "flamers")  or 
    (event.object1.myName == "flamers"  and event.object2.myName == "runner") ) or 
  ( (event.object1.myName == "master"   and event.object2.myName == "flamers")  or 
    (event.object1.myName == "flamers"  and event.object2.myName == "master") ) then

audio.play(external.sfx.sound_12, { channel=21 })
audio.setVolume( 0.6, { channel=21 } )

    if event.object2.myName == "runner" then
    event.object2:removeEventListener("touch",removerunner)
    elseif event.object2.myName == "master" then
    event.object2:removeEventListener("touch",masterremove)
    elseif event.object1.myName == "runner" then
    event.object1:removeEventListener("touch",removerunner)
    elseif   event.object1.myName == "master" then
    event.object1:removeEventListener("touch",masterremove) 
    end
end

if( (event.object1.myName == "runner"   and event.object2.myName == "house")    or 
    (event.object1.myName == "house"    and event.object2.myName == "runner") ) or 
  ( (event.object1.myName == "master"   and event.object2.myName == "house")    or 
    (event.object1.myName == "house"    and event.object2.myName == "master") ) then

audio.play(external.sfx.sound_1)

if event.object2.myName == "runner" or event.object2.myName == "master" then
    explodeevent(event.object2.x,event.object2.y)
    event.object2:removeSelf()
    event.object2.myName=nil
    event.object2.id = nil
elseif event.object1.myName == "runner" or event.object1.myName == "master"then
    explodeevent(event.object1.x,event.object1.y)
    event.object1:removeSelf()
    event.object1.myName=nil
    event.object1.id = nil
end
score[2] = score[2] + 100
updateText()  
end

if( (event.object1.myName == "runner"   and event.object2.myName == "car")      or 
    (event.object1.myName =="car"       and event.object2.myName == "runner") ) or
  ( (event.object1.myName == "master"   and event.object2.myName == "car")      or 
    (event.object1.myName =="car"       and event.object2.myName == "master") ) then

audio.play(external.sfx.sound_2)

if event.object2.myName == "runner" or event.object2.myName == "master" then
    hitcar(event.object2.x,event.object2.y,event.object2.myName,event.object2.id)
    if event.object2.id == "runner 1" then
    score[2] = score[2] + 10
    elseif event.object2.id == "runner 2" then
    score[2] = score[2] + 30
    elseif event.object2.id == "runner 3" then
    score[2] = score[2] + 60
    elseif event.object2.id == "runner 4" then
    score[2] = score[2] + 100
    elseif event.object2.myName == "master" then
    score[2] = score[2] + 100  
    end
    event.object2:removeSelf()
    event.object2.myName=nil
    event.object2.id = nil
    
elseif event.object1.myName == "runner" or event.object1.myName == "master" then
    hitcar(event.object1.x,event.object1.y,event.object1.myName,event.object1.id)
    if event.object1.id == "runner 1" then
    score[2] = score[2] + 5
    elseif event.object1.id == "runner 2" then
    score[2] = score[2] + 10
    elseif event.object1.id == "runner 3" then
    score[2] = score[2] + 20
    elseif event.object1.id == "runner 4" then
    score[2] = score[2] + 40
    elseif event.object1.myName == "master" then
    score[2] = score[2] + 100  
    end
    event.object1:removeSelf()
    event.object1.myName=nil
    event.object1.id = nil
    
end
updateText()
end

if( (event.object1.myName == "cracken"  and event.object2.myName == "car")      or 
    (event.object1.myName =="car"       and event.object2.myName == "cracken")) then

audio.play( external.sfx.sound_1 )
if event.object2.myName == "car" then
    explodeevent_1(event.object2.x,event.object2.y)
    event.object2:removeSelf()
    event.object2.myName = nil
    event.object2.id     = nil 
    
elseif event.object1.myName == "car" then  
    explodeevent_1(event.object1.x,event.object1.y)
    event.object1:removeSelf()
    event.object1.myName = nil
    event.object1.id     = nil
    
end
transition.cancel(ticker[12] )
end

if( (event.object1.myName == "cracken" and event.object2.myName == "bumper")    or 
    (event.object1.myName == "bumper" and event.object2.myName == "cracken") )  then

if event.object2.myName == "bumper" then
    event.object2:removeSelf()
    event.object2.myName = nil
    event.object2.id     = nil 
    
elseif event.object1.myName == "bumper" then  
    event.object1:removeSelf()
    event.object1.myName = nil
    event.object1.id     = nil
    
end
transition.cancel(ticker[13] )
end

if( (event.object1.myName == "runner" and event.object2.myName == "barrel")   or 
    (event.object1.myName == "barrel" and event.object2.myName == "runner") ) or
  ( (event.object1.myName == "master" and event.object2.myName == "barrel")   or 
    (event.object1.myName == "barrel" and event.object2.myName == "master") ) or
  ( (event.object1.myName == "bullet" and event.object2.myName == "barrel")   or 
    (event.object1.myName == "barrel" and event.object2.myName == "bullet") ) then

audio.play( external.sfx.sound_1 )

if numbers.barelnum == 7 then
    numbers.barelnum = 0
end

local function deletetext (hittext)
    hittext:removeSelf()
    hittext = nil
end

numbers.barelnum = numbers.barelnum + 1
if event.object1.myName == "runner" or event.object1.myName == "master" or event.object1.myName == "bullet" then
    
explodeevent(event.object1.x,event.object1.y)
barelrep[numbers.barelnum] = display.newImageRect("button/barrelbut/barreltap.png", 64, 64)
local idnum = event.object2.id 
barelrep[numbers.barelnum].x        = event.object2.x
barelrep[numbers.barelnum].y        = event.object2.y
barelrep[numbers.barelnum].id       = idnum
barelrep[numbers.barelnum].alpha    = .5
group[4]:insert(barelrep[numbers.barelnum])

nicehit[numbers.nicehitnum]     = display.newText("BOOM!! + 200",0,0,"Consolas",30)
nicehit[numbers.nicehitnum]:setReferencePoint(display.CenterLeftReferencePoint)
nicehit[numbers.nicehitnum].x   = event.object1.x
nicehit[numbers.nicehitnum].y   = event.object1.y

elseif event.object2.myName == "runner" or event.object2.myName == "master" or event.object2.myName == "bullet" then

explodeevent(event.object2.x,event.object2.y)
local idnum = event.object1.id 

barelrep[numbers.barelnum]          = display.newImageRect("button/barrelbut/barreltap.png", 64, 64)
barelrep[numbers.barelnum].x        = event.object1.x
barelrep[numbers.barelnum].y        = event.object1.y
barelrep[numbers.barelnum].id       = idnum
barelrep[numbers.barelnum].alpha    = .5
group[4]:insert(barelrep[numbers.barelnum])

nicehit[numbers.nicehitnum]     = display.newText("BOOM!! + 200",0,0,"Consolas",30)
nicehit[numbers.nicehitnum]:setReferencePoint(display.CenterLeftReferencePoint)
nicehit[numbers.nicehitnum].x   = event.object2.x
nicehit[numbers.nicehitnum].y   = event.object2.y

end

barelrep[numbers.barelnum]:addEventListener("tap",functions.addbarrel)
nicehit[numbers.nicehitnum]:setTextColor(255, 255, 153)
transition.to(nicehit[numbers.nicehitnum], {y =(nicehit[numbers.nicehitnum].y - 100),alpha = 0, time = 2000,onComplete = deletetext})
numbers.nicehitnum = numbers.nicehitnum + 1
score[2] = score[2] + 200
updateText()

event.object1:removeSelf()
event.object1.myName = nil
event.object1.id = nil 

event.object2:removeSelf()
event.object2.myName = nil
event.object2.id = nil 

end

if( (event.object1.myName == "barrel"  and event.object2.myName =="cracken")    or 
    (event.object1.myName == "cracken" and event.object2.myName =="barrel") )   then

audio.play( external.sfx.sound_1)

if numbers.barelnum == 7 then
    numbers.barelnum = 0
end

numbers.barelnum = numbers.barelnum + 1

if event.object1.myName == "barrel" then
    
explodeevent_1(event.object1.x,event.object1.y)
barelrep[numbers.barelnum]          = display.newImageRect("button/barrelbut/barreltap.png", 64, 64)
barelrep[numbers.barelnum].x        = event.object1.x
barelrep[numbers.barelnum].y        = event.object1.y
barelrep[numbers.barelnum].id       = event.object2.id
barelrep[numbers.barelnum].alpha    = .5
group[4]:insert(barelrep[numbers.barelnum])

event.object1:removeSelf()
event.object1.myName = nil
event.object1.id = nil

elseif event.object2.myName == "barrel" then
    
explodeevent_1(event.object2.x,event.object2.y)
barelrep[numbers.barelnum]          = display.newImageRect("button/barrelbut/barreltap.png", 64, 64)
barelrep[numbers.barelnum].x        = event.object2.x
barelrep[numbers.barelnum].y        = event.object2.y
barelrep[numbers.barelnum].alpha    = .5
barelrep[numbers.barelnum].id       = event.object1.id
group[4]:insert(barelrep[numbers.barelnum])

event.object2:removeSelf()
event.object2.myName = nil
event.object2.id = nil

end
barelrep[numbers.barelnum]:addEventListener("tap",functions.addbarrel)
end

if( (event.object1.myName == "runner" and event.object2.myName == "bumper")     or 
    (event.object1.myName == "bumper" and event.object2.myName == "runner")  )  or 
  ( (event.object1.myName == "master" and event.object2.myName == "bumper")     or 
    (event.object1.myName == "bumper" and event.object2.myName == "master")  )  then

audio.play(external.sfx.sound_5)

local function deletetext (hittext)
    hittext:removeSelf()
    hittext = nil
end

if event.object2.myName == "runner" or event.object2.myName == "master" then
    event.object2.isFixedRotation = false

    
    if event.object1.id == "bump 1" then
        event.object2:applyForce( -1000, event.object2.x, event.object2.y )
    elseif event.object1.id  == "bump 2" then
        event.object2:applyForce( 1000, event.object2.x, event.object2.y )
    elseif event.object1.id  == "bump 3" then
        event.object2:applyForce( -1000, event.object2.x, event.object2.y )
    elseif event.object1.id  == "bump 4" then
        event.object2:applyForce( 1000, event.object2.x, event.object2.y )
    end

    nicehit[numbers.nicehitnum] = display.newText("Good HIT + 100",0,0,"Consolas",30)
    nicehit[numbers.nicehitnum]:setReferencePoint(display.CenterLeftReferencePoint)
    nicehit[numbers.nicehitnum].x = event.object1.x
    nicehit[numbers.nicehitnum].y = event.object1.y
    
elseif event.object1.myName == "runner" or event.object1.myName == "master" then
    event.object1.isFixedRotation = false
    
    if event.object2.id == "bump 1" then
        event.object1:applyForce( -1000, event.object2.x, event.object2.y )
    elseif event.object2.id == "bump 2" then
        event.object1:applyForce( 1000, event.object2.x, event.object2.y )
    elseif event.object2.id == "bump 3" then
        event.object1:applyForce( -1000, event.object2.x, event.object2.y )
    elseif event.object2.id == "bump 4" then
        event.object1:applyForce( 1000, event.object2.x, event.object2.y )
    end

    nicehit[numbers.nicehitnum] = display.newText("Good HIT + 100",0,0,"Consolas",30)
    nicehit[numbers.nicehitnum]:setReferencePoint(display.CenterLeftReferencePoint)
    nicehit[numbers.nicehitnum].x = event.object2.x
    nicehit[numbers.nicehitnum].y = event.object2.y

end
nicehit[numbers.nicehitnum]:setTextColor(255, 255, 153)
transition.to(nicehit[numbers.nicehitnum], {y =(nicehit[numbers.nicehitnum].y - 100),alpha = 0, time = 2000,onComplete = deletetext})
numbers.nicehitnum = numbers.nicehitnum + 1
score[2] = score[2] + 100
updateText()  
    
end

if( (event.object1.myName == "runner"  and event.object2.myName =="runner"))   then

end    
    
    
end


Runtime:addEventListener("collision",functions.gamecollision)

group[1]:insert(group[4])
group[1]:insert(group[2])
group[1]:insert(group[6])
group[1]:insert(group[3])
group[1]:insert(group[5])
group[1]:insert(group[7])
group[1]:insert(group[8])
group[1]:insert(group[9])

timer.performWithDelay(1000, function() 
start ()
external.adshow.loading("hide") 
end, 1)


Runtime:addEventListener( "key", none )
end

function scene:exitScene ( event )
    
audio.stop()

time[3].text    = " "; 
time[1].text    = " "; 
level[1].text   = " "; 
level[3].text   = " "; 
lives[1].text   = " "; 
score[1].text   = " ";
carup[1].text   = " "; 
barrel[12].text = " ";
master[1].stats   = false
master[1].stats2  = false

for k = 1 ,#barelrep, 1 do
    if tostring(barelrep[k].id) == "nil" then
    elseif tostring(barelrep[k].id) ~= "nil" then   
        barelrep[k]:addEventListener("tap",functions.addbarrel)
    end
end

timer.cancel( controller )
timer.cancel( timecount )

if level[6].bol_ == true then
        timer.cancel(level[6].time_)
end
if ticker[14] == true then
transition.cancel(ticker[12])
transition.cancel(ticker[13])
end

external.physics.stop()
if game[6] == true then
print("wtf")
else
game[6] = false
Runtime:removeEventListener( "key", functions.pausePhysics )
print("wtf_re")
end

if environment == "simulator" then
print("You're in he simulator.")
else 
system.deactivate("multitouch")
end

if master[1].stats2 == true then
    for o = 1 ,#mastersprite ,1 do
        if tostring(mastersprite[o].id) == "nil" then
        elseif tostring(mastersprite[o].id) ~= "nil" then
            mastersprite[o].id = nil
        end
    end
timer.cancel(ticker[19])
end

Runtime:removeEventListener("collision",functions.gamecollision)

group[3]:removeSelf(); group[3] = nil;
group[4]:removeSelf(); group[4] = nil;
group[5]:removeSelf(); group[5] = nil;
group[6]:removeSelf(); group[6] = nil;
group[7]:removeSelf(); group[7] = nil;
group[8]:removeSelf(); group[8] = nil;
group[9]:removeSelf(); group[9] = nil;
external.adshow.loading("show")
end

function scene:destroyScene ( event )
group[1]:removeSelf(); group[1] = nil;
Runtime:removeEventListener( "key", none )
end

scene:addEventListener("createScene",scene)
scene:addEventListener("willEnterScene",scene)
scene:addEventListener("enterScene",scene)
scene:addEventListener("exitScene",scene)
scene:addEventListener("destroyScene",scene)

return scene