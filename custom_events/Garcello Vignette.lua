function onCreate()
    makeLuaSprite('pulseVignette', 'events/garvignette')
    setGraphicSize('pulseVignette', screenWidth)
    setObjectCamera('pulseVignette', 'camHUD')
    addLuaSprite('pulseVignette', true)
    setProperty('pulseVignette.alpha', 0.0001)
    setProperty('pulseVignette.color', 0x00FF90)
end

isPulseActive = false
pulseStrength = 0
function onEvent(event, value1, value2, strumTime)
    if event == 'Garcello Vignette' then
        isPulseActive = (value1 == '1')
        pulseStrength = tonumber(value2)
    end
end

local camZoomOffset = 0
local camZoomRate = 4
function onStepHit()
    -- If either the 'Set Camera Zoom' or the 'Set Camera Bop' event are used
    if cameraZoomRate ~= nil then
        camZoomOffset = cameraZoomRateOffset
    end

    if isPulseActive then
        if pulseStrength > 0 and (curStep + (camZoomOffset * 4)) % (camZoomRate * 4) == 0 then
            setProperty('pulseVignette.alpha', getProperty('pulseVignette.alpha') + pulseStrength)
        end
    end
end

function onUpdate(elapsed)
    -- If either the 'Set Camera Zoom' or the 'Set Camera Bop' event are used
    if cameraZoomRate ~= nil then
        camZoomRate = cameraZoomRate
    end

    if camZoomRate > 0 then
        setProperty('pulseVignette.alpha', math.lerp(0, getProperty('pulseVignette.alpha'), 0.95 ^ (elapsed * 60)))
    end
end

function math.lerp(a, b, ratio)
	return a + ratio * (b - a)
end