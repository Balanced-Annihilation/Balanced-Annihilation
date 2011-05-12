
function widget:GetInfo()
	return {
		name      = 'Highlight Geos',
		desc      = 'Highlights geothermal spots when in metal map view',
		author    = 'Niobium',
		version   = '1.0',
		date      = 'Mar, 2011',
		license   = 'GNU GPL, v2 or later',
		layer     = 0,
		enabled   = true,  --  loaded by default?
	}
end

----------------------------------------------------------------
-- Globals
----------------------------------------------------------------
local geoDisplayList

----------------------------------------------------------------
-- Speedups
----------------------------------------------------------------
local glLineWidth = gl.LineWidth
local glDepthTest = gl.DepthTest
local glCallList = gl.CallList
local spGetMapDrawMode = Spring.GetMapDrawMode

----------------------------------------------------------------
-- Functions
----------------------------------------------------------------
local function PillarVerts(x, y, z)
	gl.Color(1, 1, 0, 1)
	gl.Vertex(x, y, z)
	gl.Color(1, 1, 0, 0)
	gl.Vertex(x, y + 1000, z)
end

local function HighlightGeos()
	local features = Spring.GetAllFeatures()
	for i = 1, #features do
		local fID = features[i]
		if FeatureDefs[Spring.GetFeatureDefID(fID)].geoThermal then
			local fx, fy, fz = Spring.GetFeaturePosition(fID)
			gl.BeginEnd(GL.LINE_STRIP, PillarVerts, fx, fy, fz)
		end
	end
end

----------------------------------------------------------------
-- Callins
----------------------------------------------------------------
function widget:Shutdown()
	if geoDisplayList then
		gl.DeleteList(geoDisplayList)
	end
end

function widget:DrawWorld()
	
	if spGetMapDrawMode() == 'metal' then
		
		if not geoDisplayList then
			geoDisplayList = gl.CreateList(HighlightGeos)
		end
		
		glLineWidth(20)
		glDepthTest(true)
		glCallList(geoDisplayList)
		glLineWidth(1)
	end
end
