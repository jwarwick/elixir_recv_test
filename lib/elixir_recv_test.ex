defmodule ElixirRecvTest do
  @moduledoc """
  Sample code inspired by Benjamin Tan's blog post about Elixir processes
  [http://benjamintanweihao.github.io/blog/2013/07/04/elixir-for-the-lazy-impatient-and-busy-part-3-processes-101/][]
  """

  @doc """
  Spawn a process running `hola_no_recurse`
  """
  def spawn_no_recurse do
    spawn(ElixirRecvTest, :hola_no_recurse, [])
  end

  @doc """
  Spawn a process running `hola_recv_recurse`
  """
  def spawn_recv_recurse do
    spawn(ElixirRecvTest, :hola_recv_recurse, [])
  end

  @doc """
  Spawn a process running `hola_tail_recurse`
  """
  def spawn_tail_recurse do
    spawn(ElixirRecvTest, :hola_tail_recurse, [])
  end

  @doc """
  Spawn a process running `hola_tail_recurse_two`
  """
  def spawn_tail_recurse_two do
    spawn(ElixirRecvTest, :hola_tail_recurse_two, [])
  end

  @doc """
  Sends one message to `sender_pid` with the given `text`.
  Waits for a reply of the form `{:ok, reply_test}`
  """
  def send_msg(sender_pid, text) do
    sender_pid <- {self, text}
    receive do
      {:ok, msg} -> IO.puts "send_msg: received reply `#{msg}`"
    after
      1000 -> IO.puts "send_msg: didn't get a reply"
    end
  end

  @doc """
  Sends `n` messages to `sender_pid` using `send_msg/1`.
  Waits for a reply after sending each message.
  """
  def send_msg(sender_pid, text, n) do
    1..n |> 
         Enum.map(fn(x) -> send_msg(sender_pid, text <> " " <> to_binary(x)) end)
    :ok
  end

  @doc """
  Listen for a message of the form `{sender_pid, msg}` and 
  sends a message back to `sender_pid` of the form `{:ok, "Received: 'msg'}`.

  Does not loop
  """
  def hola_no_recurse do
    IO.puts "Process: in 'hola_no_recurse'"
    receive do
      {sender, msg} ->
        IO.puts "Process: recv msg: #{msg} from"
        IO.inspect sender
        sender <- {:ok, "Received: '#{msg}'"}
    end
    IO.puts "Process: after 'receive'"
  end

  @doc """
  Listen for a message of the form `{sender_pid, msg}` and 
  sends a message back to `sender_pid` of the form `{:ok, "Received: 'msg'}`.

  Loops inside the `receive` block
  """
  def hola_recv_recurse do
    IO.puts "Process: in 'hola_recv_recurse'"
    receive do
      {sender, msg} ->
        IO.puts "Process: recv msg: #{msg} from"
        IO.inspect sender
        sender <- {:ok, "Received: '#{msg}'"}
        hola_recv_recurse
    end
    IO.puts "Process: after 'receive'"
  end

  @doc """
  Listen for a message of the form `{sender_pid, msg}` and 
  sends a message back to `sender_pid` of the form `{:ok, "Received: 'msg'}`.

  Loops after the `receive` block
  """
  def hola_tail_recurse do
    IO.puts "Process: in 'hola_tail_recurse'"
    receive do
      {sender, msg} ->
        IO.puts "Process: recv msg: #{msg} from"
        IO.inspect sender
        sender <- {:ok, "Received: '#{msg}'"}
    end
    IO.puts "Process: after 'receive'"
    hola_tail_recurse
  end

  @doc """
  Listen for a message of the form `{sender_pid, msg}` and 
  sends a message back to `sender_pid` of the form `{:ok, "Received: 'msg'}`.

  Then listens for another message (one may already be in the mailbox...)
  and prints it out.

  Loops after the `receive` block
  """
  def hola_tail_recurse_two do
    IO.puts "Process: in 'hola_tail_recurse_two'"
    receive do
      {sender, msg} ->
        IO.puts "Process: recv msg: #{msg} from"
        IO.inspect sender
        sender <- {:ok, "Received: '#{msg}'"}
    end
    IO.puts "Process: after 'receive'"

    receive do
      msg -> IO.puts "Process: recv second message:"
             IO.inspect msg
    end

    IO.puts "Process after generic 'receive'"
    hola_tail_recurse_two
  end
end
