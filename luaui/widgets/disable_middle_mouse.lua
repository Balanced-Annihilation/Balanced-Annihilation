function widget:GetInfo()
    return {
        name = "disable middle mouse",
        desc = "A widget for avoid some camera behaviour after middle mouse button is pressed",
        author = "",
        version = "",
        date = "2020",
        license = "",
        layer = 90050,
        enabled = true,
    }
end

function widget:MousePress(mx, my, button)
    if (button == 2) and (not Spring.IsAboveMiniMap(mx, my)) then
        return true
    end
    return false
end