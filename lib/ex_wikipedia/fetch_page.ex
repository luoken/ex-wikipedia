defmodule ExWikipedia.FetchPage do
  @moduledoc false

  @behaviour ExWikipedia

  alias ExWikipedia.PageParser
  alias ExWikipedia.Structs.WikipediaPage

  @doc """
  Takes in a Wikipedia integer ID and search for Wikipedia page.

  options:

  -- `decoder`: Decoder used to decode JSON returned from Wikipedia API. Default: Jason
  -- `client`: Client used to fetch Wikipedia page via Wikipedia's integer ID. Default: HTTPoison
  """
  @impl ExWikipedia
  def fetch(id, opts \\ [])

  def fetch(id, opts) when is_integer(id) do
    client =
      Keyword.get(opts, :client, Application.get_env(:ex_wikipedia, :http_client, HTTPoison))

    decoder = Keyword.get(opts, :decoder, Jason)

    with {:ok, %{body: body, status_code: 200}} <-
           client.get(build_url(id), opts),
         {:ok, response} <- decoder.decode(body, keys: :atoms),
         {:ok, parsed_response} <- PageParser.parse(response, opts) do
      {:ok, struct(WikipediaPage, parsed_response)}
    end
  end

  def fetch(id, opts) when is_binary(id) do
    Integer.parse(id)
    |> case do
      :error ->
        {:error, "The Wikipedia ID supplied is not valid."}

      {num, _} ->
        fetch(num, opts)
    end
  end

  def fetch(_id, _opts), do: {:error, "The Wikipedia ID supplied is not valid."}

  defp build_url(page_id) do
    "https://en.wikipedia.org/w/api.php?action=parse&pageid=#{page_id}&format=json&redirects=false&prop=text|langlinks|categories|links|templates|images|externallinks|sections|revid|displaytitle|iwlinks|properties|parsewarnings|headhtml"
  end
end
