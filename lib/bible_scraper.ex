defmodule BibleScraper do


  def get_chapter_url() do
    case HTTPoison.get("http://runeberg.org/bibeln/#1996") do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        urls =
          body
          |> Floki.find("a")
          |> Floki.attribute("href")
          # |> Enum.each(fn x -> "http://runeberg.org/bibeln/" <> x end)
          # |> Enum.each(fn x -> IO.puts x end)
          |> Enum.map(fn(url) -> HTTPoison.get!("http://runeberg.org/bibeln/" <> url) end)
          


      {:ok, urls}
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts "Not found"
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end
  end

end
