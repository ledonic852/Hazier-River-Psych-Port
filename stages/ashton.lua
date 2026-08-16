function onCreate()
    if lowQuality == false then
        setBlendMode('ambientBlue', 'ADD')
        setBlendMode('lampostLights', 'ADD')
    end
    setBlendMode('vignette', 'HARDLIGHT')
end

function onCreatePost()
    if shadersEnabled == true then
        initLuaShader('adjustColor')
        for i, object in ipairs({'boyfriend', 'dad', 'gf'}) do
            setSpriteShader(object, 'adjustColor')
            if object == 'gf' then
                setShaderFloat(object, 'hue', 0)
                setShaderFloat(object, 'saturation', 0)
                setShaderFloat(object, 'contrast', -40)
                setShaderFloat(object, 'brightness', -40)
            else
                setShaderFloat(object, 'hue', 0)
                setShaderFloat(object, 'saturation', 0)
                setShaderFloat(object, 'contrast', -30)
                setShaderFloat(object, 'brightness', -40)
            end
        end
	end
end

local isLightFlickering = false
function onBeatHit()
    if getRandomBool(1.5) == true then
        if isLightFlickering == true then
            cancelTimer('flickerLights')
            setProperty('lampostLights.visible', true)
        end
        local flickerTiming = 1 / getRandomInt(10, 20)
        runTimer('flickerLights', flickerTiming, 0.3 / flickerTiming)
        isLightFlickering = true
    end
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == 'flickerLights' then
        setProperty('lampostLights.visible', (not getProperty('lampostLights.visible')))
        if loopsLeft == 0 then
            setProperty('lampostLights.visible', true)
            isLightFlickering = false
        end
    end
end