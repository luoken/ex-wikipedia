# ExWikipedia

`ExWikipedia` is a Elixir wrapper to the original Wikipedia [API](https://en.wikipedia.org/w/api.php).
It bundles the Wikipedia API's response into a struct. 

Currently the package only supports searching up Wikipedia Pages via Wikipedia IDs. e.g. `54173`

Searching up `titles` e.g. "Pulp Fiction" or `revision_id` e.g. 1059110452 are not yet supported.

## Usage

```elixir
iex> ExWikipedia.page(54173)
#OR
iex> ExWikipedia.page("54173")
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

When invalid ids are passed in:

```elixir
iex> ExWikipedia.page("pulp fiction")
{:error, "The Wikipedia ID supplied is not valid."}

iex> ExWikipedia.page(%{title: "pulp fiction"})
{:error, "The Wikipedia ID supplied is not valid."}
```

String titles and other types that are unable to convert to integers are _not_ supported.

If another HTTP Client is supplied, follow instructions from package to install.
Supply new `http_client` into `config.exs`

If no HTTP Client is supplied, it will default to `HTTPoison` as a default.

## Installation

```elixir
def deps do
  [
    {:ex_wikipedia, "~> 0.1.0"}
  ]
end
```
