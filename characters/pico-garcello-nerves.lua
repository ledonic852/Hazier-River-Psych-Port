function onCreate()
    if boyfriendName == 'pico-garcello-nerves' then
        pauseMusic = getPropertyFromClass('backend.ClientPrefs', 'data.pauseMusic')
        setPropertyFromGameOver('characterName', 'pico-garcello-dead')
        setPropertyFromGameOver('deathSoundName', 'fnf_loss_sfx-pico')
        setPropertyFromGameOver('loopSoundName', 'gameOver-pico')
        setPropertyFromGameOver('endSoundName', 'gameOverEnd-pico')

        runHaxeCode([[
            function getScreenPosition(character:String) {
                var characterPos:Array<Dynamic>;
                switch(character) {
                    case 'boyfriend':
                        characterPos = game.boyfriend.getScreenPosition();
                    case 'dad':
                        characterPos = game.dad.getScreenPosition();
                    case 'gf':
                        characterPos = game.gf.getScreenPosition();
                    default:
                        return;
                }
                return [characterPos.x, characterPos.y];
            }
        ]])
    end
end

function onPause()
    --[[
        Checks and replaces the Pause Menu music to the '-(pico)' version, if there's one.
        If not, it'll keep the original one.
        Ex: 'Tea Time' will stay the same since there isn't a 'tea-time-(pico)' present in the files.
    ]]
    if boyfriendName == 'pico-garcello-nerves' then
        fileName = pauseMusic:gsub(' ', '-'):lower()
        if checkFileExists('music/'..fileName..'-(pico).ogg') then
            setPropertyFromClass('backend.ClientPrefs', 'data.pauseMusic', pauseMusic..' (Pico)')
        end
    end
end

function onDestroy()
    --[[ 
        Since we don't want the Pause Menu to stay stuck to the '-pico' version all the time,
        we revert it back to normal to avoid any issues and keep it exclusive to our character.
    ]]
    if boyfriendName == 'pico-garcello-nerves' and stringEndsWith(getPropertyFromClass('backend.ClientPrefs', 'data.pauseMusic'), ' (Pico)') then
        setPropertyFromClass('backend.ClientPrefs', 'data.pauseMusic', pauseMusic)
    end
end

local isBurping = false
function goodNoteHitPre(index, noteData, noteType, isSustain)
    if boyfriendName == 'pico-garcello-nerves' then
        if isBurping and isSustain then
            setPropertyFromGroup('notes', index, 'noAnimation', true)
        end
    end
end

function goodNoteHit(index, noteData, noteType, isSustain)
    if boyfriendName == 'pico-garcello-nerves' then
        if isBurping then
            if not isSustain then
                cancelTimer('burpAnim')
                setProperty('vocals.volume', 1)
                stopSound('burpSound')
                isBurping = false
            else
                setProperty('vocals.volume', 0)
            end
        end

        if getRandomBool(0.01) and not isSustain and noteType == '' then
            unlockAchievement('rude_ass')
            playAnim('boyfriend', 'burp', true)
            setProperty('boyfriend.specialAnim', true)
            setProperty('vocals.volume', 0)
            playSound('burp', 1, 'burpSound')
            runTimer('burpAnim', getProperty('boyfriend.animation.curAnim.numFrames') / 24)
            isBurping = true
        end
    end
end

function noteMiss(index, noteData, noteType, isSustain)
    if boyfriendName == 'pico-garcello-nerves' then
        if isBurping then
            cancelTimer('burpAnim')
            stopSound('burpSound')
        end
    end
end

function noteMissPress(direction)
    if boyfriendName == 'pico-garcello-nerves' then
        if isBurping then
            cancelTimer('burpAnim')
            stopSound('burpSound')
        end
    end
end

local gfPos = {}
function onGameOver()
    if boyfriendName == 'pico-garcello-nerves' then
        gfPos = runHaxeFunction('getScreenPosition', {'gf'})
    end
end

function onGameOverStart()
    if boyfriendName == 'pico-garcello-nerves' then
        makeAnimatedLuaSprite('gameOverRetry', 'characters/Pico_Death_Retry', getPropertyFromGameOver('boyfriend.x') + 205, getPropertyFromGameOver('boyfriend.y') - 80)
        addAnimationByPrefix('gameOverRetry', 'idle', 'Retry Text Loop0')
        addAnimationByPrefix('gameOverRetry', 'confirm', 'Retry Text Confirm0', 24, false)
        addOffset('gameOverRetry', 'confirm', 250, 200)
        addLuaSprite('gameOverRetry', true)
        setProperty('gameOverRetry.visible', false)
            
        makeAnimatedLuaSprite('neneDeathSprite', 'characters/NeneKnifeToss', gfPos[1] + 150, gfPos[2])
        addAnimationByPrefix('neneDeathSprite', 'throw', 'knife toss0', 24, false)
        addLuaSprite('neneDeathSprite', true)
    end
end

function onUpdate(elapsed)
    if boyfriendName == 'pico-garcello-nerves' and inGameOver == true then
        if getProperty('neneDeathSprite.animation.finished') then
            setProperty('neneDeathSprite.visible', false)
        end
        if getPropertyFromGameOver('boyfriend.animation.curAnim.name') == 'firstDeath' then
            if getPropertyFromGameOver('boyfriend.animation.curAnim.curFrame') == 35 then
                playAnim('gameOverRetry', 'idle')
                setProperty('gameOverRetry.visible', true)
            end
        end
    end
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == 'burpAnim' then
        playAnim('boyfriend', 'burp-loop', true)
        setProperty('boyfriend.specialAnim', true)
    end
end

function onGameOverConfirm(isNotGoingToMenu)
    if isNotGoingToMenu == true and boyfriendName == 'pico-garcello-nerves' then
        playAnim('gameOverRetry', 'confirm')
        setProperty('gameOverRetry.visible', true)
    end
end

function getPropertyFromGameOver(property)
    if getPropertyFromClass('substates.GameOverSubstate', property) ~= nil then
        return getPropertyFromClass('substates.GameOverSubstate', property)
    else
        return getPropertyFromClass('substates.GameOverSubstate', 'instance.'..property)
    end
end

function setPropertyFromGameOver(property, value)
    if getPropertyFromClass('substates.GameOverSubstate', property) ~= nil then
        setPropertyFromClass('substates.GameOverSubstate', property, value)
    else
        setPropertyFromClass('substates.GameOverSubstate', 'instance.'..property, value)
    end
end