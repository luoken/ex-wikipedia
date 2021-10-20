defmodule ExWikipedia.FetchWikipediaId do
  @moduledoc """
  This module takes in a Wikipedia Id as an interger and returns its contents parsed.
  """
  @behaviour ExWikipedia

  import ExWikipedia

  alias ExWikipedia.Parser

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

  def default_opts do
    [client: client(), parser: Parser, decoder: Jason]
  end

  @doc """
  Takes in a Wikipedia ID as an integer and returns a map with key information extracted.

  ## Examples

      iex> ExWikipedia.FetchWikipediaId.fetch(54173, [])
      {:ok,
        %ExWikipedia.FetchWikipediaId{
          categories: ["Webarchive template wayback links",
          "All articles with dead external links",
          "Articles with dead external links from June 2016" | _],
          content: "1994 film directed by Quentin Tarantino This article is about the film. For other uses, see" <> _,
          external_links: ["https://www.bbfc.co.uk/releases/pulp-fiction-film-0", | _],
          images: ["https://upload.wikimedia.org/wikipedia/en/3/3b/Pulp_Fiction_%281994%29_poster.jpg", | _ ],
          page_id: 54173,
          revision_id: 1043869264,
          summary: "1994 film directed by Quentin Tarantino.mw-parser-output .hatnote{font-style:italic}.mw-parser-output" <> _,
          title: "Pulp Fiction",
          url: "https://en.wikipedia.org/wiki/Pulp_Fiction"
      }}
  """
  @impl true
  def fetch(id, opts \\ [])

  def fetch(id, opts) when is_integer(id) do
    opts = Keyword.merge(default_opts(), opts)
    client = Keyword.get(opts, :client)
    decoder = Keyword.get(opts, :decoder)

    with {:ok, %HTTPoison.Response{body: body}} <- client.get(build_url(id), opts),
         {:ok, %{parse: response}} <- decoder.decode(body, keys: :atoms) do
      {:ok, struct(__MODULE__, Parser.parse(response, opts))}
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
