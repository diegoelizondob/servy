defmodule Servy.VideoCam do
  @doc """
  Simulates sending a req to an external API
  to get a snapshot image from a video cam
  """
  def get_snapshot(camera_name) do
    # CODE GOES HERE TO SEND A REQ TO THE EXTERNAL API

    # Sleep for 1 sec to simulate thtat the API can be slow:
    :timer.sleep(1000)

    # Example response returned from the API:
    "#{camera_name}-snapshot-#{:rand.uniform(1000)}.jpg"
  end
end
