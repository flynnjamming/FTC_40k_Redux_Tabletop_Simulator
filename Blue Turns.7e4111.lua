-- FTC-GUID: 7e4111
-- Description contains the guid of game turn counter


function increaseSelf()
        self.Counter.increment()
        gameUpdate()

end

function gameUpdate()
    guidGC=self.getDescription()
    gameTurn=getObjectFromGUID(guidGC)
    if gameTurn == nil then
    else
        if self.Counter.getValue() > gameTurn.Counter.getValue() then
            gameTurn.Counter.setValue(self.Counter.getValue())
            gameTurn.call("checkGameEnd")
        end
    end
end