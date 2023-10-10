```elixir
❯ elixir only_aws_connectoin.exs
ExAws.S3.Upload - struct: %ExAws.S3.Upload{
  src: %File.Stream{
    path: "/home/abhishek/Downloads/delits_mathocrat_test1.mp4",
    modes: [:raw, :read_ahead, :binary],
    line_or_bytes: 5242880,
    raw: true,
    node: :nonode@nohost
  },
  bucket: "sample-app",
  path: "delits_mathocrat_test1.mp4",
  upload_id: nil,
  opts: [],
  service: :s3
}
ExAws config: [
  access_key_id: "0b8409c7c9964e6ffd1",
  s3: [
    scheme: "https://",
    host: "0b8409c7c9964e6ffd1.r2.cloudflarestorage.com",
    bucket: "sample-app"
  ],
  secret_access_key: "0b8409c7c9964e6ffd1"
]
ExAws.S3.Upload.initialize - upload_id: {:ok,
 %ExAws.S3.Upload{
   src: %File.Stream{
     path: "/home/abhishek/Downloads/delits_mathocrat_test1.mp4",
     modes: [:raw, :read_ahead, :binary],
     line_or_bytes: 5242880,
     raw: true,
     node: :nonode@nohost
   },
   bucket: "sample-app",
   path: "delits_mathocrat_test1.mp4",
   upload_id: "AGEUGFD5INb1DGuVPOYWzthW9wTANxo0AzTO5wtZvCEN42eRlbavcW6Zz2nNmmeCdgq-USI2hTIv83vam16DvjjeR06NUZl1wmk6P3QXc5Dvk9JZKsPhcNEQsPAg7hMyFzTWqmU51gvvqM6Uhz5Su3g1h2jSARyIqLt2zwTNqpvdH_6gH9Dj9mz7wtZc-G_ce7L17b80m41jsUTzuqkXQjUUT4wvbYVK2lDsvDwrGTDNkxzaZyAVyW_W7GA53YoIoo5CqiQWf7xRFzisB4-c7PSlwvk5tujT7ONeNYKlR_GUCaTxTRbMevXgysfMrEOTAI0WPrddJVDmK7ukxKfwT60",
   opts: [],
   service: :s3
 }}
s3 upload began?? : %ExAws.S3.Upload{
  src: %File.Stream{
    path: "/home/abhishek/Downloads/delits_mathocrat_test1.mp4",
    modes: [:raw, :read_ahead, :binary],
    line_or_bytes: 5242880,
    raw: true,
    node: :nonode@nohost
  },
  bucket: "sample-app",
  path: "delits_mathocrat_test1.mp4",
  upload_id: "AGEUGFD5INb1DGuVPOYWzthW9wTANxo0AzTO5wtZvCEN42eRlbavcW6Zz2nNmmeCdgq-USI2hTIv83vam16DvjjeR06NUZl1wmk6P3QXc5Dvk9JZKsPhcNEQsPAg7hMyFzTWqmU51gvvqM6Uhz5Su3g1h2jSARyIqLt2zwTNqpvdH_6gH9Dj9mz7wtZc-G_ce7L17b80m41jsUTzuqkXQjUUT4wvbYVK2lDsvDwrGTDNkxzaZyAVyW_W7GA53YoIoo5CqiQWf7xRFzisB4-c7PSlwvk5tujT7ONeNYKlR_GUCaTxTRbMevXgysfMrEOTAI0WPrddJVDmK7ukxKfwT60",
  opts: [],
  service: :s3
}
file src?: %File.Stream{
  path: "/home/abhishek/Downloads/delits_mathocrat_test1.mp4",
  modes: [:raw, :read_ahead, :binary],
  line_or_bytes: 5242880,
  raw: true,
  node: :nonode@nohost
}
data - File.stream: 5242880
Upload.upload_chunk - : {1, "\"efd43665297312fd3125619b7cdb2198\""}
data - File.stream: 5242880
Upload.upload_chunk - : {2, "\"31dfcd53a6426255e8866678d0795035\""}
data - File.stream: 5242880
Upload.upload_chunk - : {3, "\"1c0ba371ae23fdaba45dfb1d54f4b364\""}
data - File.stream: 5242880
Upload.upload_chunk - : {4, "\"1ff5488d8b17fca1e3922674c5b18843\""}
data - File.stream: 5242880
Upload.upload_chunk - : {5, "\"647bd7d423e78c6915394ab30b002c56\""}
data - File.stream: 5242880
Upload.upload_chunk - : {6, "\"53921c6802f01a0c6b04c1e0030edf79\""}
data - File.stream: 5242880
Upload.upload_chunk - : {7, "\"41bd689eddec819b556fabb87b27bf5a\""}
data - File.stream: 5242880
Upload.upload_chunk - : {8, "\"d89c926f405605beb70bccc11d1f44ea\""}
data - File.stream: 5242880
Upload.upload_chunk - : {9, "\"1eda5e41bb978e1819e5fe545131e507\""}
data - File.stream: 5242880
Upload.upload_chunk - : {10, "\"6a3ac98f1487002aa824e18f82b31213\""}
data - File.stream: 5242880
Upload.upload_chunk - : {11, "\"22d54a209903e41bb589a78a4501f74d\""}
data - File.stream: 5242880
Upload.upload_chunk - : {12, "\"81136d1eb24110188a48ea749f575c6e\""}
data - File.stream: 5242880
Upload.upload_chunk - : {13, "\"5d03cd23d1564540c8ce9f70d9bd26a6\""}
data - File.stream: 5242880
Upload.upload_chunk - : {14, "\"bbe8111aeb88b83e7e3edbd024606593\""}
data - File.stream: 5242880
Upload.upload_chunk - : {15, "\"2616b1f1d15d6bcdfacd7a963ffa1bfa\""}
data - File.stream: 5242880
Upload.upload_chunk - : {16, "\"a3a08d3cfb03a208d07fc8cb9b4b336c\""}
data - File.stream: 5242880
Upload.upload_chunk - : {17, "\"3e4eaa5132d78b86032afa147e987560\""}
data - File.stream: 5242880
Upload.upload_chunk - : {18, "\"85f47fdc7717599e731b4b58864dc02e\""}
data - File.stream: 5242880
Upload.upload_chunk - : {19, "\"bf7f3b7d7a527a9e4378059d45b56131\""}
data - File.stream: 5242880
Upload.upload_chunk - : {20, "\"08250ec3b004433a1dcc4273a845c385\""}
data - File.stream: 5242880
Upload.upload_chunk - : {21, "\"9b115bd225d5fb879cb6e5ce044e8cdc\""}
data - File.stream: 5242880
Upload.upload_chunk - : {22, "\"be35ab68b7d11f79b9f1f0105cbf3d6e\""}
data - File.stream: 5242880
Upload.upload_chunk - : {23, "\"71f3d7f26c85d1f25911e0c3b8f21056\""}
data - File.stream: 5242880
Upload.upload_chunk - : {24, "\"5f1330437cd61ead945c03f626862459\""}
data - File.stream: 5242880
Upload.upload_chunk - : {25, "\"21c65ebc05b0b8ccb64b822d8b685756\""}
data - File.stream: 5242880
Upload.upload_chunk - : {26, "\"096f166af889a52adda39848c7b2b295\""}
data - File.stream: 5242880
Upload.upload_chunk - : {27, "\"1b70473c7be7ac074257a87b6652e422\""}
data - File.stream: 5242880
Upload.upload_chunk - : {28, "\"c7f005afe963dd711e7ef9aa2999ac3e\""}
data - File.stream: 5242880
Upload.upload_chunk - : {29, "\"c0633cdc0c453f717252b5f3ed137494\""}
data - File.stream: 5242880
Upload.upload_chunk - : {30, "\"1bac37e092abe809e758f145508488bd\""}
data - File.stream: 5242880
Upload.upload_chunk - : {31, "\"45313a70dc5bc7fc1bb39d4fbd432909\""}
data - File.stream: 5242880
Upload.upload_chunk - : {32, "\"ca13ee0ad53a2870c9609d9cbebb5c94\""}
data - File.stream: 5242880
Upload.upload_chunk - : {33, "\"a71869236b61def492f8e0a39cc8ca76\""}
data - File.stream: 5242880
Upload.upload_chunk - : {34, "\"237f67150ad998e31006db16439bb18b\""}
data - File.stream: 5242880
Upload.upload_chunk - : {35, "\"6ab0c887aae6f4d20a4f601cc9e973ac\""}
data - File.stream: 5242880
Upload.upload_chunk - : {36, "\"c0f9ab48801a79db3bdca8930e37369e\""}
data - File.stream: 5242880
Upload.upload_chunk - : {37, "\"4e266a2c0868c6a19fd59ba8f709fe0e\""}
data - File.stream: 5242880
Upload.upload_chunk - : {38, "\"3281af088f54c240484eb19d69ea6329\""}
data - File.stream: 5242880
Upload.upload_chunk - : {39, "\"523b9753712093d4dbfc17d7bcd6f351\""}
data - File.stream: 3087694
Upload.upload_chunk - : {40, "\"396d1d8814e8a201667ff3f56757a185\""}
Result of uploads to S3: [
  {1, "\"efd43665297312fd3125619b7cdb2198\""},
  {2, "\"31dfcd53a6426255e8866678d0795035\""},
  {3, "\"1c0ba371ae23fdaba45dfb1d54f4b364\""},
  {4, "\"1ff5488d8b17fca1e3922674c5b18843\""},
  {5, "\"647bd7d423e78c6915394ab30b002c56\""},
  {6, "\"53921c6802f01a0c6b04c1e0030edf79\""},
  {7, "\"41bd689eddec819b556fabb87b27bf5a\""},
  {8, "\"d89c926f405605beb70bccc11d1f44ea\""},
  {9, "\"1eda5e41bb978e1819e5fe545131e507\""},
  {10, "\"6a3ac98f1487002aa824e18f82b31213\""},
  {11, "\"22d54a209903e41bb589a78a4501f74d\""},
  {12, "\"81136d1eb24110188a48ea749f575c6e\""},
  {13, "\"5d03cd23d1564540c8ce9f70d9bd26a6\""},
  {14, "\"bbe8111aeb88b83e7e3edbd024606593\""},
  {15, "\"2616b1f1d15d6bcdfacd7a963ffa1bfa\""},
  {16, "\"a3a08d3cfb03a208d07fc8cb9b4b336c\""},
  {17, "\"3e4eaa5132d78b86032afa147e987560\""},
  {18, "\"85f47fdc7717599e731b4b58864dc02e\""},
  {19, "\"bf7f3b7d7a527a9e4378059d45b56131\""},
  {20, "\"08250ec3b004433a1dcc4273a845c385\""},
  {21, "\"9b115bd225d5fb879cb6e5ce044e8cdc\""},
  {22, "\"be35ab68b7d11f79b9f1f0105cbf3d6e\""},
  {23, "\"71f3d7f26c85d1f25911e0c3b8f21056\""},
  {24, "\"5f1330437cd61ead945c03f626862459\""},
  {25, "\"21c65ebc05b0b8ccb64b822d8b685756\""},
  {26, "\"096f166af889a52adda39848c7b2b295\""},
  {27, "\"1b70473c7be7ac074257a87b6652e422\""},
  {28, "\"c7f005afe963dd711e7ef9aa2999ac3e\""},
  {29, "\"c0633cdc0c453f717252b5f3ed137494\""},
  {30, "\"1bac37e092abe809e758f145508488bd\""},
  {31, "\"45313a70dc5bc7fc1bb39d4fbd432909\""},
  {32, "\"ca13ee0ad53a2870c9609d9cbebb5c94\""},
  {33, "\"a71869236b61def492f8e0a39cc8ca76\""},
  {34, "\"237f67150ad998e31006db16439bb18b\""},
  {35, "\"6ab0c887aae6f4d20a4f601cc9e973ac\""},
  {36, "\"c0f9ab48801a79db3bdca8930e37369e\""},
  {37, "\"4e266a2c0868c6a19fd59ba8f709fe0e\""},
  {38, "\"3281af088f54c240484eb19d69ea6329\""},
  {39, "\"523b9753712093d4dbfc17d7bcd6f351\""},
  {40, "\"396d1d8814e8a201667ff3f56757a185\""}
]
Complete uploads?: {:ok,
 %{
   body: %{
     bucket: "sample-app",
     etag: "\"6e22c155b4ce077d35f8055205d9e0fe-40\"",
     key: "delits_mathocrat_test1.mp4",
     location: "https://0b8409c7c9964e6ffd1.r2.cloudflarestorage.com/sample-app/delits_mathocrat_test1.mp4"
   },
   headers: [
     {"Date", "Tue, 10 Oct 2023 04:50:35 GMT"},
     {"Content-Type", "application/xml"},
     {"Content-Length", "397"},
     {"Connection", "keep-alive"},
     {"x-amz-version-id", "7e74e81538483c4dd7a94756c675ea86"},
     {"Server", "cloudflare"},
     {"CF-RAY", "813c3e4b1c6d31f3-BOM"}
   ],
   status_code: 200
 }}
 ```