# ObjWrapper

An object wrapper for Roblox.

Wrappers allow you to add on your own properties to objects in Roblox. 

Before you click off thinking "there are a multitude of object wrappers already" or "attributes already exist", accepts all data types, and this module wraps objects globally.  

Meaning that wrapped objects are not local. Wrapping an object in another script will wrap the object globally. How does that work? Simple:

```lua
-- script that wraps an object

local objWrap = require(workspace.Wrapper)

local baseplate = objWrap.wrap(workspace.Baseplate)

baseplate.Strength = 300 -- assigning cool stuff
```

```lua
-- other scripts

local objWrap = require(workspace.Wrapper)

objWrap.wait(workspace.Baseplate) -- yields script just in case object isn't wrapped yet

local baseplate = objWrap.getWrap(workspace.Baseplate)

print(baseplate.Strength) -- 300

baseplate:Destroy() -- still use it as you normally would.
```

API:  

module.wrap(obj) `Returns the object in a wrapped form.`  

module.getWrap(obj) `Returns the wrapped form of an object (if already wrapped).`  

module.wait(obj) `If the given object isn't wrapped, it will yield until it is`  


Combined with things such as Event.lua, you can do some cool things.

```lua
-- script that wraps an object

local objWrap = require(workspace.Wrapper)
local Event = require(workspace.Event)

local lamp = objWrap.wrap(workspace.Part)

lamp.Toggled = Event.new()

-- some stuff here that scripts the lamp
```

```lua
-- other script

local objWrap = require(workspace.Wrapper)

local lamp = objWrap.getWrap(workspace.Part)

lamp.Toggled:Connect(function() -- custom events!

end)
```
