defmodule Servy do
  use Application

  def start(_type, _args) do
    IO.puts("Starting the application...")
    Servy.Supervisor.start_link()
  end

  @moduledoc """
  Documentation for `Servy`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Servy.hello()
      :world

  """
  def hello() do
    :world
  end
end

IO.puts(Servy.hello())
