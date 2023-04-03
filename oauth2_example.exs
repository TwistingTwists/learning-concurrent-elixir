Mix.install([

  {:oauth2, "~> 2.0"},
  {:hackney, "~> 1.18"},
  {:tesla, "~> 1.4"},
  {:jason, ">= 1.0.0"},
  {:fuse, "~> 2.4"}

],
config: [oauth2: [middleware: [
  Tesla.Middleware.Retry,
  {Tesla.Middleware.Fuse, name: :example}
]]]
)

client = OAuth2.Client.new([
  strategy: OAuth2.Strategy.AuthCode,
  client_id: "MhzdvKFJT_qJJqa7zXqa3A",
  client_secret: "rWdkTZRPJwjIzxfOyHER5VLlyXEdgbFe",
  site: "https://zoom.us",
  redirect_uri: "https://localhost:4001/api/zoom/oauth"
])

OAuth2.Client.authorize_url!(client)
|> IO.inspect(label: "authorize url")

# https://zoom.us/oauth/authorize?response_type=code&client_id=MhzdvKFJT_qJJqa7zXqa3A&redirect_uri=http%3A%2F%2Flocalhost%3A4001%2Fapi%2Fzoom%2Fauth



client = OAuth2.Client.new([
  strategy: OAuth2.Strategy.ClientCredentials,
  client_id: "MhzdvKFJT_qJJqa7zXqa3A",
  client_secret: "rWdkTZRPJwjIzxfOyHER5VLlyXEdgbFe",
  site: "https://zoom.us",
  redirect_uri: "https://localhost:4001/api/zoom/oauth"
])

client = OAuth2.Client.get_token!(client)

# raw access token
access_token = client.token.access_token |> Jason.decode!() |> IO.inspect(label: "Access Token")

