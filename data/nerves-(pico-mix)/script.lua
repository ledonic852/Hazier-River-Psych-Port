function onCreate()
    soundFadeIn(nil, 1, 0, 0) -- Mutes the dialogue's music
end

function onStartCountdown()
    if seenCutscene == false then
        if getVar('dialogueFinished') == false then
            triggerEvent('Set Camera Target', 'Dad', '0')
            setProperty('camHUD.visible', true)
            runTimer('delayStart', 1)
            return Function_Stop
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