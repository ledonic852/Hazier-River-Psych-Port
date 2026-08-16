--[[
    WARNING!!!:
    When using the dialogueBox in a song, 
    make sure to set up these 4 variables underneath.
    The rest will be handled by the script itself.
]]
dialogueBoxData = {
    musicName = 'nervesdialouge', -- The music that plays on loop during the dialogue.
    soundIntro = 'nervesouch', -- The sound that plays when the dialogue appears.
    useMusic = true, -- Enables or not the music during the dialogue.
    useSoundIntro = true -- Enables or not the sound when the dialogue appears.
}
-- This character will be on the right.
bfDialogueData = {
    name = 'pico', -- characterName
    expressions = {
        -- expressionName = {x = offsetX, y = offsetY}
        questioning = {x = 0, y = 25},
        high = {x = 0, y = 25},
        huff = {x = 0, y = 25},
        cocky = {x = 0, y = 25},
        showoff = {x = 0, y = 25},
        uneasy = {x = 0, y = 25},
        standstill = {x = 0, y = 25},
    }
}
-- This character will be on the left.
dadDialogueData = {
    name = 'garcello',
    expressions = {
        concerned = {x = 0, y = 0},
        weak = {x = 0, y = 0},
        offer = {x = 0, y = 0},
        cough = {x = 0, y = 0},
        think = {x = 0, y = 0},
        thought = {x = 0, y = 0},
        one_more = {x = 0, y = 0},
        fine = {x = 0, y = 0}
    }
}
-- This character will be in the middle.
gfDialogueData = {
    name = 'nene',
    expressions = {
        pissed = {x = -30, y = -120}
    }
}

local dialogueFinished = false
function onCreate()
    setVar('dialogueFinished', dialogueFinished)
    if dialogueBoxData.useMusic == true then
        playMusic(dialogueBoxData.musicName, 0, true)
        soundFadeIn(nil, 1, 0, 0.8)
    end
    if dialogueBoxData.useSoundIntro == true then
        playSound(dialogueBoxData.soundIntro)
    end
end

local dialogueList = {}
function createDialogueBox()
    local dialoguePath = ''
    local curLanguage = getPropertyFromClass('backend.ClientPrefs', 'data.language')
    if checkFileExists('data/'..songPath..'/dialogue_'..curLanguage..'.txt') then
        dialoguePath = callMethodFromClass('backend.Paths', 'txt', {songPath..'/dialogue_'..curLanguage})
    else
        dialoguePath = callMethodFromClass('backend.Paths', 'txt', {songPath..'/dialogue'})
    end
    dialogueList = callMethodFromClass('backend.CoolUtil', 'coolTextFile', {dialoguePath})
    
    setProperty('inCutscene', true)
    makeLuaSprite('dialogueBG')
    makeGraphic('dialogueBG', 2000, 2500, 'B3DFD8')
    screenCenter('dialogueBG')
    setObjectCamera('dialogueBG', 'camHUD')
    addLuaSprite('dialogueBG', true)
    if alpha ~= nil then
        setProperty('dialogueBG.alpha', alpha)
    else
        setProperty('dialogueBG.alpha', 0.7)
    end

    makeAnimatedLuaSprite('dialogueBox', 'dialogueUI/dialogueBox-garcello', -20, 350)
    addAnimationByPrefix('dialogueBox', 'open', 'garcellotextbox', 24, false)
    addAnimationByPrefix('dialogueBox', 'idle', 'garcellotextbox', 24, true)
    setObjectCamera('dialogueBox', 'camHUD')
    scaleObject('dialogueBox', 0.98, 0.98)
    screenCenter('dialogueBox', 'x')
    addLuaSprite('dialogueBox', true)
    playAnim('dialogueBox', 'open')

    makeAnimatedLuaSprite('portraitLeft', 'dialogueUI/portraits/portrait-'..dadDialogueData.name, -340, -420)
    addAnimationByPrefix('portraitLeft', 'appear', 'neutral', 24, false)
    setObjectCamera('portraitLeft', 'camHUD')
    setObjectOrder('portraitLeft', getObjectOrder('dialogueBox'))
    scaleObject('portraitLeft', 0.35, 0.35, false)
    addLuaSprite('portraitLeft', true)
    setProperty('portraitLeft.visible', false)

    makeAnimatedLuaSprite('portraitRight', 'dialogueUI/portraits/portrait-'..bfDialogueData.name, 370, -280)
    addAnimationByPrefix('portraitRight', 'appear', 'neutral', 24, false)
    setObjectCamera('portraitRight', 'camHUD')
    setObjectOrder('portraitRight', getObjectOrder('dialogueBox'))
    scaleObject('portraitRight', 0.4, 0.4, false)
    addLuaSprite('portraitRight', true)
    setProperty('portraitRight.visible', false)

    makeAnimatedLuaSprite('portraitMiddle', 'dialogueUI/portraits/portrait-'..gfDialogueData.name, 30, -400)
    addAnimationByPrefix('portraitMiddle', 'appear', 'neutral', 24, false)
    setObjectCamera('portraitMiddle', 'camHUD')
    setObjectOrder('portraitMiddle', getObjectOrder('dialogueBox'))
    scaleObject('portraitMiddle', 0.4, 0.4, false)
    addLuaSprite('portraitMiddle', true)
    setProperty('portraitMiddle.visible', false)

    createInstance('dialogueText', 'flixel.addons.text.FlxTypeText', {170, 435, 900, '', 32})
    setObjectCamera('dialogueText', 'camHUD')
    setTextFont('dialogueText', 'pixel-latin.ttf')
    setTextColor('dialogueText', 'FFFFFF')
    setTextBorder('dialogueText', 1, '000000', 'shadow')
    addInstance('dialogueText', true)
    callMethod('dialogueText.shadowOffset.set', {2, 2})
    runHaxeCode([[
        getLuaObject('dialogueText').sounds = [FlxG.sound.load(Paths.getFolderPath('sounds/pixelText.ogg', 'week6'), 0.6)];
        return; // DON'T REMOVE THIS LINE FOR THE LOVE OF GOD.
    ]])

    local skipText = getTranslationPhrase('dialogue_skip', 'Press BACK to Skip')
    makeLuaText('skipText', skipText, 300, screenWidth - 320, screenHeight - 30)
    setTextSize('skipText', 16)
    setTextFont('skipText', 'nokiafc22.ttf')
    setTextAlignment('skipText', 'right')
    setTextBorder('skipText', 2, '000000', 'outline_fast')
    addLuaText('skipText')
end

local dialogueData = {}
local dialogueStarted = false
local dialogueEnded = false
function onUpdatePost(elapsed)
    if getProperty('inCutscene') == true and dialogueFinished == false then
        if getProperty('dialogueBox.animation.finished') == true and dialogueStarted == false then
            dialogueStarted = true
            dialogueStart()
            playAnim('dialogueBox', 'idle')
        end

        if keyJustPressed('back') then
            if dialogueStarted == true then
                dialogueFinish()
            end
        elseif keyJustPressed('accept') then
            if dialogueEnded == true then
                if dialogueList[2] == nil and dialogueList[1] == nil then
                    if getProperty('dialogueText.paused') == false then
                        dialogueFinish()
                    else
                        dialogueStart()
                        playSound('clickText', 0.8)
                    end
                else
                    dialogueStart()
                    playSound('clickText', 0.8)
                end
            elseif dialogueStarted == true then
                dialogueSkip()
            end
        end

        -- This is how the script detects when the current dialogue is finished.
        if dialogueEnded == false then
            if dialogueData.pausePos[1] ~= nil then
                stopDialogue = dialogueData.pausePos[1]
            else
                stopDialogue = getProperty('dialogueText._finalText.length')
            end

            if getProperty('dialogueText._length') == stopDialogue then
                dialogueEnded = true
                setProperty('handSelectBox.visible', true)

                if dialogueData.pausePos[1] ~= nil then
                    setProperty('dialogueText.paused', true)
                    table.remove(dialogueData.pausePos, 1)
                end
            end
        end
    end
end

--[[
    This function starts the next dialogue line.
    Either it will reset the box to make the new dialogue appear,
    or it will continue the dialogue if it has detected a seperation line
    which is represented by this character '|' in the .txt file.
    It also switches and/or changes the character's expression of this dialogue.
]]
function dialogueStart()
    if getProperty('dialogueText.paused') == false then
        dialogueData = getCurrentDialogueData()
        callMethod('dialogueText.resetText', {dialogueData.text:gsub('|', '')})
    end
    callMethod('dialogueText.start', {0.04})

    dialogueEnded = false
    for char, side in pairs({dad = 'Left', bf = 'Right', gf = 'Middle'}) do
        if dialogueData.char == char then
            changeExpression(dialogueData.char, dialogueData.expression)
            if getProperty('portrait'..side..'.visible') == false then
                setProperty('portrait'..side..'.visible', true)
                playAnim('portrait'..side, 'appear', true)
            else
                callMethod('portrait'..side..'.animation.curAnim.finish')
            end
            setProperty('portrait'..side..'.alpha', 1)
        else
            setProperty('portrait'..side..'.alpha', 0)
        end
    end
end

--[[
    This function skips the current dialogue to the next one.
    It will either make the full text appear,
    or will skip to the dialogue line breaker
    represented by this character '|' in the .txt file.
]]
function dialogueSkip()
    if getProperty('dialogueText.paused') == false then
        if dialogueData.pausePos[1] ~= nil then
            setProperty('dialogueText._length', dialogueData.pausePos[1])
            setProperty('dialogueText.paused', true)
            table.remove(dialogueData.pausePos, 1)
        else
            callMethod('dialogueText.skip')
        end
    end
    playSound('clickText', 0.8)
    dialogueEnded = true
end

--[[
    This function ends the dialogue and closes the dialogue box,
    skipping the current one if it hasn't been finished.
]]
function dialogueFinish()
    dialogueSkip()
    dialogueFinished = true
    setVar('dialogueFinished', dialogueFinished)
    cancelTimer('dialogueBGFadeIn')
    if dialogueBoxData.useMusic == true then
        soundFadeOut(nil, 1.5, 0)
    end
    setProperty('skipText.visible', false)
    runTimer('destroyDialogueBox', 0.2, 5)
    runTimer('startGame', 1.5)
end

--[[
    This function gets the current dialogue line,
    the character and their expression.
    It also checks if there are any pause during the dialogue
    that are represented by this character '|', and saves their position.
]]
function getCurrentDialogueData()
    local split = stringSplit(dialogueList[1], '::')
    table.remove(dialogueList, 1)

    runHaxeCode([[
        function detectPause(dialogue:String) {
            var result:Array<Int> = [];
            var pause = dialogue.indexOf("|");
            
            while (pause != -1) {
                result.push(pause);
                pause = dialogue.indexOf("|", pause + 1);
            }

            if (result[0] != null) {
                for (i in 0...result.length) result[i] -= i;
            }

            return result;
        }
    ]])

    return {char = split[1], expression = split[2], text = split[3], pausePos = runHaxeFunction('detectPause', {split[3]})}
end

-- This function is what makes the characters change their expression.
function changeExpression(character, newExpression)
    local charSide = ''
    local charName = ''
    local charExpressions = {}
    for char, side in pairs({dad = 'Left', bf = 'Right', gf = 'Middle'}) do
        if character == char then
            charSide = side
            charName = _G[character..'DialogueData'].name
            charExpressions = _G[character..'DialogueData'].expressions
        end
    end

    for expression, offset in pairs(charExpressions) do
        if expression == newExpression then
            addAnimationByPrefix('portrait'..charSide, 'appear', newExpression, 24, false)
            addOffset('portrait'..charSide, 'appear', offset.x, offset.y)
            playAnim('portrait'..charSide, 'appear')
        end
    end
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == 'dialogueBGFadeIn' then
        alpha = ((loops - loopsLeft) / loops) * 0.7
        setProperty('dialogueBG.alpha', alpha)
    end
    if tag == 'destroyDialogueBox' then
        for i, object in ipairs({'dialogueBG', 'dialogueBox', 'dialogueText', 'skipText'}) do
            if i == 1 then
                setProperty(object..'.alpha', getProperty(object..'.alpha') - (1 / 5) * 0.7)
            else
                setProperty(object..'.alpha', getProperty(object..'.alpha') - (1 / 5))
            end
        end
        for _, side in ipairs({'Left', 'Right', 'Middle'}) do
            setProperty('portrait'..side..'.visible', false)
        end 
    end
    if tag == 'startGame' then
        for i, object in ipairs({'dialogueBG', 'dialogueBox', 'dialogueText', 'skipText'}) do
            if i < 4 then
                removeLuaSprite(object)
            else
                removeLuaText(object)
            end
        end
        for _, side in ipairs({'Left', 'Right', 'Middle'}) do
            removeLuaSprite('portrait'..side)
        end
        triggerEvent('Set Camera Target', '', '')
        startCountdown()
    end
end