function widget:GetInfo()
	return {
	name      = "Key Tracker", --version 4.1
	desc      = "Displays pressed keys on the screen",
	author    = "MasterBel2",
	date      = "January 2022",
	license   = "GNU GPL, v2",
	layer     = 9999999999999999999, -- must be in front
	enabled   = false --enabled by default
	}
end

------------------------------------------------------------------------------------------------------------
-- Includes
------------------------------------------------------------------------------------------------------------

local MasterFramework
local requiredFrameworkVersion = 14

local Spring_GetPressedKeys = Spring.GetPressedKeys

------------------------------------------------------------------------------------------------------------
-- Keyboard
------------------------------------------------------------------------------------------------------------

local trackerKey
local keyboardKey

local keyCodes -- deferred to the end of the file, for readabilty
local keyNames
local keyCodeTypes

local label

local OperationKeys
local FKeys
local MainKeypad
local EscapeKey
local NavigationKeys
local ArrowKeys
local NumericKeypad

------------------------------------------------------------------------------------------------------------
-- Interface
------------------------------------------------------------------------------------------------------------

local mainKeypad
local escapeKeypad
local arrowKeypad
local navigationKeypad
local numericKeypad
local fKeypad
local operationKeypad

local keyboardRasterizer

local uiKeys = {}
local pressedUIKeys = {}

local heatmap = {}
local showHeatmap = false
local maxPressedtime = 0

local elapsedTime = 0

------------------------------------------------------------------------------------------------------------
-- Stats Data
------------------------------------------------------------------------------------------------------------

local statsCategory

local totalKeysPressed = 0

-- Vertices - x, y
local myKeypressData = {
    { 0, 0 }
}

local graphData = {
    minY = 0,
    maxY = 1,
    minX = 0,
    maxX = 1,
    lines = { 
        { 
            color = { r = 0, g = 0, b = 1, a = 1 }, 
            vertices = myKeypressData 
        }
    }
}

------------------------------------------------------------------------------------------------------------
-- Helpers
------------------------------------------------------------------------------------------------------------

-- Creates a new table composed of the results of calling a function on each key-value pair of the original table.
local map = table.map
-- Assembles a string by concatenating all string in an array, inserting the provided separator in between.
local joinStrings = table.joinStrings
-- Returns an array containing all elements in the provided arrays, in the reverse order than provided.
local joinArrays = table.joinArrays

function string:remove(i) -- incomplete consideration of edge cases, but due to our use here we won't flesh that out yet. (Should this be public then?)
    if #self > i then 
        return self:sub(1, i - 1) .. self:sub(i + 1, #self)
    elseif #self == i then
        return self:sub(1, i - 1)
    else
        return self 
    end
end

------------------------------------------------------------------------------------------------------------
-- Interface Component Definitions
------------------------------------------------------------------------------------------------------------

-- An interface element that caches the size and position of its body, without impacting layout or drawing.
local function GeometryTarget(body)
    local geometryTarget = {}
    local width, height, cachedX, cachedY
    function geometryTarget:Layout(...)
        width, height = body:Layout(...)
        return width, height
    end
    function geometryTarget:Draw(x, y)
        cachedX = x
        cachedY = y
        body:Draw(x, y)
    end
    function geometryTarget:CachedPosition()
        return cachedX or 0, cachedY or 0
    end
    function geometryTarget:Size()
        if (not height) or (not width) then
            return self:Layout(0, 0) -- we need a value, so get one.
        end
        return width, height
    end

    return geometryTarget
end

-- Constrains the width of its body to the width of the provided GeometryTarget.
local function MatchWidth(target, body)
    local matchWidth = {}

    function matchWidth:Layout(availableWidth, availableHeight)
        local width, _ = target:Size(availableWidth, availableHeight)
        local _, height = body:Layout(width, availableHeight)
        return width, height
    end

    function matchWidth:Draw(...)
        body:Draw(...)
    end

    return matchWidth
end

-- A variable-width interface component that positions its content vertically, consuming all available vertical space.
local function VerticalFrame(body, yAnchor)
    local frame = {}

    local height
    local bodyHeight

    function frame:Layout(availableWidth, availableHeight)
        local bodyWidth, _bodyHeight = body:Layout(availableWidth, availableHeight)
        height = availableHeight
        bodyHeight = _bodyHeight
        return bodyWidth, availableHeight
    end
    function frame:Draw(x, y)
        body:Draw(x, y + (height - bodyHeight) * yAnchor)
    end

    return frame
end

-- An variable-height interface component that positions its content horizontally, consuming all horizontal space. 
local function HorizontalFrame(body, xAnchor)
    local frame = {}

    local width
    local bodyWidth

    function frame:Layout(availableWidth, availableHeight)
        local _bodyWidth, bodyHeight = body:Layout(availableWidth, availableHeight)
        width = availableWidth
        bodyWidth = _bodyWidth
        return availableWidth, bodyHeight
    end
    function frame:Draw(x, y)
        body:Draw(x + (width - bodyWidth) * xAnchor, y)
    end

    return frame
end

-- Constrains the height of its body to the height of the provided GeometryTarget.
local function MatchHeight(target, body)
    local matchHeight = {}

    function matchHeight:Layout(availableWidth, availableHeight)
        local _, height = target:Size(availableWidth, availableHeight)
        local width, _ = body:Layout(availableWidth, height)
        return width, height
    end

    function matchHeight:Draw(...)
        body:Draw(...)
    end

    return matchHeight
end

------------------------------------------------------------------------------------------------------------
-- Additional Keyboard Components
------------------------------------------------------------------------------------------------------------

local keyCornerRadius

-- Draws a single keyboard key into a drawable interface component
local function UIKey(key, baseKeyWidth, rowHeight, keySpacing)
    local backgroundColor = MasterFramework:Color(0, 0, 0, 0.66)
    local textColor = MasterFramework:Color(1, 1, 1, 1) 

    local keyWidth = MasterFramework:Dimension(key.width * baseKeyWidth + (key.width - 1) * keySpacing)
    local keyHeight = MasterFramework:Dimension(rowHeight)
    local uiKey = MasterFramework:StackInPlace({
        MasterFramework:Rect(keyWidth, keyHeight, keyCornerRadius, { backgroundColor }),
        MasterFramework:Text(key.name, textColor, nil, nil, MasterFramework:Font("FreeSansBold.otf", 12, 0.2, 1.3))
    }, 0.5, 0.5)

    -- local uiKey = MasterFramework:MouseOverResponder(
    --         MasterFramework:StackInPlace({
    --             MasterFramework:Rect(keyWidth, keyHeight, keyCornerRadius, { backgroundColor }),
    --             MasterFramework:Text(key.name, textColor, nil, nil, MasterFramework:Font("Poppins-Regular.otf", 12, 0.2, 1.3))
    --         }, 0.5, 0.5),
    --     function() return true end,
    --     function()
    --         backgroundColor.r = 1
    --         keyboardRasterizer.invalidated = true
    --     end,
    --     function()
    --         backgroundColor.r = 0
    --         keyboardRasterizer.invalidated = true
    --     end
    -- )

    uiKey._keytracker_keyCode = key.code

    local wasPressed = false
    function uiKey:SetPressed(isPressed)
        local textBrightness
        if isPressed then
            textBrightness = 0
        else
            textBrightness = 1
        end

        local backgroundBrightness = 1 - textBrightness
        backgroundColor.r = backgroundBrightness
        backgroundColor.g = backgroundBrightness
        backgroundColor.b = backgroundBrightness
        textColor.r = textBrightness
        textColor.g = textBrightness
        textColor.b = textBrightness

        local shouldUpdate = (wasPressed ~= isPressed)
        wasPressed = isPressed

        return shouldUpdate
    end

    uiKey:SetPressed(false)

    function uiKey:SetBackgroundColor(newColor)
        backgroundColor.r = newColor.r
        backgroundColor.g = newColor.g
        backgroundColor.b = newColor.b
    end

    return uiKey
end

-- Converts a keypad layout (columns of rows of keys) into a drawable interface component.
local function KeyPad(keyColumns, keySpacing, baseKeyWidth, baseKeyHeight)
    local keyPad = { keys = {} }

    local scalableKeySpacing = MasterFramework:Dimension(keySpacing)

    local uiColumns = map(keyColumns, function(key, column)
        local uiColumn = MasterFramework:VerticalStack(
            map(column, function(key, row)
                local rowHeight = row.height * baseKeyHeight + (row.height - 1) * keySpacing
                local keys = map(row.keys, function(key, value)
                    local uiKey = UIKey(value, baseKeyWidth, rowHeight, keySpacing)
                    return key, uiKey
                end)

                keyPad.keys = joinArrays({ keyPad.keys, keys })

                local uiRow = MasterFramework:HorizontalStack(
                    keys,
                    scalableKeySpacing,
                    0.5
                )
                return key, uiRow
            end),
            scalableKeySpacing,
            0.5
        )

        return key, uiColumn
    end)

    local body = MasterFramework:MarginAroundRect(
        MasterFramework:HorizontalStack(
            uiColumns,
            scalableKeySpacing,
            0.5
        ),
        scalableKeySpacing,
        scalableKeySpacing,
        scalableKeySpacing,
        scalableKeySpacing,
        {},
        MasterFramework:Dimension(5),
        false
    )

    function keyPad:HighlightSelectedKeys()
    end
    
    function keyPad:Layout(...)
        return body:Layout(...)
    end
    function keyPad:Draw(...)
        return body:Draw(...)
    end

    return keyPad
end

------------------------------------------------------------------------------------------------------------
-- Widget Events (Update, Initialize, Shutdown)
------------------------------------------------------------------------------------------------------------

function widget:Initialize()
Spring.SendCommands("luaui enablewidget MasterBel2's GUI Framework")
Spring.SendCommands("luaui enablewidget MasterFramework Extensions")
	--widgetHandler:EnableWidget("MasterBel2's GUI Framework")
	--widgetHandler:EnableWidget("MasterFramework Extensions")

    if WG.MasterStats then WG.MasterStats:Refresh() end

    MasterFramework = WG.MasterFramework[requiredFrameworkVersion]
    if not MasterFramework then
        Spring.Echo("[Key Tracker] Error: MasterFramework " .. requiredFrameworkVersion .. " not found! Removing self.")
        widgetHandler:RemoveWidget(self)
        return
    end

    widgetHandler:AddAction(
        "master_keytracker_heatmap_visible", 
        function(_, _, words)
            showHeatmap = (words[1] == "1")

            if not showHeatmap then
                for code, key in pairs(uiKeys) do
                    key:SetPressed(pressedUIKeys[code] ~= nil)
                end
            end
        end,
        nil,
        "t"
    )

    -- Interface structure

    label = MasterFramework:Text("", nil, nil, nil, MasterFramework:Font("FreeSansBold.otf", 28, 0.2, 1.3))

    local keypadSpacing = 5
    local keySpacing = 1
    local baseKeyHeight = 25
    local baseKeyWidth = 27

    keyCornerRadius = MasterFramework:Dimension(5)

    mainKeypad = KeyPad(MainKeypad, keySpacing, baseKeyWidth, baseKeyHeight)
    escapeKeypad = KeyPad(EscapeKey, keySpacing, baseKeyWidth, baseKeyHeight)
    arrowKeypad = KeyPad(ArrowKeys, keySpacing, baseKeyWidth, baseKeyHeight)
    navigationKeypad = KeyPad(NavigationKeys, keySpacing, baseKeyWidth, baseKeyHeight)
    numericKeypad = KeyPad(NumericKeypad, keySpacing, baseKeyWidth, baseKeyHeight)
    fKeypad = KeyPad(FKeys, keySpacing, baseKeyWidth, baseKeyHeight)
    operationKeypad = KeyPad(OperationKeys, keySpacing, baseKeyWidth, baseKeyHeight)

    for _, value in ipairs(joinArrays(map({ mainKeypad, escapeKeypad, arrowKeypad, navigationKeypad, numericKeypad, fKeypad, operationKeypad }, function(key, value) return key, value.keys end))) do
        if value._keytracker_keyCode then
            uiKeys[value._keytracker_keyCode] = value
        end
    end
     

    local mainKeypadGeometryTarget = GeometryTarget(mainKeypad)

    keyboardRasterizer = MasterFramework:Rasterizer(MasterFramework:FrameOfReference(
        0.5,
        0,
        MasterFramework:PrimaryFrame(MasterFramework:HorizontalStack({
                MasterFramework:VerticalStack({
                        MatchWidth(
                            mainKeypadGeometryTarget,
                            MasterFramework:StackInPlace({
                                HorizontalFrame(escapeKeypad, 0),
                                HorizontalFrame(fKeypad, 1)
                            }, 0, 0)
                        ),
                        mainKeypadGeometryTarget
                    },
                    MasterFramework:Dimension(keypadSpacing),
                    0
                ),
                MasterFramework:VerticalStack({
                        operationKeypad,
                        MatchHeight(
                            mainKeypadGeometryTarget,
                            MasterFramework:StackInPlace({
                                VerticalFrame(navigationKeypad, 1),
                                VerticalFrame(arrowKeypad, 0)
                            }, 0, 0)
                        )
                    },
                    MasterFramework:Dimension(keypadSpacing),
                    0
                ),
                numericKeypad
            },
            MasterFramework:Dimension(keypadSpacing),
            0
        ))
    ))

    keyboardKey = MasterFramework:InsertElement(
        keyboardRasterizer,
        "Key Tracker Keyboard",
        MasterFramework.layerRequest.anywhere()
    )

    if MasterFramework.debug then
        trackerKey = MasterFramework:InsertElement(
            MasterFramework:FrameOfReference(
                0.9,
                0.9,
                MasterFramework:PrimaryFrame(label)
            ), 
            "Key Tracker",
            MasterFramework.layerRequest.top()
        )
    end
end

function widget:Update(dt)
    elapsedTime = elapsedTime + dt

    local wasPressed = pressedUIKeys
    pressedUIKeys = {}

    local keys = {}

    local pressedKeys = Spring_GetPressedKeys()

    local newTotalKeypresses = totalKeysPressed

    for codeOrName, isPressed in pairs(pressedKeys) do
        if isPressed and type(codeOrName) == "number" then
            table.insert(keys, tostring(codeOrName))
            pressedUIKeys[codeOrName] = uiKeys[codeOrName]

            heatmap[codeOrName] = (heatmap[codeOrName] or 0) + dt
            maxPressedtime = math.max(maxPressedtime, heatmap[codeOrName])
        end
    end

    for key, uiKey in pairs(pressedUIKeys) do
        if not wasPressed[key] then
            newTotalKeypresses = newTotalKeypresses + 1
            uiKey:SetPressed(true)
            keyboardRasterizer.invalidated = true
        end
    end
    for key, uiKey in pairs(wasPressed) do
        if not pressedUIKeys[key] then
            uiKey:SetPressed(false)
            keyboardRasterizer.invalidated = true
        end
    end

    label:SetString(joinStrings(keys, " + "))

    if showHeatmap then
        for code, time in pairs(heatmap) do
            if uiKeys[code] then
                uiKeys[code]:SetBackgroundColor({ r = time / maxPressedtime, g = 1 - (time / maxPressedtime), b = 0 })
                keyboardRasterizer.invalidated = true
            else
                -- For SDL1, Code 310 (Left Meta) triggers this pathng
            end
        end
    end

    if newTotalKeypresses ~= totalKeysPressed then
        table.insert(myKeypressData, { elapsedTime, newTotalKeypresses })
        table.insert(myKeypressData, { elapsedTime, newTotalKeypresses })
        totalKeysPressed = newTotalKeypresses
    else
        myKeypressData[#myKeypressData] = { elapsedTime, newTotalKeypresses }
    end
    graphData.maxX = elapsedTime
    graphData.maxY = totalKeysPressed
end

function widget:GameOver()
    Spring.Echo("Game over!")
    showHeatmap = true
end

function widget:Shutdown() 
    MasterFramework:RemoveElement(trackerKey)
    MasterFramework:RemoveElement(keyboardKey)

    widgetHandler:RemoveAction("master_keytracker_heatmap_visible", "t")
	
	Spring.SendCommands("luaui disablewidget MasterBel2's GUI Framework")
Spring.SendCommands("luaui disablewidget MasterFramework Extensions")
end

function widget:MasterStatsCategories()
    return {
        Input = {
            ["Keypress Count"] = graphData
        }
    }
end

------------------------------------------------------------------------------------------------------------
-- Keyboard Components
------------------------------------------------------------------------------------------------------------

-- Describes the height and contents of a row of keys on the keyboard
local function KeyRow(height, keys)
    return {
        height = height,
        keys = keys
    }
end

-- Describes the name, code, and width of a key on a keyboard.
local function Key(name, width)
    local code = keyNames[name]
    local key = {
        width = width or 1,
        code = code,
        name = code and keyCodes[code].compressedName or name,
        type = code and keyCodes[code].type or keyCodeTypes.unknown
    }

    return key
end

-- Describes a column of rows on the keyboard
local function KeyColumn(keyRows)
    return keyRows
end

------------------------------------------------------------------------------------------------------------
-- Keycode and Keypad data
------------------------------------------------------------------------------------------------------------

-- End of file. Now we'll declare keycodes and keypads.
-- These are declared as local at the top of the file, and defined here.

keyCodeTypes = {
    unknown = 0,
    modifier = 1,
    operation = 2,
    character = 3
}

local keyCodesFileName = "LuaUI/Widgets/keyCodes/sdl1KeyCodes.lua"
local keyCodesFile = VFS.LoadFile(keyCodesFileName)
local chunk, _error = loadstring(keyCodesFile, keyCodesFileName)
if not chunk or _error then
    error(_error)
end
setfenv(chunk, { keyCodeTypes = keyCodeTypes })
keyCodes = chunk()

keyNames = {}
for code, key in pairs(keyCodes) do
    keyNames[key.name] = code
end

-- Now we declare the stuff built on keycodes

OperationKeys = {
    [1] = KeyColumn({
        [1] = KeyRow(1, { [1] = Key("Print Screen"), [2] = Key("Scroll Lock"), [3] = Key("Pause") })
    })
}

FKeys = {
    [1] = KeyColumn({
        [1] = KeyRow(1, { [1] = Key("F1"), [2] = Key("F2"), [3] = Key("F3"), [4] = Key("F4"), [5] = Key("F5"), [6] = Key("F6"), [7] = Key("F7"), [8] = Key("F8"), [9] = Key("F9"), [10] = Key("F10"), [11] = Key("F11"), [12] = Key("F12") }),
    })
}

MainKeypad = {
    [1] = KeyColumn({
        [1] = KeyRow(1, { [1] = Key("`"), [2] = Key("1"), [3] = Key("2"), [4] = Key("3"), [5] = Key("4"), [6] = Key("5"), [7] = Key("6"), [8] = Key("7"), [9] = Key("8"), [10] = Key("9"), [11] = Key("0"), [12] = Key("-"), [13] = Key("="), [14] = Key("Backspace", 2) }),
        [2] = KeyRow(1, { [1] = Key("Tab", 1.5), [2] = Key("Q"), [3] = Key("W"), [4] = Key("E"), [5] = Key("R"), [6] = Key("T"), [7] = Key("Y"), [8] = Key("U"), [9] = Key("I"), [10] = Key("O"), [11] = Key("P"), [12] = Key("["), [13] = Key("]"), [14] = Key("\\", 1.5) }),
        [3] = KeyRow(1, { [1] = Key("Capslock", 2), [2] = Key("A"), [3] = Key("S"), [4] = Key("D"), [5] = Key("F"), [6] = Key("G"), [7] = Key("H"), [8] = Key("J"), [9] = Key("K"), [10] = Key("L"), [11] = Key(";"), [12] = Key("'"), [13] = Key("Return", 2) }),
        [4] = KeyRow(1, { [1] = Key("Left Shift", 2.5), [2] = Key("Z"), [3] = Key("X"), [4] = Key("C"), [5] = Key("V"), [6] = Key("B"), [7] = Key("N"), [8] = Key("M"), [9] = Key(","), [10] = Key("."), [11] = Key("/"), [12] = Key("Right Shift", 2.5) }),
        [5] = KeyRow(1, { [1] = Key("Left Control", 1.5), [2] = Key(""), [3] = Key("Left Alt", 1.5), [4] = Key("Space", 7), [5] = Key("Right Alt", 1.5), [6] = Key("Menu"), [7] = Key("Right Control", 1.5) })
    })
}


EscapeKey = {
    [1] = KeyColumn({
        [1] = KeyRow(1, { [1] = Key("Escape") })
    })
}


NavigationKeys = {
    [1] = KeyColumn({
        [1] = KeyRow(1, { [1] = Key("Insert"), [2] = Key("Home"), [3] = Key("Page Up"  ) }),
        [2] = KeyRow(1, { [1] = Key("Delete"), [2] = Key("End" ), [3] = Key("Page Down") })
    })
}


ArrowKeys = {
    [1] = KeyColumn({
        [1] = KeyRow(1, { [1] = Key("Up") }),
        [2] = KeyRow(1, { [1] = Key("Left"), [2] = Key("Down"), [3] = Key("Right") })
    })
}

NumericKeypad = {
    [1] = KeyColumn({
        [1] = KeyRow(1, { [1] = Key("Num Lock" ), [2] = Key("/ (KP)"), [3] = Key("* (KP)") }),
        [2] = KeyRow(1, { [1] = Key("7 (KP)"   ), [2] = Key("8 (KP)"), [3] = Key("9 (KP)") }),
        [3] = KeyRow(1, { [1] = Key("4 (KP)"   ), [2] = Key("5 (KP)"), [3] = Key("6 (KP)") }),
        [4] = KeyRow(1, { [1] = Key("1 (KP)"   ), [2] = Key("2 (KP)"), [3] = Key("3 (KP)") }),
        [5] = KeyRow(1, { [1] = Key("0 (KP)", 2                     ), [2] = Key(". (KP)") })
    }),
    [2] = KeyColumn({
        [1] = KeyRow(1, { [1] = Key("- (KP)") }),
        [2] = KeyRow(2, { [1] = Key("+ (KP)") }),
        [3] = KeyRow(2, { [1] = Key("Enter (KP)") })
    })
}