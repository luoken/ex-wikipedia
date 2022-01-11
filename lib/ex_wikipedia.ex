defmodule ExWikipedia do
  @moduledoc """
  `ExWikipedia` is an Elixir client for the [Wikipedia API](https://en.wikipedia.org/w/api.php).
  """
  alias ExWikipedia.Page

  @callback fetch(input :: integer(), opts :: keyword()) :: {:ok, map()} | {:error, any()}

  @doc """
  Accepts an integer (or a binary representation) and returns a struct with key information extracted.

  ## Examples

      iex> ExWikipedia.page(54173, [])
      {:ok,
        %ExWikipedia.Structs.WikipediaPage{
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

      iex> ExWikipedia.page(1)
      {:error, "There is no page with ID 1."}

      iex> ExWikipedia.page(%{})
      {:error, "The Wikipedia ID supplied is not valid."}
  """
  defdelegate page(wikipedia_id, opts \\ []), to: Page, as: :fetch
end
