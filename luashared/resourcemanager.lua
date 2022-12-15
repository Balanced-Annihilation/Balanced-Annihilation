-- SPDX-License-Identifier: GPL-2.0-or-later
-- Resource manager for addons. Keeps track of fonts, textures
-- and shaders and deletes remaining objects on addon shutdown.

local function getTableByPath(parentTable, path, lvalue)
    local table = parentTable
    local lastTable
    local lastTableName

    for nextTableName in string.gmatch(path, "[^\.]+") do
        lastTable = table
        lastTableName = nextTableName
        table = table[nextTableName]
    end

    if lvalue then
        return lastTable, lastTableName
    else
        return table
    end
end

local allocators = {}
local deallocators = {}

local function WrapAddon(addon, resource, allocator, deallocator)

    if not addon.resources then
        addon.resources = {}
    end
    addon.resources[resource] = {}

    if not allocators[resource] or not deallocators[resource] then
        allocators[resource] = getTableByPath(_G, allocator, false)
        deallocators[resource] = getTableByPath(_G, deallocator, false)
    end
    local realAllocator = allocators[resource]
    local realDeallocator = deallocators[resource]

    local parent, allocatorName = getTableByPath(addon, allocator, true)
    parent[allocatorName] = function(...)
        local object = realAllocator(...)
        if object then
            addon.resources[resource][#addon.resources[resource]+1] = object
        end
        return object
    end

    local parent, deallocatorName = getTableByPath(addon, deallocator, true)
    parent[deallocatorName] = function(object, ...)
        for index, o in ipairs(addon.resources[resource]) do
            if (o == object) then
                table.remove(addon.resources[resource], index)
                break
            end
        end
        return realDeallocator(object, ...)
    end

    local shutdown = addon.Shutdown
    addon.Shutdown = function(...)
        if (shutdown) then
            shutdown(...)
        end
        if #addon.resources[resource] > 0 then
            Spring.Echo("Resource manager: Deleting " .. #addon.resources[resource] .. " leftover " .. resource)
            for index, object in ipairs(addon.resources[resource]) do
                realDeallocator(object)
            end
            addon.resources[resource] = {}
        end
    end
end

function EnableResourceManager(addon)
    WrapAddon(addon, "fonts", "gl.LoadFont", "gl.DeleteFont")
    WrapAddon(addon, "textures", "gl.LoadTexture", "gl.DeleteTexture")
    WrapAddon(addon, "shaders", "gl.CreateShader", "gl.DeleteShader")
end
