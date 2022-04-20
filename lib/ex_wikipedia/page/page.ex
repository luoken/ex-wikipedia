defmodule ExWikipedia.Page do
  @moduledoc """
  `ExWikipedia.page/2` delegates here. This module represents the current
  implementation.
  """

  @behaviour ExWikipedia

  @follow_redirect true
  @default_http_client HTTPoison
  @default_json_parser Jason
  @default_status_key :status_code
  @default_body_key :body

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
  - `:url` - Fully qualified URL of Wikipedia page
  - `:is_redirect?` - Boolean. Indicates whether the content is from a page
    redirected from the one requested.
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
          url: binary(),
          is_redirect?: boolean(),
          links: [String.t()]
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
            url: "",
            is_redirect?: false,
            links: []

  @doc """
  Fetches a Wikipedia page by its ID.

  ## Options

    - `:http_client`: HTTP Client used to fetch Wikipedia page via Wikipedia's integer ID. Default: `#{@default_http_client}`
    - `:decoder`: Decoder used to decode JSON returned from Wikipedia API. Default: `#{@default_json_parser}`
    - `:http_headers`: HTTP headers that are passed into the client. Default: []
    - `:http_opts`: HTTP options passed to the client. Default: []
    - `:body_key`: key inside the HTTP client's response which contains the response body.
      This may change depending on the client used. Default: `#{@default_body_key}`
    - `:status_key`: key inside the HTTP client's response which returns the HTTP status code.
      This may change depending on the client used. Default: `#{@default_status_key}`
    - `:parser`: Parser used to parse response returned from client. Default: `ExWikipedia.PageParser`
    - `:parser_opts`: Parser options passed the the parser. Default: `[]`.
      See `ExWikipedia.PageParser` for supported option.
    - `:follow_redirect`: indicates whether or not the content from a redirected
       page constitutes a valid response. Default: `#{inspect(@follow_redirect)}`

  """
  @impl ExWikipedia
  def fetch(id, opts \\ [])

  def fetch(id, opts) when is_integer(id) do
    http_client = Keyword.get(opts, :http_client, @default_http_client)

    decoder = Keyword.get(opts, :decoder, @default_json_parser)

    http_headers = Keyword.get(opts, :http_headers, [])

    http_opts = Keyword.get(opts, :http_opts, [])

    body_key = Keyword.get(opts, :body_key, @default_body_key)

    status_key = Keyword.get(opts, :status_key, @default_status_key)

    parser = Keyword.get(opts, :parser, PageParser)

    follow_redirect = Keyword.get(opts, :follow_redirect, @follow_redirect)

    parser_opts =
      opts
      |> Keyword.get(:parser_opts, [])
      |> Keyword.put(:follow_redirect, follow_redirect)

    with {:ok, raw_response} <-
           http_client.get(build_url(id), http_headers, http_opts),
         :ok <- ok_http_status_code(raw_response, status_key),
         {:ok, body} <- get_body(raw_response, body_key),
         {:ok, response} <- decoder.decode(body, keys: :atoms),
         {:ok, parsed_response} <- parser.parse(response, parser_opts) do
      {:ok, struct(__MODULE__, parsed_response)}
    end
  end

  def fetch(id, opts) when is_binary(id) do
    Integer.parse(id)
    |> case do
      {num, _} ->
        fetch(num, opts)

      :error ->
        {:error, "The Wikipedia ID supplied is not valid."}
    end
  end

  def fetch(_id, _opts), do: {:error, "The Wikipedia ID supplied is not valid."}

  defp get_body(raw_response, body_key) do
    case Map.fetch(raw_response, body_key) do
      {:ok, body} ->
        {:ok, body}

      :error ->
        {:error, "#{inspect(body_key)} not found as key in response: #{inspect(raw_response)}"}
    end
  end

  defp ok_http_status_code(raw_response, status_key) do
    case Map.fetch(raw_response, status_key) do
      {:ok, 200} -> :ok
      _ -> {:error, "#{inspect(status_key)} not 200 in response: #{inspect(raw_response)}"}
    end
  end

  defp build_url(page_id) do
    "https://en.wikipedia.org/w/api.php?action=parse&pageid=#{page_id}&format=json&redirects=true&prop=text|langlinks|categories|links|templates|images|externallinks|sections|revid|displaytitle|iwlinks|properties|parsewarnings|headhtml"
  end
end
