require_relative "view/gameView"

view = GameView.new
view.startNewGame

while view.getGameStatus != GameStatus::ENDED
    view.getPlayerController.takeTurn
end
