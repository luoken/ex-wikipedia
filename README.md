# ExWikipedia

`ExWikipedia` is an Elixir client for the [Wikipedia API](https://en.wikipedia.org/w/api.php).

Currently the package only supports searching for Wikipedia Pages by IDs. e.g. `54173`; searching by title or revision ID is not yet supported.

## Usage

```elixir
iex> ExWikipedia.page(54173)
{:ok,
 %ExWikipedia.Structs.WikipediaPage{
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
   summary: "Pulp Fiction is a 1994 American black comedycrime film written and directed by Quentin Tarantino, who conceived it with Roger Avary. Starring John Travolta, Samuel L. Jackson," <> ...,
   title: "Pulp Fiction",
   url: "https://en.wikipedia.org/wiki/Pulp_Fiction"
 }}
```

This currently uses `HTTPoison` as its default HTTP client. 

If you wish to use a different HTTP client to drive the requests, e.g. `Tesla`, you can specify it as the `:http_client` option along with any needed customizations for the `:status_key` or `:body_key`.  E.g.

```elixir
 iex> ExWikipedia.page(54173, [http_client: Tesla, state_key: :status])
{:ok,
 %ExWikipedia.Page{
   categories: ["Webarchive template wayback links",
   # ... etc...
 }
}
```

See `ExWikipedia.Page.fetch/2` for more options.


## Installation

```elixir
def deps do
  [
    {:ex_wikipedia, "~> 0.1.0"}
  ]
end
```
