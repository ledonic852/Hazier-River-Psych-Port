function onCreate()
    makeLuaSprite('blackGraphic')
    makeGraphic('blackGraphic', screenWidth * 2, screenHeight * 2, '000000')
    setObjectCamera('blackGraphic', 'camHUD')
    screenCenter('blackGraphic')
    addLuaSprite('blackGraphic', true)

    soundFadeIn(nil, 1, 0, 0) -- Mutes the dialogue's music
    if isStoryMode == true and seenCutscene == false then
        local cutsceneText = getTranslationPhrase('gar_cutscene_text', 'Boyfriend and Girlfriend were\nout on a fancy date...\nwhen they saw a strange glow\ncoming from the alleyway...') 
        makeLuaText('cutsceneText', '', 850, 0, 0)
        setTextString('cutsceneText', cutsceneText)
        setTextFont('cutsceneText', 'Quantico-Bold.ttf')
        setTextSize('cutsceneText', 48)
        setTextAlignment('cutsceneText', 'center')
        screenCenter('cutsceneText')
        setObjectCamera('cutsceneText', 'camHUD')
        addLuaText('cutsceneText')
        setProperty('cutsceneText.antialiasing', true)
        setProperty('cutsceneText.alpha', 0.001)
    end
end

local cutsceneFinished = false
function onStartCountdown()
    if isStoryMode == true and seenCutscene == false then
        if cutsceneFinished == false then
            doTweenAlpha('beginText', 'cutsceneText', 1, 1)
            runTimer('endText', 7)
            runTimer('transDialogue', 10)
            return Function_Stop
        end
    end
end

function onCountdownTick(counter)
    if counter == 1 then
        setObjectOrder('countdownReady', getObjectOrder('blackGraphic') + 1)
    elseif counter == 2 then
        setObjectOrder('countdownSet', getObjectOrder('blackGraphic') + 1)
    elseif counter == 3 then
        setObjectOrder('countdownGo', getObjectOrder('blackGraphic') + 1)
    elseif counter == 4 then
        doTweenAlpha('byeGraphic', 'blackGraphic', 0, 16 * (stepCrochet * 4) / 1000)
    end
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == 'endText' then
        cutsceneFinished = true
        doTweenAlpha('byeText', 'cutsceneText', 0, 1)
    end
    if tag == 'transDialogue' then
        runTimer('dialogueBGFadeIn', 0.2, 5)
        callScript('data/'..songPath..'/dialogueBox-garcello', 'createDialogueBox')
        
        -- Resets the dialogue's music and fixes the BG appearing before the dialogue pops up
        setProperty('dialogueBG.alpha', 0)
        soundFadeIn(nil, 1, 0, 0.8)
        setSoundTime(nil, 0)
    end
end