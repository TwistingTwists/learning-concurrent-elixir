

Application.put_env(:ex_aws, :access_key_id, System.get_env("AWS_ACCESS_KEY_ID"))
Application.put_env(:ex_aws, :secret_access_key, System.get_env("AWS_SECRET_ACCESS_KEY"))

# Application.put_env(:ex_aws, :hackney_opts, recv_timeout: 3000_000)

Application.put_env(:ex_aws, :s3,
  scheme: "https://",
  host: System.get_env("AWS_S3_HOST_URL"),
  bucket: System.get_env("AWS_S3_BUCKET") || "sample-app"
)


Mix.install([
  {:ex_aws, "~> 2.1"},
  {:hackney, "~> 1.9"},
  {:ex_aws_s3, "~> 2.0"},
  {:sweet_xml, "~> 0.6"}
])

s3_config = ExAws.Config.new(:s3)
# filename = "yoga_belly.mp4"
filename = "delits_mathocrat_test1.mp4"


data = Path.expand( "~/Downloads/#{filename}")
        |> ExAws.S3.Upload.stream_file()


s3_upload_op =
    ExAws.S3.upload(data, s3_config.bucket, filename)
    |> IO.inspect(label: "ExAws.S3.Upload - struct")

# Application.get_all_env(:ex_aws) |> IO.inspect(label: "ExAws config")

# intial call to start upload 
    s3_upload_op_with_upload_id = 
      case  ExAws.S3.Upload.initialize(s3_upload_op, s3_config) |> IO.inspect(label: "ExAws.S3.Upload.initialize - upload_id") do 
        {:ok, s3_upload_op_with_upload_id} -> s3_upload_op_with_upload_id
        _ -> raise   "Could not intiate upload to the file"
    end
    |> IO.inspect(label: "s3 upload began?? ")


    op = s3_upload_op_with_upload_id
    
    alias ExAws.S3.Upload 

    # https://github.com/ex-aws/ex_aws_s3/blob/main/lib/ex_aws/s3/upload.ex#L120C9-L126C46
    vals = op.src
    |> IO.inspect(label: "file src?")
        |> Stream.with_index(1)
        |> Enum.map(fn {data, chunk} ->
            byte_size(data)
            |> IO.inspect(label: "data - File.stream")

             Upload.upload_chunk( {data, chunk}, Map.delete(op,:src), s3_config)|> IO.inspect(label: "Upload.upload_chunk - ") 
            end)
        |> IO.inspect(label: "Result of uploads to S3")


Upload.complete(vals, op, s3_config)
    |> IO.inspect(label: "Complete uploads?")

