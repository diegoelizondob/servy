defmodule Servy.Tracker do
  @doc """
  Simulates sending a req to an external API
  to get the GPS coordinats of a wildthing
  """
  def get_location(wildthing) do
    # CODE GOES HERE TO SEND A REQ TO API

    :timer.sleep(500)

    locations = %{
      "roscoe" => %{ lat: "44.4280 N", lgn: "110.5885 W"},
      "smokey" => %{ lat: "48.7596 N", lgn: "113.7870 W"},
      "brutus" => %{ lat: "43.7904 N", lgn: "110.6818 W"},
      "bigfoot" => %{ lat: "29.0469 N", lgn: "98.8667 W"},
    }

    Map.get(locations, wildthing)
  end
end
