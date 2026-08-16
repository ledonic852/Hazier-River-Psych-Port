function onCreate()
    initSaveData('Hazier_River_Variables')

    for i, object in ipairs({'garcelloIntro', 'picoCutscene', 'garcelloOutro'}) do
        local character = 'dad'
        if object == 'picoCutscene' then
            character = 'boyfriend'
        end

        createInstance(object, 'objects.Character', {getCharacterX(character), getCharacterY(character), 'cutscenes/'..object, (character == 'boyfriend')})
        setObjectOrder(object, getObjectOrder(character..'Group'))
        addInstance(object)
        setProperty(object..'.x', getProperty(object..'.x') + getProperty(object..'.positionArray[0]'))
        setProperty(object..'.y', getProperty(object..'.y') + getProperty(object..'.positionArray[1]'))
        
        if object ~= 'garcelloIntro' then
            setProperty(object..'.visible', false)
        end
    end

    for i, sound in ipairs({'Gun_Prep', 'ciglight', 'lightmiss', 'spin and puff'}) do
        precacheSound(sound)
    end
end

isGarcelloDead = nil
garcelloMustDie = nil
function onCreatePost()
    if seenCutscene == false then
        setDataFromSave('Hazier_River_Variables', 'garcelloDied', false)
	    flushSaveData('Hazier_River_Variables')
    end
    
    isGarcelloDead = getDataFromSave('Hazier_River_Variables', 'garcelloDied')
    if isGarcelloDead == false then
        garcelloMustDie = getRandomBool(8)
        setDataFromSave('Hazier_River_Variables', 'garcelloDied', false)
	    flushSaveData('Hazier_River_Variables')

        playAnim('garcelloIntro', 'holdCig')
        setProperty('dad.visible', false)
    else
        playAnim('garcelloIntro', 'dead')
        setProperty('dad.visible', false)
        removeLuaSprite('picoCutscene')
        removeLuaSprite('garcelloOutro')
        
        setProperty('opponentVocals.volume', 0)
        for i = 0, getProperty('notes.length') - 1 do
            if getPropertyFromGroup('notes', i, 'mustPress') == false then
                setPropertyFromGroup('notes', i, 'ignoreNote', true)
            end
        end
        for i = 0, getProperty('unspawnNotes.length') - 1 do
            if getPropertyFromGroup('unspawnNotes', i, 'mustPress') == false then
                setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', true)
            end
        end
    end

    if shadersEnabled == true then
        activateShader()
    end
end

function activateShader()
    local cutsceneSprites = {'garcelloIntro'}
    if isGarcelloDead == false then
        table.insert(cutsceneSprites, 'picoCutscene')
        if garcelloMustDie == false then
            table.insert(cutsceneSprites, 'garcelloOutro')
        end
    end

    initLuaShader('adjustColor')
    for i, object in ipairs(cutsceneSprites) do
        setSpriteShader(object, 'adjustColor')
        setShaderFloat(object, 'hue', 15)
        setShaderFloat(object, 'saturation', -15)
        setShaderFloat(object, 'contrast', 15)
        setShaderFloat(object, 'brightness', -15)
    end
end

function onCountdownTick(counter)
    if isGarcelloDead == false then
        if counter == 2 then
            doTweenAlpha('byeCamHUD', 'camHUD', 0, stepCrochet * 8 / 1000, 'linear')
        elseif counter == 3 then
            setVar('cutsceneMode', true)
            setProperty('picoCutscene.visible', true)
            setProperty('boyfriend.visible', false)
            playAnim('picoCutscene', 'reload')
            playSound('Gun_Prep')

            triggerEvent('Set Camera Target', 'BF,150,150', '0.5,expoOut')
            triggerEvent('Set Camera Zoom', '1.1', '0.5,expoOut')
            setVar('cutsceneMode', false)
        elseif counter == 4 then
            if garcelloMustDie == true then
                playAnim('garcelloIntro', 'die')
            else
                playAnim('garcelloIntro', 'survive')            
            end
            playAnim('picoCutscene', 'shootCig')
            runTimer('shootSound', 0.45)
            runTimer('spinAndPuff', 1)
            runTimer('picoCutsceneAnim', getProperty('picoCutscene.atlas.anim.length') / 24)
        end
    end
end

function onStepHit()
    if isGarcelloDead == false then
        if curStep == 26 then
            doTweenAlpha('helloCamHUD', 'camHUD', 1, 0.9, 'linear')
        end

        if garcelloMustDie == false then
            if curStep == 32 then
                setProperty('dad.visible', true)
                setProperty('garcelloIntro.visible', false)
                removeSpriteShader('garcelloIntro')
                removeLuaSprite('garcelloIntro')
            elseif curStep == 752 then
                playAnim('garcelloOutro', 'anim')
                setProperty('garcelloOutro.visible', true)
                runTimer('garcelloOutroAnim', getProperty('garcelloOutro.atlas.anim.length') / 24)
                setProperty('dad.visible', false)
            end
        end
    end
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == 'picoCutsceneAnim' then
        setProperty('boyfriend.visible', true)
        setProperty('picoCutscene.visible', false)
        removeSpriteShader('picoCutscene')
        removeLuaSprite('picoCutscene')
    end
    if tag == 'shootSound' then
        if garcelloMustDie == true then
            unlockAchievement('ur_fault')
            setDataFromSave('Hazier_River_Variables', 'garcelloDied', true)
	        flushSaveData('Hazier_River_Variables')

            playSound('lightmiss')
            setProperty('opponentVocals.volume', 0)
            for i = 0, getProperty('notes.length') - 1 do
                if getPropertyFromGroup('notes', i, 'mustPress') == false then
                    setPropertyFromGroup('notes', i, 'ignoreNote', true)
                end
            end
            for i = 0, getProperty('unspawnNotes.length') - 1 do
                if getPropertyFromGroup('unspawnNotes', i, 'mustPress') == false then
                    setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', true)
                end
            end
        else
            playSound('ciglight')
        end
    end
    if tag == 'spinAndPuff' then
        playSound('spin and puff')
    end
    if tag == 'garcelloOutroAnim' then
        playAnim('garcelloOutro', 'anim-loop')
    end
end