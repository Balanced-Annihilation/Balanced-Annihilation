function widget:GetInfo()
    return {
        name = "MasterFramework Extensions",
        description = "Provides higher-level interface elements such as buttons that may combine one or more MasterFramework core components together",
        layer = -math.huge, -- Run Initialise after MasterFramework file has loaded, but before any widget uses it
		enabled = false
    }
end

local requiredFrameworkVersion = 14

local framePositionCache = {}
local frameSizeCache = {}

function widget:Initialize()

    local MasterFramework = WG.MasterFramework[requiredFrameworkVersion]
    if MasterFramework then
        MasterFramework.areComplexElementsAvailable = true

        local semiTransparent = 0.66

        local hoverColor    = MasterFramework:Color(1, 1, 1, 0.66)
        local pressColor    = MasterFramework:Color(0.66, 0.66, 1, 0.66)
        local selectedColor = MasterFramework:Color(0.66, 1, 1, 0.66)

        local baseBackgroundColor = MasterFramework:Color(0, 0, 0, 0.66)
        
        local textColor = MasterFramework:Color(1, 1, 1, 1)

        local smallCornerRadius = MasterFramework:Dimension(2)

        local defaultMargin = MasterFramework:Dimension(8)
        local defaultCornerRadius = MasterFramework:Dimension(5)

        -- Dimensions
        local elementSpacing = MasterFramework:Dimension(1)
        local groupSpacing = MasterFramework:Dimension(5)

        -- function MasterFramework:ButtonWithHoverEffect()
        --     local hover = MasterFramework:MouseOverChangeResponder(
        --         margin,
        --         function(isOver)
        --             if isOver then
        --                 margin.decorations = { [1] = highlightColor }
        --             else
        --                 margin.decorations = {}
        --             end
        --         end
        --     )

        --     return 
        -- end

        ------------------------------------------------
        function MasterFramework:CheckBox(scale, action)
            local checkbox = {}
            local dimension = MasterFramework:Dimension(scale)
            local radius = MasterFramework:Dimension(scale / 2)
            
            local checked = false
        
            local highlightColor = hoverColor
            local unhighlightedColor = defaultBorder
        
            local rect = MasterFramework:Rect(dimension, dimension, radius, { unhihlightedColor })
            
            local body = MasterFramework:MouseOverChangeResponder(
                MasterFramework:MousePressResponder(
                    rect,
                    function(self, x, y, button)
                        highlightColor = pressColor
                        rect.decorations[1] = highlightColor
                        return true
                    end,
                    function(self, x, y, dx, dy)
                    end,
                    function(self, x, y)
                        highlightColor = hoverColor
                        if MasterFramework.PointIsInRect(x, y, self:Geometry()) then
                            action(checkbox)
                        end
                    end
                ),
                function(isInside)
                    rect.decorations[1] = (isInside and highlightColor) or unhighlightedColor
                end
            )
             
            function checkbox:Draw(...)
                body:Draw(...)
            end
            function checkbox:Layout(...)
                return body:Layout(...)
            end
        
            function checkbox:SetChecked(newChecked)
                checked = newChecked
                unhighlightedColor = (checked and selectedColor) or defaultBorder
                rect.decorations[1] = (isInside and highlightColor) or unhighlightedColor
            end
        
            checkbox:SetChecked(checked)
            return checkbox
        end

        -----------------------------------------------
        function MasterFramework:Button(visual, action)
            local button = { visual = visual }
            local margin = MasterFramework:MarginAroundRect(visual, defaultMargin, defaultMargin, defaultMargin, defaultMargin, {}, marginDimension, false)

            button.highlightColor = nil
            button.action = action


            local responder = MasterFramework:MousePressResponder(
                margin,
                function(self, x, y, button)
                    if button ~= 1 then return false end
                    if MasterFramework.PointIsInRect(x, y, self:Geometry()) then
                        margin.decorations = { [1] = pressColor }
                    else
                        margin.decorations = {}
                    end
                    return true
                end,
                function(self, x, y, dx, dy)
                    if MasterFramework.PointIsInRect(x, y, self:Geometry()) then
                        margin.decorations = { [1] = pressColor }
                    else
                        margin.decorations = {}
                    end
                end, 
                function(self, x, y)
                    if MasterFramework.PointIsInRect(x, y, self:Geometry()) then
                        margin.decorations = {}
                        button.action(button)
                    end
                end
            )

            function button:Layout(...)
                return responder:Layout(...)
            end
            function button:Draw(...)
                responder:Draw(...)
            end

            button.margin = margin

            return button
        end

        -- If key is set, MovableFrame will automatically cache its position
        -- DO NOT have multiple concurrent MovableFrame instances with the same key!
        function MasterFramework:MovableFrame(key, child, defaultX, defaultY)
            local frame = {}

            local handleDimension = MasterFramework:Dimension(20)
            local xOffset = defaultX
            local yOffset = defaultY

            if key then
                if framePositionCache[key] then
                    xOffset = framePositionCache[key].xOffset or xOffset
                    yOffset = framePositionCache[key].yOffset or yOffset
                else
                    framePositionCache[key] = { xOffset = xOffset, yOffset = yOffset }
                end
            end

            local scale = MasterFramework:Dimension(1)

            local handleDecorations = { unhighlightedColor }

            local handle = MasterFramework:Rect(handleDimension, handleDimension, nil, handleDecorations)

            local selected = false

            local handleHoverDetector = MasterFramework:MouseOverChangeResponder(
                handle,
                function(isOver)
                    if not selected then
                        handleDecorations[1] = (isOver and hoverColor) or nil
                    end
                end
            )
            local handlePressDetector = MasterFramework:MousePressResponder(
                handleHoverDetector,
                function()
                    handleDecorations[1] = pressColor
                    selected = true
                    return true
                end,
                function(responder, x, y, dx, dy)
                    frame:Move(dx, dy)
                end,
                function()
                    handleDecorations[1] = hoverColor
                    selected = false
                end
            )

            local vStack = MasterFramework:StackInPlace({ child, handlePressDetector }, 0, 1)

            function frame:Layout(...)
                return vStack:Layout(...)
            end

            local oldScale = scale()

            function frame:Draw(x, y)
                local currentScale = scale()
                if currentScale ~= oldScale then
                    scaleTranslation = currentScale / oldScale
                    xOffset = xOffset * scaleTranslation
                    yOffset = yOffset * scaleTranslation
                    oldScale = currentScale
                end

                vStack:Draw(x + xOffset, y + yOffset)
            end

            function frame:Move(x, y)
                xOffset = xOffset + x
                yOffset = yOffset + y

                if key then 
                    framePositionCache[key].xOffset = xOffset
                    framePositionCache[key].yOffset = yOffset
                end
            end

            return frame
        end

        -- As of now, primary frame MUST be inside ResizableMovableFrame, but ResizableMovableFrame must NOT have any padding on its margins,
        -- as any padding will inset the primary frame from the visible size of ResizableMovableFrame.
        function MasterFramework:ResizableMovableFrame(key, child, defaultX, defaultY, defaultWidth, defaultHeight, growToFitContents)
            local frame = {}

            local width = defaultWidth
            local height = defaultHeight

            if key then
                if frameSizeCache[key] then
                    width = frameSizeCache[key].width or width
                    height = frameSizeCache[key].height or width
                else
                    frameSizeCache[key] = { width = width, height = height }
                end
            end
            

            local scale = MasterFramework:Dimension(1)
            local oldScale = scale()

            local movableFrame

            local draggableDistance = MasterFramework:Dimension(20)
            local margin = MasterFramework:Dimension(0) -- Must be 0; see ResizableMovableFrame documentation. 

            local draggable = true

            local draggableColor = MasterFramework:Color(1, 1, 1, 1)
            local draggingColor = MasterFramework:Color(0.2, 1, 0.4, 1)
            local draggableDecoration = MasterFramework:Stroke(1, draggableColor, false)
            local marginDecorations = {}

            local highlightWhenDraggable = MasterFramework:MarginAroundRect(
                child,
                margin,
                margin,
                margin,
                margin,
                marginDecorations
            )

            frame.margin = highlightWhenDraggable

            local draggingLeft, draggingRight, draggingTop, draggingBottom = false

            local clickResponder = MasterFramework:MousePressResponder(
                highlightWhenDraggable,
                function(responder, x, y, button)
                    if button ~= 1 or (not draggable) then return false end

                    local scaledDraggableDistance = draggableDistance()

                    local responderX, responderY, responderWidth, responderHeight = responder:Geometry()

                    if x - responderX <= scaledDraggableDistance then
                        draggingLeft = true
                    elseif x - responderX - width >= -scaledDraggableDistance then
                        draggingRight = true
                    end
                    if y - responderY <= scaledDraggableDistance then
                        draggingBottom = true
                    elseif y - responderY - height >= -scaledDraggableDistance then
                        draggingTop = true
                    end

                    draggableDecoration.color = draggingColor

                    return true
                end,
                function(responder, x, y, dx, dy)
                    if draggingLeft then
                        width = width - dx
                        movableFrame:Move(dx, 0)
                    elseif draggingRight then
                        width = width + dx
                    end
                    if draggingBottom then
                        height = height - dy
                        movableFrame:Move(0, dy)
                    elseif draggingTop then
                        height = height + dy
                    end

                    if key then
                        frameSizeCache[key].width = width
                        frameSizeCache[key].height = height
                    end
                end,
                function(responder, x, y)
                    draggingLeft = false
                    draggingRight = false
                    draggingTop = false
                    draggingBottom = false

                    draggableDecoration.color = draggableColor
                end
            )

            local mouseOverResponder = MasterFramework:MouseOverResponder(
                clickResponder,
                function(responder, x, y)
                    local responderX, responderY, responderWidth, responderHeight = responder:Geometry()
                    local scaledDraggableDistance = draggableDistance()
                    if x - responderX <= scaledDraggableDistance or 
                       responderX + width - x <= scaledDraggableDistance or
                       y - responderY <= scaledDraggableDistance or 
                       responderY + height - y <= scaledDraggableDistance then
                        draggable = true
                        highlightWhenDraggable.decorations = { draggableDecoration }
                        return true
                    else
                        draggable = false
                        highlightWhenDraggable.decorations = {}
                        return false
                    end
                end,
                function() end,
                function()
                    draggable = false
                    highlightWhenDraggable.decorations = {}
                end
            )

            movableFrame = MasterFramework:MovableFrame(
                key, mouseOverResponder,
                defaultX, defaultY
            )

            function frame:Layout(availableWidth, availableHeight)
                movableFrame:Layout(width, height)

                local currentScale = scale()
                if currentScale ~= oldScale then
                    scaleTranslation = currentScale / oldScale
                    width = width * scaleTranslation
                    height = height * scaleTranslation
                    oldScale = currentScale
                end

                -- if growToFitContents then
                --     width = math.max(childWidth, width)
                --     height = math.max(childHeight, height)
                -- end

                return width, height
            end

            function frame:Draw(x, y)
                movableFrame:Draw(x, y)
            end

            return frame
        end
    end
end

local function XYRelativeToRect(x, y, width, height)
    
end

function widget:GetConfigData()
    return {
        framePositionCache = framePositionCache,
        frameSizeCache = frameSizeCache,
    }
end

function widget:SetConfigData(data)
    framePositionCache = data.framePositionCache
    frameSizeCache = data.frameSizeCache
end