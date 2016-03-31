defmodule HexApi do
  use HTTPotion.Base
  def process_url(url) do
    "https://hex.pm/api/packages/" <> url
  end

  def process_request_headers(headers) do
    Dict.put headers, :"User-Agent", "mixgraph-agent"
  end

  def process_response_body(body) do
    {:ok, json} = body
    |> IO.iodata_to_binary 
    |> JSON.decode
    json
    |> Enum.map(fn ({k, v}) -> { String.to_atom(k), v } end)
    |> :orddict.from_list
  end
end