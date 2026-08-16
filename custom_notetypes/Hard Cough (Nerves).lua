function opponentNoteHitPre(index, noteData, noteType, isSustain)
    if noteType == 'Hard Cough (Nerves)' then
        playAnim('dad', 'coughHard', true)
        setProperty('dad.specialAnim', true)
        setPropertyFromGroup('notes', index, 'ignoreNote', true)
        return Function_Stop
    end
end

function goodNoteHit(index, noteData, noteType, isSustain)
    if noteType == 'Hard Cough (Nerves)' then
        playAnim('boyfriend', 'coughHard', true)
        setProperty('boyfriend.specialAnim', true)
    end
end