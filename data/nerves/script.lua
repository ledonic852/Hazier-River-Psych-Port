local hudObjects = {
    'healthBar',
    'iconP1',
    'iconP2',
    'scoreTxt',
    'timeBar',
    'timeTxt'
}

function onCreate()
    setProperty('camHUD.visible', false)
    soundFadeIn(nil, 1, 0, 0) -- Mutes the dialogue's music
end

function onStartCountdown()
    if isStoryMode == true and seenCutscene == false then
        if getVar('dialogueFinished') == false then
            triggerEvent('Set Camera Target', 'Dad', '0')
            setProperty('camHUD.visible', true)
            runTimer('delayStart', 1)
            return Function_Stop
        else
            setProperty('camHUD.visible', false)
        end
    end
end

function onStepHit()
    if curStep == 16 then
        for i, object in ipairs(hudObjects) do
            setProperty(object..'.alpha', 0)
        end
        for i = 0, 3 do
            setPropertyFromGroup('playerStrums', i, 'visible', false)
            setPropertyFromGroup('opponentStrums', i, 'visible', false)
        end

        setPropertyFromGroup('opponentStrums', 0, 'visible', true)
        setPropertyFromGroup('opponentStrums', 1, 'visible', true)
        setProperty('camHUD.visible', true)
    elseif curStep == 20 then
        setPropertyFromGroup('opponentStrums', 2, 'visible', true)
        setPropertyFromGroup('opponentStrums', 3, 'visible', true)
    elseif curStep == 24 then
        setPropertyFromGroup('playerStrums', 0, 'visible', true)
        setPropertyFromGroup('playerStrums', 1, 'visible', true)
    elseif curStep == 28 then
        setPropertyFromGroup('playerStrums', 2, 'visible', true)
        setPropertyFromGroup('playerStrums', 3, 'visible', true)
    elseif curStep == 32 then
        for i, object in ipairs(hudObjects) do
            local finalAlpha = 1
            if i <= 3 then
                finalAlpha = healthBarAlpha
            end
            doTweenAlpha('hudObject'..i, object, finalAlpha, 4 * stepCrochet / 1000, 'quadOut')
        end
    end
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == 'delayStart' then
        runTimer('dialogueBGFadeIn', 0.2, 5)
        callScript('data/'..songPath..'/dialogueBox-garcello', 'createDialogueBox')
        
        -- Resets the dialogue's music and fixes the BG appearing before the dialogue pops up
        setProperty('dialogueBG.alpha', 0)
        soundFadeIn(nil, 1, 0, 0.8)
        setSoundTime(nil, 0)
    end
end