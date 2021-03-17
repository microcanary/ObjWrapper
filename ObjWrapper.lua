-- Load

local http = game:GetService("HttpService")

local function checkProperty(obj, property)
    return pcall(function() local a = obj[property] end)
end

if not shared._wrapped then
    shared._wrapped = {}
    shared._wrapped.queued = {}
end

-- Module

local objWrap = {}

objWrap.wrap = function(obj)
    assert(typeof(obj) == "Instance", "Invalid object provided.")
    
    assert(not obj:GetAttribute("_wrapID"), "Given object is already wrapped. To get wrapped object, use .getWrap")
    
    local wrapID = http:GenerateGUID()
    
    local attributes = {}
    
    shared._wrapped[wrapID] = attributes
    
    obj:SetAttribute("_wrapID", wrapID)
    
    local wrappedObj = setmetatable({}, {
        __index = function(t, k)
            return attributes[k] or obj[k]
        end;
        
        __newindex = function(t, k, v)
            if checkProperty(obj, k) then
                obj[k] = v
                return
            end
            
            attributes[k] = v
        end;
    })
    
    for i = #shared._wrapped.queued, 1, -1 do
        if shared._wrapped.queued[i][2] == obj then
            coroutine.resume(shared._wrapped.queued[i][1])
            table.remove(shared._wrapped.queued, i)
        end
    end
    
    return wrappedObj
end

objWrap.getWrap = function(obj)
    assert(typeof(obj) == "Instance", "Invalid object provided.")
    
    local ID = obj:GetAttribute("_wrapID")
    
    assert(ID, "Given object is not wrapped. Please use a wrapped object.")
    
    local attributes = shared._wrapped[ID] 
    
    local wrappedObj = setmetatable({}, {
        __index = function(t, k)
            if checkProperty(obj, k) then
                if type(obj[k]) == "function" then
                    return function(t, ...)
                        obj[k](obj, ...)
                    end
                end
                return obj[k]
            end
            return attributes[k]
        end;

        __newindex = function(t, k, v)
            if checkProperty(obj, k) then
                obj[k] = v
                return
            end

            attributes[k] = v
        end;
    })

    return wrappedObj
end

objWrap.new = function(i)
    return objWrap(Instance.new(i))
end

objWrap.wait = function(obj)
    if obj:GetAttribute("_wrapID") then
        return
    end
    
    local thread = coroutine.running()
    table.insert(shared._wrapped.queued, {thread, obj})
    coroutine.yield()
end

return objWrap
