### First attempt

##### log 

```elixir
ameters: %{"_target" => ["image"]}

21:06:17.784 [debug] Replied in 196µs
init NOW!!: {:ok,
 %ExampleWeb.S3Writer{
   parts: [],
   chunk: 1,
   s3_upload_op: %{},
   s3_init_op: %{},
   s3_config: %{
     access_key_id: "3477cea2b6d1",
     bucket: "sample-app",
     host: "61bc05f9c4bc2bfa6436a.r2.cloudflarestorage.com",
     http_client: ExAws.Request.Hackney,
     json_codec: Jason,
     normalize_path: true,
     port: 443,
     region: "us-east-1",
     require_imds_v2: false,
     retries: [
       max_attempts: 10,
       base_backoff_in_ms: 10,
       max_backoff_in_ms: 10000
     ],
     scheme: "https://",
     secret_access_key: "e829b201f2a47e56fa0a"
   },
   filename: "yoga_for_belly.mp4"
 }}

21:06:17.812 [info] JOINED lvu:0 in 9ms
  Parameters: %{"token" => "SFMyNTY.g2gDaAJhBXQAAAADZAADY2lkZAADbmlsZAADcGlkWGQADW5vbm9kZUBub2hvc3QAAAGyAAAAAAAAAABkAANyZWZoAm0AAAAUcGh4LUY0eDZiaTZHRmdSdC1RUENtAAAAATBuBgCC-BQViwFiAAFRgA.UQQtx2AbuQVWAOesOu2PLvlTBgxll3NPdOBWuqsAspY"}
Why is reason = : :cancel

21:06:18.007 [error] GenServer #PID<0.435.0> terminating
** (KeyError) key :bucket not found in: %{}
    (ex_aws_s3 2.5.0) lib/ex_aws/s3/upload.ex:84: ExAws.S3.Upload.upload_chunk!/3
    (ex_aws_s3 2.5.0) lib/ex_aws/s3/upload.ex:41: ExAws.S3.Upload.complete/3
    sample.exs:123: ExampleWeb.S3Writer.close/2
    (phoenix_live_view 0.20.0) lib/phoenix_live_view/upload_channel.ex:234: Phoenix.LiveView.UploadChannel.close_writer/2
    (phoenix_live_view 0.20.0) lib/phoenix_live_view/upload_channel.ex:223: Phoenix.LiveView.UploadChannel.maybe_cancel_writer/1
    (phoenix_live_view 0.20.0) lib/phoenix_live_view/upload_channel.ex:170: Phoenix.LiveView.UploadChannel.terminate/2
    (stdlib 4.3.1.2) gen_server.erl:1161: :gen_server.try_terminate/3
    (stdlib 4.3.1.2) gen_server.erl:1351: :gen_server.terminate/10
Last message: %Phoenix.Socket.Message{topic: "lvu:0", event: "chunk", payload: {:binary, <<0, 0, 0, 32, 102, 116, 121, 112, 105, 115, 111, 109, 0, 0, 2, 0, 105, 115, 111, 109, 105, 115, 111, 50, 97, 118, 99, 49, 109, 112, 52, 49, 0, 14, 185, 163, 109, 111, 111, 118, 0, 0, 0, 108, 109, ...>>}, ref: "13", join_ref: "12"}
State: %Phoenix.Socket{assigns: %{chunk_timeout: 10000, chunk_timer: nil, done?: false, live_view_pid: #PID<0.434.0>, max_file_size: 90058834, uploaded_size: 0, writer: ExampleWeb.S3Writer, writer_closed?: false, writer_state: %ExampleWeb.S3Writer{parts: [], chunk: 1, s3_upload_op: %{}, s3_init_op: %{}, s3_config: %{access_key_id: "34772b6d1", bucket: "sample-app", host: "61bc0a6436a.r2.cloudflarestorage.com", http_client: ExAws.Request.Hackney, json_codec: Jason, normalize_path: true, port: 443, region: "us-east-1", require_imds_v2: false, retries: [max_attempts: 10, base_backoff_in_ms: 10, max_backoff_in_ms: 10000], scheme: "https://", secret_access_key: "e829b47e56fa0a"}, filename: "yoga_for_belly.mp4"}}, channel: Phoenix.LiveView.UploadChannel, channel_pid: #PID<0.435.0>, endpoint: Example.Endpoint, handler: Phoenix.LiveView.Socket, id: nil, joined: true, join_ref: "12", private: %{connect_info: %{}, log_handle_in: false, log_join: :info}, pubsub_server: Example.PubSub, ref: nil, serializer: Phoenix.Socket.V2.JSONSerializer, topic: "lvu:0", transport: :websocket, transport_pid: #PID<0.432.0>}


```

##### Analysis 
1. init/1 -- it was called since we can see        `IO.inspect(label: "init NOW!!")`
2. write_chunk/2 -- this was not called at all. `IO.inspect("INSIDE WRITE_CHUNK NOW!! - chunk: #{inspect state.chunk}, length(data): #{inspect length(data)} ")` is not in logs.
3. close/2 -- this was called with reason `:cancel` Not sure why.
    and then it crashes because `state.s3_upload_op` is still an empty map. When it should have had the upload_operation (See typedstruct)




