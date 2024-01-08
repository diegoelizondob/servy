defmodule Servy.HttpServer do

  @doc """
  Starts the server on the given 'port' of localhost
  """
  def start(port) when is_integer(port) and port > 1023 do
    # Creates a socket to listen for client connections.
    # 'listen_socket' is bound to the listening socket.
    {:ok, listen_socket} =
      :gen_tcp.listen(port, [:binary, packet: :raw, active: false, reuseaddr: true])

    #Socket options (don't worry about these details):
    # :binary - open the socket in binary mode and deliver data as binaries
    # packet: :raw - deliver the entire binary without doing any packet handling
    #active: false - receive data when we're ready by calling :gen_tcp.recv/2
    # reuseaddr: true - allows reusing the address if the listener crashes

    IO.puts("\n Listening for connection requests on port #{port}...\n")

    accept_loop(listen_socket)
  end

  def accept_loop(listen_socket) do
    IO.puts " Waiting to accept a client connection...\n"

    # Suspends (blocks) and waits for a client connection. When a connection
    # is accepted, client_socket is bound to a new client socket.
    {:ok, client_socket} = :gen_tcp.accept(listen_socket)

    IO.puts " Connection accepted!\n"

    #Receives the req and sends a res over the client socket.
    spawn(fn -> serve(client_socket) end)

    # Loop back to wait and accept the next connection.
    accept_loop(listen_socket)
  end

  def serve(client_socket) do
    IO.puts "#{inspect(self())}: working on it!"

    client_socket
    |> read_request()
    |> Servy.Handler.handle()
    |> write_response(client_socket)
  end

  def read_request(client_socket) do
    {:ok, request} = :gen_tcp.recv(client_socket, 0)

    IO.puts("Recieved request:\n")
    IO.puts(request)
    request
  end

  def write_response(response, client_socket) do
    :ok = :gen_tcp.send(client_socket, response)

    IO.puts("sent response:\n")
    IO.puts(response)

    :gen_tcp.close(client_socket)
  end

  def server do
    {:ok, lsock} = :gen_tcp.listen(5678, [:binary, packet: 0,
                                        active: false])
    {:ok, sock} = :gen_tcp.accept(lsock)
    {:ok, bin} = :gen_tcp.recv(sock, 0)
    :ok = :gen_tcp.close(sock)
    bin
  end
end

# ERLANG CODE:
# server() ->
#   {ok, LSock} = gen_tcp:listen(5678, [binary, {packer, 0},
#                                       {active, false}]),
#   {ok, Sock} = gen_tcp:accept(LSock),
#   {ok, Bin} = do_recv(Sock, []),
#   ok = gen_tcp:close(Sock),
#   Bin.
