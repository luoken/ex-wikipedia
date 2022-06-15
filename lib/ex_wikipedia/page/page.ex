defmodule ExWikipedia.Page do
  @moduledoc """
  `ExWikipedia.page/2` delegates here. This module represents the current
  implementation for requesting and parsing a Wikipedia page.
  """

  @behaviour ExWikipedia

  @allow_redirect true
  @default_body_key :body
  @default_http_client HTTPoison
  @default_lang "en"
  @default_json_parser Jason
  @default_status_key :status_code

  alias ExWikipedia.PageParser

  @typedoc """
  - `:external_links` - List of fully qualified URLs linked from the Wikipedia page.
  - `:categories` - List of categories to which the Wikipedia page belongs
  - `:content` - Main content of the Wikipedia page, as a string
  - `:images` - List of relative URLs pointing to images found on the Wikipedia page
  - `:page_id` - Wikipedia page id represented as an integer
  - `:revision_id` - Wikipedia page revision id represented as an integer
  - `:summary` - Summary of page, as a string
  - `:title` - String title of the Wikipedia page
  - `:url` - Fully qualified URL of the Wikipedia page
  - `:is_redirect?` - Boolean. Indicates whether the content is from a page
    redirected from the one requested.
  """
  @type t :: %__MODULE__{
          external_links: [String.t()],
          categories: [String.t()],
          content: String.t(),
          images: [String.t()],
          page_id: non_neg_integer(),
          revision_id: non_neg_integer(),
          summary: String.t(),
          title: String.t(),
          url: String.t(),
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
  Fetches a Wikipedia page by an identifier (see `:by` option).

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
      See `ExWikipedia.PageParser` for supported options.
    - `:allow_redirect`: indicates whether or not the content from a redirected
       page constitutes a valid response. Default: `#{inspect(@allow_redirect)}`
    - `:language`: Identifies a specific Wikipedia instance to search. You can use the
      `:default_language` config option to set this value. Default: `#{@default_lang}`

  """
  @impl ExWikipedia
  def fetch(id, opts \\ [])

  def fetch(id, opts) do
    http_client = Keyword.get(opts, :http_client, @default_http_client)

    decoder = Keyword.get(opts, :decoder, @default_json_parser)

    http_headers = Keyword.get(opts, :http_headers, [])

    http_opts = Keyword.get(opts, :http_opts, [])

    body_key = Keyword.get(opts, :body_key, @default_body_key)

    status_key = Keyword.get(opts, :status_key, @default_status_key)

    parser = Keyword.get(opts, :parser, PageParser)

    allow_redirect = Keyword.get(opts, :allow_redirect, @allow_redirect)

    language =
      opts
      |> Keyword.get(
        :language,
        Application.get_env(:ex_wikipedia, :default_language, @default_lang)
      )

    parser_opts =
      opts
      |> Keyword.get(:parser_opts, [])
      |> Keyword.put(:allow_redirect, allow_redirect)

    with {:ok, url} <- build_url(id, language),
         {:ok, raw_response} <- http_client.get(url, http_headers, http_opts),
         :ok <- ok_http_status_code(raw_response, status_key),
         {:ok, body} <- get_body(raw_response, body_key),
         {:ok, response} <- decoder.decode(body, keys: :atoms),
         {:ok, parsed_response} <- parser.parse(response, parser_opts) do
      {:ok, struct(__MODULE__, parsed_response)}
    end
  end

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

  defp build_url(id_value, lang) when is_binary(lang) and is_binary(id_value) do
    {:ok,
     "https://#{lang}.wikipedia.org/w/api.php?action=parse&page=#{id_value}&format=json&redirects=true&prop=text|langlinks|categories|links|templates|images|externallinks|sections|revid|displaytitle|iwlinks|properties|parsewarnings|headhtml"
     |> URI.encode()}
  end

  defp build_url(id_value, lang) when is_binary(lang) and is_integer(id_value) do
    {:ok,
     "https://#{lang}.wikipedia.org/w/api.php?action=parse&pageid=#{id_value}&format=json&redirects=true&prop=text|langlinks|categories|links|templates|images|externallinks|sections|revid|displaytitle|iwlinks|properties|parsewarnings|headhtml"
     |> URI.encode()}
  end

  defp build_url(_, lang) do
    {:error, "Unsupported language identifier #{inspect(lang)}; language codes must be a string."}
  end
end
