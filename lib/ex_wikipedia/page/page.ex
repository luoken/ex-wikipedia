defmodule ExWikipedia.Page.Page do
  @moduledoc false

  @behaviour ExWikipedia

  alias ExWikipedia.PageParser

  @typedoc """
  - `:external_links` - List of fully qualified URLs to associate with the Wikipedia page.
  - `:categories` - List of categories the Wikipedia page belongs to
  - `:content` - String text found on Wikipedia page
  - `:images` - List of relative URLs pointing to images found on the Wikipedia page
  - `:page_id` - Wikipedia page id represented as an integer
  - `:revision_id` - Wikipedia page revision id represented as an integer
  - `:summary` - String text representing Wikipedia page's summary
  - `:title` - String title of the Wikipedia page
  - `:url` - Fully qualified URL belonging to Wikipedia page
  """

  @type t :: %__MODULE__{
          external_links: [String.t()],
          categories: [String.t()],
          content: binary(),
          images: [String.t()],
          page_id: integer(),
          revision_id: integer(),
          summary: binary(),
          title: binary(),
          url: binary()
        }

  @enforce_keys [:content, :page_id, :summary, :title, :url]

  defstruct external_links: [],
            categories: [],
            content: "",
            images: [],
            page_id: nil,
            revision_id: nil,
            summary: "",
            title: "",
            url: ""

  @doc """
  Takes in a Wikipedia integer ID and search for Wikipedia page.

  ## Options

    - `:client`: Client used to fetch Wikipedia page via Wikipedia's integer ID. Default: HTTPoison
    - `:decoder`: Decoder used to decode JSON returned from Wikipedia API. Default: Jason
    - `:http_headers`: HTTP headers that are passed into the client. Default: []
    - `:http_opts`: HTTP options passed to the client. Default: []
    - `:parser`: Parser used to parse response returned from client. Default: ExWikipedia.PageParser
    - `:parser_opts`: Parser options passed the the parser. Default: []

  """
  @impl ExWikipedia
  def fetch(id, opts \\ [])

  def fetch(id, opts) when is_integer(id) do
    client =
      Keyword.get(opts, :client, Application.get_env(:ex_wikipedia, :http_client, HTTPoison))

    decoder =
      Keyword.get(opts, :decoder, Application.get_env(:ex_wikipedia, :json_decoder, Jason))

    http_headers = Keyword.get(opts, :http_headers, [])

    http_opts = Keyword.get(opts, :http_opts, [])

    parser = Keyword.get(opts, :parser, PageParser)

    parser_opts = Keyword.get(opts, :parser_opts, [])

    with {:ok, %{body: body, status_code: 200}} <-
           client.get(build_url(id), http_headers, http_opts),
         {:ok, response} <- decoder.decode(body, keys: :atoms),
         {:ok, parsed_response} <- parser.parse(response, parser_opts) do
      {:ok, struct(__MODULE__, parsed_response)}
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
    "https://en.wikipedia.org/w/api.php?action=parse&pageid=#{page_id}&format=json&redirects=true&prop=text|langlinks|categories|links|templates|images|externallinks|sections|revid|displaytitle|iwlinks|properties|parsewarnings|headhtml"
  end
end
