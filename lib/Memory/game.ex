defmodule Memory.Game do
  def new do
    %{
      tiles: newTiles(),
      status: [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false],
      colors: ["black", "black", "black", "black", "black", "black", "black", "black", "black", "black", "black", "black", "black", "black", "black", "black"],
      clickOne: :nil,
      clickTwo: :nil,
      score: 0,
      completed: false
    }
  end

  def client_view(game) do
    %{
      tiles: game.tiles,
      status: game.status,
      colors: game.colors,
      score: game.score,
      completed: game.completed,
      clickOne: game.clickOne,
      clickTwo: game.clickTwo
    }
  end

  def matchFound(game) do
    if game.clickOne != :nil && game.clickTwo != :nil do
      Enum.at(game.tiles, game.clickOne) == Enum.at(game.tiles, game.clickTwo) 
      && Enum.at(game.status, game.clickOne) == true 
      && Enum.at(game.status, game.clickTwo) == true
    else 
      false
    end
  end

  def computeScore(game) do
    100 - ((game.score - 16) * 0.5)
  end

  def guess(game, tileNo) do
    if game.clickOne == tileNo || game.clickTwo == tileNo do
	game
    else

    	game = if Map.get(game, :clickOne) == :nil do
      		game = Map.put(game, :clickOne, tileNo)
    	else 
      		if Map.get(game, :clickTwo) == :nil do
        		game = Map.put(game, :clickTwo, tileNo)
      		else
        		raise "Unsupported action"
      		end
    	end
    
    	newStatus = List.replace_at(game.status, tileNo, true)
    	game = Map.put(game, :status, newStatus)
    	game = Map.update(game, :score, 0, &(&1 + 1))

    	bMatchFound = matchFound(game)
    	game = if bMatchFound == true do
      	greenStatus = List.replace_at(game.colors, game.clickOne, "completed")
      	greenStatus2 = List.replace_at(greenStatus, tileNo, "completed")
      	game = Map.put(game, :colors, greenStatus2)
      	game = Map.put(game, :clickOne, :nil)
      	game = Map.put(game, :clickTwo, :nil)
    	else
      		if Map.get(game, :clickTwo) == :nil do
        		grayStatus = List.replace_at(game.colors, tileNo, "lightgray")
        		game = Map.put(game, :colors, grayStatus)
      		else
        		redStatus = List.replace_at(game.colors, game.clickOne, "red")
        		redStatus2 = List.replace_at(redStatus, game.clickTwo, "red")
        		game = Map.put(game, :colors, redStatus2)
        		game = Map.put(game, :clickOne, :nil)
        		game = Map.put(game, :clickTwo, :nil)
      		end
    	end
    end
  end

  def newTiles do
    tiles = ["A", "B", "C", "D", "E", "F", "G", "H", "A", "B", "C", "D", "E", "F", "G", "H"]
    """
        Attribution: Shuffling of tiles using enum was taken from: https://www.programming-idioms.org/idiom/10/shuffle-a-list/909/elixir
    """
    Enum.shuffle(tiles)
  end

  def resetState(game, index1, index2) do
    newStatus = List.replace_at(game.status, index1, false)
    newStatus2 = List.replace_at(newStatus, index2, false)
    game = Map.put(game, :status, newStatus2)

    blackStatus = List.replace_at(game.colors, index1, "black")
    blackStatus2 = List.replace_at(blackStatus, index2, "black")
    game = Map.put(game, :colors, blackStatus2)
  end
end
