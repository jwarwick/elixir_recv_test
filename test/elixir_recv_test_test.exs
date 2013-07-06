Code.require_file "test_helper.exs", __DIR__

defmodule ElixirRecvTestTest do
  use ExUnit.Case

  # note: use assert_receive, not assert_received, since it has
  # a non-zero timeout and the debugging IO.puts take too long

  test "loop in receive" do
    pid = ElixirRecvTest.spawn_recv_recurse
    pid <- {self, "msg"}
    assert_receive {:ok, _}
    pid <- {self, "msg"}
    assert_receive {:ok, _}
  end

  test "loop after receive" do
    pid = ElixirRecvTest.spawn_tail_recurse
    pid <- {self, "msg"}
    assert_receive {:ok, _}
    pid <- {self, "msg"}
    assert_receive {:ok, _}
  end
end
