defmodule ExWikipedia do
  @moduledoc """
  `ExWikipedia` is an Elixir client for the [Wikipedia API](https://en.wikipedia.org/w/api.php).
  """
  alias ExWikipedia.Page

  @callback fetch(input :: integer(), opts :: keyword()) :: {:ok, map()} | {:error, any()}

  @doc since: "0.4.0"
  @callback url(key :: atom(), value :: String.t(), lang :: String.t() | atom()) ::
              {:ok, String.t()} | {:error, String.t()}

  @doc """
  Accepts an integer (or a binary representation) and returns a struct with key information extracted.

  ## Examples

      iex> ExWikipedia.page(54173, [])
      {:ok,
        %ExWikipedia.Page{
          categories: ["Webarchive template wayback links",
            "All articles with dead external links",
            "Films whose writer won the Best Original Screenplay BAFTA Award",
            "Independent Spirit Award for Best Film winners", ...],
          content: "Pulp Fiction is a 1994 American black comedy crime film" <> ...,
          external_links: ["https://www.bbfc.co.uk/releases/pulp-fiction-film-0",
            "https://boxofficemojo.com/movies/?id=pulpfiction.htm",
            ...],
          images: ["https://upload.wikimedia.org/wikipedia/en/3/3b/Pulp_Fiction_%281994%29_poster.jpg",
            "https://upload.wikimedia.org/wikipedia/en/thumb/2/2e/Willis_in_Pulp_Fiction.jpg/220px-Willis_in_Pulp_Fiction.jpg",
            ...],
          is_redirect?: false,
          page_id: 54173,
          revision_id: 1069204423,
          summary: "Pulp Fiction is a 1994 American black comedy crime film written" <> ...,
          title: "Pulp Fiction",
          url: "https://en.wikipedia.org/wiki/Pulp_Fiction"
        }}

      iex> ExWikipedia.page(1)
      {:error, "There is no page with ID 1."}

      iex> ExWikipedia.page(%{})
      {:error, "%{} is not supported type for lookup."}

      iex> ExWikipedia.page("Pulp_Fiction", by: :page)
      {:ok,
       %ExWikipedia.Page{
         categories: ["Webarchive template wayback links",
          "All articles with dead external links",
          "Articles with dead external links from June 2016", ...],
         content: "Pulp Fiction is a 1994 American black comedy" <> ...,
         external_links: ["https://www.bbfc.co.uk/releases/pulp-fiction-film-0",
          "https://web.archive.org/web/20150510235257/http://www.bbfc.co.uk/releases/pulp-fiction-film-0",
          "https://boxofficemojo.com/movies/?id=pulpfiction.htm", ...],
         images: ["https://upload.wikimedia.org/wikipedia/en/3/3b/Pulp_Fiction_%281994%29_poster.jpg",
          "https://upload.wikimedia.org/wikipedia/en/thumb/2/2e/Willis_in_Pulp_Fiction.jpg/", ...],
         page_id: 54173,
         revision_id: 1059110452,
         summary: "Pulp Fiction is a 1994 American black comedy crime film written and directed by Quentin Tarantino, who conceived it with Roger Avary. Starring John Travolta, Samuel L. Jackson," <> ...,
         title: "Pulp Fiction",
         url: "https://en.wikipedia.org/wiki/Pulp_Fiction"
       }}

      iex> ExWikipedia.page(30007, by: :pageid)
      {:ok,
       %ExWikipedia.Page{
         categories: ["1990s English-language films", "1990s chase films",
          "1990s dystopian films", "1990s science fiction action films", ...],
         content: "The Matrix is a 1999 science fiction action film written and directed by the" <> ...,
         external_links: ["https://www.bbfc.co.uk/releases/matrix-1970-3", ...],
         images: ["https://upload.wikimedia.org/wikipedia/en/thumb/c/c1/The_Matrix_Poster.jpg/220px-The_Matrix_Poster.jpg", ...],
         is_redirect?: false,
         links: ["12 Monkeys", "1980s", "1999 in film", "2.35:1",
          "2001: A Space Odyssey (film)", "26th Saturn Awards", ...],
         page_id: 30007,
         revision_id: 1095349510,
         summary: "The Matrix is a 1999 science fiction action film written and directed by the Wachowskis." <> ...,
         title: "The Matrix",
         url: "https://en.wikipedia.org/wiki/The_Matrix"
       }}


  Redirects are allowed by default. Compare the following two results.

      iex> ExWikipedia.page(10971271)
      {:ok,
      %ExWikipedia.Page{
        # ...
        is_redirect?: true,
        page_id: 10971271,
        title: "Irene Angelico",
        url: "https://en.wikipedia.org/wiki/Irene_Angelico"
      }}

      iex> ExWikipedia.page(10971271, follow_redirect: false)
      {:error,
      "Content is from a redirected page, but `follow_redirect` is set to false"}

  ## Options

  See `ExWikipedia.Page` for full implementation details.
  """
  defdelegate page(wikipedia_id, opts \\ []), to: Page, as: :fetch
end
