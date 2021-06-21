defmodule ExWikipedia.Fetcher do
  @moduledoc """
  This module is in charge of fetching the webpage and parsing
  """

  alias ExWikipedia.Parser

  def fetch(id) when is_integer(id) do
    with {:ok, %HTTPoison.Response{body: body}} <- HTTPoison.get(build_url(id)),
    {:ok, %{parse: response}} <- Jason.decode(body, keys: :atoms) do

    Parser.parse(response)
    else 
      _ -> 
        ""
    end
  end

  defp build_url(page_id) do
    "https://en.wikipedia.org/w/api.php?action=parse&pageid=#{page_id}&format=json&redirects=false&prop=text|langlinks|categories|links|templates|images|externallinks|sections|revid|displaytitle|iwlinks|properties|parsewarnings|headhtml"
  end
end
