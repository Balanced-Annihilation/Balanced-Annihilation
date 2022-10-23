local table_insert = table.insert

-- Creates a new table composed of the results of calling a function on each key-value pair of the original table.
function table.map(_table, transform)
    local newTable = {}

    for key, value in pairs(_table) do
        local newKey, newValue = transform(key, value)
        newTable[newKey] = newValue
    end

    return newTable
end

function table.imap(array, transform)
    local newArray = {}

    for index, value in ipairs(array) do
        table_insert(newArray, transform(index, value))
    end

    return newArray
end

function table.mapToArray(_table, transform)
    local newArray = {}

    for key, value in pairs(_table) do
        table_insert(newArray, transform(key, value))
    end

    return newArray
end
function table.imapToTable(array, transform)
    local newTable = {}

    for index, value in ipairs(array) do
        local newKey, newValue = transform(index, value)
        newTable[newKey] = newValue
    end

    return newTable
end

function table.forEach(_table, func)
    for key, value in pairs(_table) do
        func(key, value)
    end
end

function table.iforEach(array, func)
    for key, value in ipairs(array) do
        func(key, value)
    end
end

function table.filter(_table, shouldIncludeElement)
    local newTable = {}
    for key, value in pairs(_table) do
        if shouldIncludeElement(key, value) then
            newTable[key] = value
        end
    end
    return newTable
end

function table.reduce(array, initialValue, operation)
    local value = initialValue
    for _, element in ipairs(array) do
        value = operation(value, element)
    end
    return value
end

-- Assembles a string by concatenating all string in an array, inserting the provided separator in between.
function table.joinStrings(table, separator)
    if #table < 2 then if #table < 1 then return "" else return table[1] end end

    local string = ""

    for i=1, #table do
        string = string .. tostring(table[i])
        if i ~= #table then
            string = string .. separator
        end
    end
    
    return string
end

-- Returns an array containing all elements in the provided arrays, in the reverse order than provided.
function table.joinArrays(arrayArray)
    local newArray = {}

    for _, array in pairs(arrayArray) do
        for _, value in pairs(array) do
            table_insert(newArray, value)
        end
    end

    return newArray
end
