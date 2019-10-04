defmodule MemoryWeb.GamesChannel do
  use MemoryWeb, :channel

  alias Memory.Game
  alias Memory.BackupAgent

  def join("memory:" <> name, payload, socket) do
    if authorized?(payload) do
      oldGame = BackupAgent.get(name)
      game = if oldGame == :nil do
        Game.new()
      else 
        oldGame
      end

      socket = socket
      |> assign(:game, game)
      |> assign(:name, name)
      BackupAgent.put(name, game)
      {:ok, %{"join" => name, "game" => Game.client_view(game)}, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_in("guess", %{"game" => game, "tileId" => tileId}, socket) do
    name = socket.assigns[:name]
    game = Game.guess(socket.assigns[:game], tileId)
    # Attribution: Usage of reduce method was taken from: https://hexdocs.pm/elixir/Enum.html#reduce/3
    bCompleted = Enum.reduce(game.status, true, fn st, acc -> st and acc end)
      if bCompleted == true do
        total = Game.computeScore(game)
        game = Map.put(game, :completed, true)
        game = Map.put(game, :score, total)
        socket = assign(socket, :game, game)
        BackupAgent.put(name, game)
        {:reply, {:completed, %{ "game" => Game.client_view(game) }}, socket}
      else
        socket = assign(socket, :game, game)
        BackupAgent.put(name, game)
        {:reply, {:ok, %{ "game" => Game.client_view(game) }}, socket}
      end
  end

  def handle_in("reset", _, socket) do
    game = Game.new()
    socket = socket
    |> assign(:game, game)
    name = socket.assigns[:name]
    BackupAgent.put(name, game)
    {:reply, {:ok, %{ "game" => Game.client_view(game) }}, socket}
  end

  def handle_in("resetStateFor", %{"game" => game, "index1" => index1, "index2" => index2}, socket) do
    name = socket.assigns[:name]
    game = Game.resetState(socket.assigns[:game], index1, index2)
    socket = assign(socket, :game, game)
    BackupAgent.put(name, game)
    {:reply, {:ok, %{ "game" => Game.client_view(game) }}, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
