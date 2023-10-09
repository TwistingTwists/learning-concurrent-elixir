# Based on https://hexdocs.pm/phoenix_live_view/

Application.put_env(:sample, Example.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 5001],
  server: true,
  live_view: [signing_salt: "aaaaaaaa"],
  secret_key_base: String.duplicate("a", 64),
  pubsub_server: Example.PubSub
)

Application.put_env(:ex_aws, :access_key_id, System.get_env("AWS_ACCESS_KEY_ID"))
Application.put_env(:ex_aws, :secret_access_key, System.get_env("AWS_SECRET_ACCESS_KEY"))

# Application.put_env(:ex_aws, :hackney_opts, recv_timeout: 3000_000)

Application.put_env(:ex_aws, :s3,
  scheme: "https://",
  host: System.get_env("AWS_S3_HOST_URL"),
  bucket: System.get_env("AWS_S3_BUCKET") || "sample-app"
)

Mix.install([
  {:plug_cowboy, "~> 2.5"},
  {:jason, "~> 1.0"},
  {:phoenix, "~> 1.7.7"},
  {:phoenix_live_view, "~> 0.20.0"},
  {:typed_struct, "~> 0.1.4"},
  # s3 dependencies
  {:ex_aws, "~> 2.1"},
  {:hackney, "~> 1.9"},
  {:ex_aws_s3, "~> 2.0"},
  {:sweet_xml, "~> 0.6"}
])

defmodule Example.ErrorView do
  def render(template, _), do: Phoenix.Controller.status_message_from_template(template)
end

defmodule ExampleWeb.S3Writer do
  @moduledoc """
  Module to stream video directly to S3 bucket.
  But not via presigned url.
  """

  use TypedStruct

  @typedoc "S3Writer struct"
  typedstruct do
    field(:filename, String.t(), enforce: true)
    field(:s3_config, ExAws.Config.t(), enforce: true)
    field(:s3_init_op, ExAws.Operation.S3.t(), default: %{})
    field(:s3_upload_op, ExAwsExAws.S3.Upload.t(), default: %{})
    field(:chunk, non_neg_integer(), default: 1)
    field(:parts, List.t(), default: [])
  end

  @behaviour Phoenix.LiveView.UploadWriter

  require Logger

  @impl Phoenix.LiveView.UploadWriter
  def init(opts) do
    {s3_config, rest} = Keyword.pop(opts, :s3_config, ExAws.Config.new(:s3))
    file_name = Keyword.fetch!(rest, :filename)

    {:ok,
     %__MODULE__{
       filename: file_name,
       s3_config: s3_config
     }}
    |> IO.inspect(label: "init NOW!!")
  end

  @impl Phoenix.LiveView.UploadWriter
  def meta(state) do
    IO.inspect("INSIDE META NOW!!")

    Map.take(state, [:filename, :s3_config, :chunk])
  end

  @impl Phoenix.LiveView.UploadWriter
  def write_chunk(data, %{chunk: 1} = state) do
    IO.inspect("INSIDE WRITE_CHUNK NOW!! - chunk: #{inspect state.chunk}, length(data): #{inspect length(data)} ")

    s3_upload_op =
      ExAws.S3.upload(data, state.s3_config.bucket, state.filename)
      |> IO.inspect(label: "ExAws.S3.Upload - struct")

      s3_upload_op_with_upload_id = 
        case  ExAws.S3.Upload.initialize(s3_upload_op, state.s3_config) |> IO.inspect(label: "ExAws.S3.Upload.initialize - upload_id") do 
          {:ok, s3_upload_op_with_upload_id} -> s3_upload_op_with_upload_id
          _ -> raise   "Could not intiate upload to the file"
      end

    next = %{
      state
      | chunk: state.chunk + 1,
        s3_upload_op: s3_upload_op_with_upload_id
    }

  end

  def write_chunk(data, state) do
    IO.inspect(" WRITE_CHUNK - upload_chunk! NOW!!")

    part =
      ExAws.S3.Upload.upload_chunk!(
        {data, state.chunk},
        #   Map.delete(state.s3_upload_op, :src),
        state.s3_upload_op,
        state.s3_config
      )

    IO.inspect(" Finished writing chunk (s3) : #{state.chunk + 1}  ")

    {:ok, %{state | chunk: state.chunk + 1, parts: [part | state.parts]}}
  end

  @impl Phoenix.LiveView.UploadWriter
  def close(state, reason_input) do
    reason_input |> IO.inspect(label: "Why is reason = ")

    case ExAws.S3.Upload.complete(state.parts, state.s3_upload_op, state.s3_config) do
      {:ok, _} ->
        {:ok, state}

      {:error, reason} ->
        {:error, reason, state}
    end
  end
end

defmodule Example.HomeLive do
  use Phoenix.LiveView, layout: {__MODULE__, :live}

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:uploaded_urls, [])
     |> allow_upload(
        #  the upload name is :image, but please try to upload video of more than 10-15 Mb
       :image,
       auto_upload: true,
       progress: &handle_progress/3,
       accept: ~w(.mp4),
       max_entries: 1,
       max_file_size: 400 * 1000 * 1000,
       # 6 MB
       chunk_size: 6 * 1000 * 1000,
       writer: &s3_writer/3
     )}
  end

  def s3_writer(name, entry, socket) do
    {ExampleWeb.S3Writer, [s3_config: ExAws.Config.new(:s3), filename: entry.client_name]}
  end



  def handle_progress(:image, entry, socket) do
  
    {:noreply, socket}
  end

  @impl true
  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  #   @impl true
  #   def handle_event("save", _params, socket) do
  #     tmp_dir = Path.join(System.tmp_dir!(), "phoenix_live_view_upload_example")
  #     File.mkdir_p!(tmp_dir)

  #     uploaded_urls =
  #       consume_uploaded_entries(socket, :image, fn %{path: path}, entry ->
  #         dest = Path.join(tmp_dir, entry.client_name)
  #         File.cp!(path, dest)
  #         {:ok, "/uploads/#{entry.client_name}"}
  #       end)

  #     {:noreply, update(socket, :uploaded_urls, &(&1 ++ uploaded_urls))}
  #   end

  @impl true
  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :image, ref)}
  end

  @impl true
  def render("live.html", assigns) do
    ~H"""
    <script src="https://cdn.jsdelivr.net/npm/phoenix@1.7.7/priv/static/phoenix.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/phoenix_live_view@0.19.5/priv/static/phoenix_live_view.min.js"></script>
    <script>
      let liveSocket = new window.LiveView.LiveSocket("/live", window.Phoenix.Socket)
      liveSocket.connect()
    </script>
    <%= @inner_content %>
    """
  end

  @impl true
  def render(assigns) do
    ~H"""
    <h1>Phoenix LiveView Upload Image Example</h1>
    <div phx-drop-target={@uploads.image.ref}>
      <form id="upload-form" phx-submit="save" phx-change="validate">
        <.live_file_input upload={@uploads.image} />
        <button type="submit">Upload</button>
      </form>

      <%= for entry <- @uploads.image.entries do %>
        <article class="upload-entry">
          <h2>Preview</h2>

          <figure>
            <.live_img_preview entry={entry} width="400" />
            <figcaption><%= entry.client_name %></figcaption>
          </figure>

          <progress value={entry.progress} max="100"><%= entry.progress %>%</progress>

          <button type="button" phx-click="cancel-upload" phx-value-ref={entry.ref} aria-label="cancel">&times;</button>

          <%= for err <- upload_errors(@uploads.image, entry) do %>
            <p class="alert alert-danger">1: <%= err %></p>
          <% end %>

        </article>
      <% end %>

      <%= for err <- upload_errors(@uploads.image) do %>
        <p class="alert alert-danger">2: <%= err %></p>
      <% end %>
    </div>

    <h2>Uploaded Files</h2>

    <p :if={@uploaded_urls == []}>No files yet.</p>
    <div :for={url <- @uploaded_urls}>
      <img src={url} style="max-width: 400px">
    </div>
    """
  end
end

defmodule Example.Router do
  use Phoenix.Router
  import Phoenix.LiveView.Router

  pipeline :browser do
    plug(:accepts, ["html"])
  end

  scope "/", Example do
    pipe_through(:browser)

    live("/", HomeLive, :index)
  end
end

defmodule Example.Endpoint do
  use Phoenix.Endpoint, otp_app: :sample
  socket("/live", Phoenix.LiveView.Socket)

  plug(Plug.Static,
    at: "/uploads",
    from: Path.join(System.tmp_dir!(), "phoenix_live_view_upload_example")
  )

  plug(Example.Router)
end

children = [
  {Phoenix.PubSub, name: Example.PubSub},
  Example.Endpoint
]

{:ok, _} = Supervisor.start_link(children, strategy: :one_for_one)

# unless running from IEx, sleep idenfinitely so we can serve requests
unless IEx.started?() do
  Process.sleep(:infinity)
end
