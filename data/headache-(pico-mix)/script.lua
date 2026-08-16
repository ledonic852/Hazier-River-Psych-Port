function onCreate()
    soundFadeIn(nil, 1, 0, 0) -- Mutes the dialogue's music
    if seenCutscene == false then
        makeLuaSprite('blackGraphic')
        makeGraphic('blackGraphic', screenWidth * 2, screenHeight * 2, '000000')
        setObjectCamera('blackGraphic', 'camHUD')
        screenCenter('blackGraphic')
        addLuaSprite('blackGraphic', true)

        local cutsceneText = getTranslationPhrase('gar_pico_cutscene_text', 'Pico and Nene were out grabbing a late-night snack...\nSuddenly, a strange glow emitted from the parking lot.')
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
    if seenCutscene == false then
        if cutsceneFinished == false then
            doTweenAlpha('beginText', 'cutsceneText', 1, 1)
            runTimer('endText', 7)
            runTimer('transDialogue', 8.25)
            return Function_Stop
        end
    end
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == 'endText' then
        cutsceneFinished = true
        doTweenAlpha('byeText', 'cutsceneText', 0, 1)
    end
    if tag == 'transDialogue' then
        removeLuaSprite('blackGraphic')
        cameraFade('camGame', '000000', 1.5, false, true)
        runTimer('delayDialogue', 2)
    end
    if tag == 'delayDialogue' then
        runTimer('dialogueBGFadeIn', 0.2, 5)
        callScript('data/'..songPath..'/dialogueBox-garcello', 'createDialogueBox')
        
        -- Resets the dialogue's music and fixes the BG appearing before the dialogue pops up
        setProperty('dialogueBG.alpha', 0)
        soundFadeIn(nil, 1, 0, 0.8)
        setSoundTime(nil, 0)
    end
end