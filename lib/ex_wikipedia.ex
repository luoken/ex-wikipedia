defmodule ExWikipedia do
  @moduledoc """
  `ExWikipedia` is an Elixir wrapper for the Wikipedia [API](https://en.wikipedia.org/w/api.php).
  """
  alias ExWikipedia.FetchWikipediaId



  @callback fetch(input :: integer(), opts :: keyword()) :: {:ok, map()} | {:error, any()}


  @typedoc """
  - `:external_links` - External links associated with the Wikipedia page.
  - `:categories` - Categories the Wikipedia page belongs to
  - `:content` - Contents found on page
  - `:images` - Images found on the Wikipedia page
  - `:page_id` - Wikipedia page id represented as an integer
  - `:revision_id` - Wikipedia page revision id
  - `:summary` - Wikipedia page's summary
  - `:title` - title of Wikipedia page
  - `:url` - url belonging to Wikipedia page
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
  Takes in a Wikipedia ID as an integer or a binary integer and returns a map with key information extracted.

  ## Examples

      iex> ExWikipedia.id(54173, [])
      {:ok,
        %ExWikipedia{
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

  @spec id(wikipedia_id :: integer() | binary(), opts :: list()) :: {:ok, map()} | {:error, binary()}
  def id(wikipedia_id, opts) do
    FetchWikipediaId.fetch(wikipedia_id, opts)
  end
end
