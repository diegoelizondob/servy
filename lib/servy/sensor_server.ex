defmodule Servy.SensorServer do

  @name :sensor_server
  @refresh_interval :timer.minutes(60)

  alias Servy.VideoCam
  alias Servy.Tracker

  use GenServer

  # Client Interface

  def start_link(interval) do
    IO.puts("Starting the sensor server with #{interval} min refresh...")
    GenServer.start_link(__MODULE__, %{}, name: @name)
  end

  def get_sensor_data() do
    GenServer.call(@name, :get_sensor_data)
  end

  # Server Callbacks

  def init(_state) do
    initial_state = run_tasks_to_get_sensor_data()
    schedule_refresh()
    {:ok, initial_state}
  end

  def handle_info(:refresh, _state) do
    IO.puts("Refreshing the cache...")
    new_state = run_tasks_to_get_sensor_data()
    schedule_refresh()
    {:noreply, new_state}
  end

  defp schedule_refresh() do
    Process.send_after(self(), :refresh, @refresh_interval)
  end

  def handle_call(:get_sensor_data, _from, state) do
    {:reply, state, state}
  end

  defp run_tasks_to_get_sensor_data() do
    IO.puts("Running tasks to get sensor data...")

    task = Task.async(fn -> Tracker.get_location("bigfoot") end)

    snapshots =
    ["cam1", "cam2", "cam3"]
    |> Enum.map(&Task.async(fn -> VideoCam.get_snapshot(&1) end))
    |> Enum.map(&Task.await(&1))

    where_is_bigfoot = Task.await(task)

    %{snapshots: snapshots, location: where_is_bigfoot}
  end

end
