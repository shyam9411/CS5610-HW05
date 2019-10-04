#Attribution: Backup agent module were defined as mentioned in the repo: https://github.com/NatTuck/scratch-2019-09/tree/master/5610/08/hangman
defmodule Memory.BackupAgent do
    use Agent
  
    def start_link(_args) do
      Agent.start_link(fn -> %{} end, name: __MODULE__)
    end
  
    def put(name, val) do
      Agent.update __MODULE__, fn state ->
        Map.put(state, name, val)
      end
    end
  
    def get(name) do
      Agent.get __MODULE__, fn state ->
        Map.get(state, name)
      end
    end
  
  
  end
  