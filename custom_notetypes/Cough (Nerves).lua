function opponentNoteHitPre(index, noteData, noteType, isSustain)
    if noteType == 'Cough (Nerves)' then
        playAnim('dad', 'cough', true)
        setProperty('dad.specialAnim', true)
        setPropertyFromGroup('notes', index, 'ignoreNote', true)
        return Function_Stop
    end
end

function goodNoteHit(index, noteData, noteType, isSustain)
    if noteType == 'Cough (Nerves)' then
        playAnim('boyfriend', 'cough', true)
        setProperty('boyfriend.specialAnim', true)
    end
end