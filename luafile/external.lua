local external = {}

external.adshow        = require "luafile.adshow"
external.widget        = require "widget"
external.sfx           = require "luafile.sfx"
external.sprite        = require "sprite";
external.spritefactory = require "luafile.spritefactory";
external.sqlite3       = require "sqlite3"
external.physics       = require "physics";

external.backmusic = true
audio.reserveChannels(1)
audio.reserveChannels(18)
audio.reserveChannels(19)
return external
