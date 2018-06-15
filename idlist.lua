List = Class{__name = 'List'}

function List.init(self)
    self.alive = {}
    self.aliveCount = 0
end


function List.register(self, object)
    -- Modifies an objects kill and revive functions so that the list can update the 
    -- object and add it to the correct state table.
    -- Function checks that the list is still alive before attempting to re-insert to prevent
    -- errors if the list is destroyed later in the program
    if object.id == nil then error('Object does not have an id, please set id before registering') end
    local oldKill, oldRevive = object.kill, object.revive
    object.kill = function(object)
        if type(oldKill) == 'function' then oldKill(object) end
        if self ~= nil then self:remove(object.id) end
    end
    object.revive = function(object)
        if type(oldRevive) == 'function' then oldRevive(object) end
        if self ~= nil then self:insert(object) end
    end
    self:insert(object)
end

function List.insert(self, object)
    -- Can be used to re-insert an object into the correct list
    self:remove(object.id)
    if object.alive then
        if self.alive[object.id] == nil then
            self.alive[object.id] = object
            self.aliveCount = self.aliveCount + 1
        end
    end
end


function List.remove(self, id)
    -- Remove the object from the list
    if self.alive[id] ~= nil then
        self.alive[id] = nil
        self.aliveCount = self.aliveCount - 1
    end
end


function List.killAll(self, excludeID)
    for _,object in pairs(self.alive) do
        if object.id ~= excludeID then
            object:kill()
        end
    end
end


function List.update(self, dt)
    for _,object in pairs(self.alive) do
        object:update(dt)
    end
end


function List.draw(self)
    for _,object in pairs(self.alive) do
        object:draw()
    end
end


function List.getFirstAlive(self)
    return next(self.alive)
end


return List