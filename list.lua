List = Class{__name = 'List'}


function List.init(self)
    self.alive = {}
    self.aliveCount = 0
    self.dead = {}
    self.deadCount = 0
end


function List.register(self, object)
    -- Modifies an objects kill and revive functions so that the list can update the 
    -- object and add it to the correct state table.
    -- Function checks that the list is still alive before attempting to re-insert to prevent
    -- errors if the list is destroyed later in the program
    local oldKill, oldRevive = object.kill, object.revive
    object.kill = function(object)
        if type(oldKill) == 'function' then oldKill(object) end
        if self ~= nil then self:insert(object) end
    end
    object.revive = function(object)
        if type(oldRevive) == 'function' then oldRevive(object) end
        if self ~= nil then self:insert(object) end
    end
    self:insert(object)
end

function List.insert(self, object)
    -- Can be used to re-insert an object into the correct list
    self:remove(object)
    if object.alive then
        if self.alive[object] == nil then
            self.alive[object] = true
            self.aliveCount = self.aliveCount + 1
        end
    else
        if self.dead[object] == nil then
            self.dead[object] = true
            self.deadCount = self.deadCount + 1
        end
    end
end


function List.remove(self, object)
    -- Remove the object from the list
    if self.dead[object] == true then
        self.dead[object] = nil
        self.deadCount = self.deadCount - 1
    end
    if self.alive[object] == true then
        self.alive[object] = nil
        self.aliveCount = self.aliveCount - 1
    end
end


function List.killAll(self)
    for object,_ in pairs(self.alive) do
        object:kill()
    end
end


function List.update(self, dt)
    for object,_ in pairs(self.alive) do
        object:update(dt)
    end
end


function List.draw(self)
    for object,_ in pairs(self.alive) do
        object:draw()
    end
end


function List.getFirstDead(self)
    return next(self.dead)
end


function List.getFirstAlive(self)
    return next(self.alive)
end


return List