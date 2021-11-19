defmodule ExWikipedia.FetchWikipediaId do
  @moduledoc false

  @behaviour ExWikipedia

  alias ExWikipedia
  alias ExWikipedia.Parser

  @impl true
  def fetch(id, opts \\ [])


  def fetch(id, opts) when is_integer(id) do
    client = Keyword.get(opts, :client, Application.get_env(:ex_wikipedia, :http_client, HTTPoison))
    decoder = Keyword.get(opts, :decoder, Jason)

    with {:ok, %HTTPoison.Response{body: body}} <- client.get(build_url(id), opts),
         {:ok, %{parse: response}} <- decoder.decode(body, keys: :atoms) do
      {:ok, struct(ExWikipedia, Parser.parse(response, opts))}
    end
  end

  def fetch(id, opts) do
    Integer.parse(id)
    |> case do
      :error ->
        {:error, "The Wikipedia ID supplied is not valid."}

      {num, _} ->
        fetch(num, opts)
    end
  end

  defp build_url(page_id) do
    "https://en.wikipedia.org/w/api.php?action=parse&pageid=#{page_id}&format=json&redirects=false&prop=text|langlinks|categories|links|templates|images|externallinks|sections|revid|displaytitle|iwlinks|properties|parsewarnings|headhtml"
  end
end
