#1 ------------------------ fresh start
t = Task.async(fn -> Process.sleep(5_000); IO.puts("process complete"); 5 + 5 end)
# %Task{
#   owner: #PID<0.109.0>,
#   pid: #PID<0.124.0>,
#   ref: #Reference<0.3381444758.1549598723.215459>
# }

flush
# {#Reference<0.3381444758.1549598723.215459>, 10}
# {:DOWN, #Reference<0.3381444758.1549598723.215459>, :process, #PID<0.124.0>,
#  :normal}
# :ok




#2 ------------------ Task await
t = Task.async(fn -> Process.sleep(15_000); IO.puts("process complete"); 5 + 5 end)
Task.await t
# // error after 5 seconds
Task.await t
# // message after 10 seconds



#3 ----------------- Task yield
t = Task.async(fn ->  Process.sleep(15_000); IO.puts("process complete"); 5 + 5 end)

 Task.yield t
# // nil after 5 seconds
 Task.yield t
# // value after next 5 seconds

# ------------------ adding timeouts

t = Task.async(fn -> Process.sleep(15_000); IO.puts("process complete"); 5 + 5 end)
Task.await t, 15_000
t = Task.async(fn -> Process.sleep(15_000); IO.puts("process complete"); 5 + 5 end)
Task.yield t, 15_000

# ------------------- Task shutdown

t = Task.async(fn -> Process.sleep(15_000); IO.puts("process complete"); 5 + 5 end)
Process.alive? t.pid
Task.shutdown t
Process.alive? t.pid

# ----------------- Task ignore

t = Task.async(fn -> Process.sleep(15_000); IO.puts("process complete"); 5 + 5 end)
# %Task{
#   owner: #PID<0.109.0>,
#   pid: #PID<0.112.0>,
#   ref: #Reference<0.584582221.1549074433.179159>
# }

Process.info(self, :links)
# {:links, [#PID<0.116.0>]}

Task.ignore t
# nil

self |> Process.info( :links)
# {:links, []}


Process.alive? t.pid
# false
#  (after 15 seconds)

flush
# :ok
# -> empty mailbox as we de-linked the task

# ---------------------
