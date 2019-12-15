defmodule BibleScraper do


  def get_chapter_url() do
    case HTTPoison.get("http://runeberg.org/bibeln/#1996") do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        urls =
          body
          |> Floki.find("a")
          |> Floki.attribute("href")
          |> Enum.map(fn x -> "http://runeberg.org/bibeln/" <> x end)
          # |> Enum.each(fn x -> IO.puts x end)
          # |> Enum.map(fn(url) -> HTTPoison.get!("http://runeberg.org/bibeln/" <> url) end)
          # |> Enum.map(fn {_, result} -> result.body end)


      {:ok, urls}
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts "Not found"
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end
  end

  def get_chapter_body({_, urls}) do
    urls
    |> Enum.map(fn url -> HTTPoison.get(url) end)
    |> Enum.map(fn {_, result} -> result.body end)
  end

  def get_bible_text(body) do
    body
      |> Floki.find("pre")
      |> Floki.text()
  end


  def get_bible() do
    bible =
      get_chapter_url()
      |> get_chapter_body()
      |> Enum.map(fn body ->
         %{
           text: get_bible_text(body)
         }
         end)

    {:ok, bible}
  end

  def write_bible_to_file({_, bible}) do
    file = File.open!("bible", [:read, :utf8, :write])
    bible
      |> Enum.each(fn b ->
          IO.puts(file, b.text)
        end
        )
  end


end
