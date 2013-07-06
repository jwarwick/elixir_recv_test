defmodule ElixirRecvTest do
  @moduledoc """
  Sample code inspired by Benjamin Tan's blog post about Elixir processes
  [http://benjamintanweihao.github.io/blog/2013/07/04/elixir-for-the-lazy-impatient-and-busy-part-3-processes-101/][]
  """

  def hola_recv_recurse do
    IO.puts "Process: in 'hola'"
    receive do
      {sender, msg} ->
        IO.puts "Process: recv msg: #{msg} from"
        IO.inspect sender
        sender <- {:ok, "Received: '#{msg}'"}
        hola_recv_recurse
    end
    IO.puts "Process: after 'receive'"
  end
end
