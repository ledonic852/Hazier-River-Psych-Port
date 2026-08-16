function onCreate()
    if lowQuality == false then
        setBlendMode('lampostLights', 'ADD')
    end
    setBlendMode('vignette', 'HARDLIGHT')
end

function onCreatePost()
    if shadersEnabled == true then
        initLuaShader('adjustColor')
        for i, object in ipairs({'boyfriend', 'dad', 'gf'}) do
            setSpriteShader(object, 'adjustColor')
            setShaderFloat(object, 'hue', 15)
            setShaderFloat(object, 'saturation', -15)
            setShaderFloat(object, 'contrast', 15)
            setShaderFloat(object, 'brightness', -15)
        end
	end
end