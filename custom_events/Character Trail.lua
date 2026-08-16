function onEventPushed(event, value1, value2, strumTime)
    if event == 'Character Trail' and value1 == '1' then
        addCharacterToList('bf-garcello-trail', 'bf')
    end
end

isTrailActive = false
trailElapsed = 0
function onEvent(event, value1, value2, strumTime)
    if event == 'Character Trail' then
        isTrailActive = (value1 == '1')
        trailElapsed = stepCrochet / 1000
    end
end

local trailSprites = {}
function onUpdate(elapsed)
    if isTrailActive then
        trailElapsed = trailElapsed + elapsed

        while trailElapsed >= stepCrochet / 1000 do
            trailElapsed = trailElapsed - (stepCrochet / 1000)
            local trailOffsets = getOffsetsFromAnim(callMethod('boyfriend.getAnimationName', {}))

            if trailOffsets ~= nil then
                local trailTweenTag = 'moveTrail'..(#trailSprites + 1)
                local trailSpriteTag = 'trailSprite'..(#trailSprites + 1)

                createTrail('boyfriend', 0x66FFFF)
                doTweenX(trailTweenTag..'X', trailSpriteTag, getProperty(trailSpriteTag..'.x') + trailOffsets[1], 2 * (60 / curBpm), 'circOut')
                doTweenY(trailTweenTag..'Y', trailSpriteTag, getProperty(trailSpriteTag..'.y') + trailOffsets[2], 2 * (60 / curBpm), 'circOut')
                doTweenAlpha(trailTweenTag..'Alpha', trailSpriteTag, 0, 2 * (60 / curBpm), 'circOut')
            end
        end
    end
end

function onTweenCompleted(tag)
    for i, trailData in ipairs(trailSprites) do
        local trailTweenTag = 'moveTrail'..i
        if stringStartsWith(tag, trailTweenTag) and trailData.active then
            trailSprites[i].active = false
            removeLuaSprite(trailData.tag)
        end
    end
end

function createTrail(target, color)
    local trailSpriteTag = 'trailSprite'..(#trailSprites + 1)
    createInstance(trailSpriteTag, 'objects.Character', {getCharacterX(target), getCharacterY(target), getProperty(target..'.curCharacter')..'-trail', (target == 'boyfriend')})
    setObjectOrder(trailSpriteTag, getObjectOrder(target..'Group'))
    addInstance(trailSpriteTag)
    playAnim(trailSpriteTag, callMethod(target..'.getAnimationName', {}), true)
    
    setProperty(trailSpriteTag..'.x', getProperty(trailSpriteTag..'.x') + getProperty(trailSpriteTag..'.positionArray[0]'))
    setProperty(trailSpriteTag..'.y', getProperty(trailSpriteTag..'.y') + getProperty(trailSpriteTag..'.positionArray[1]'))
    setProperty(trailSpriteTag..'.color', color)
    setProperty(trailSpriteTag..'.animation.curAnim.curFrame', getProperty(target..'.animation.curAnim.curFrame'))
    table.insert(trailSprites, {tag = trailSpriteTag, active = true})
end

function getOffsetsFromAnim(curAnim)
    if not stringStartsWith(curAnim, 'sing') then
        return nil
    end

    local singOffsets = {LEFT = {-1, 0}, DOWN = {0, 1}, UP = {0, -1}, RIGHT = {1, 0}}
    for DIRECTION, mult in pairs(singOffsets) do
        if curAnim == 'sing'..DIRECTION then
            return {60 * mult[1], 60 * mult[2]}
        end
    end
end