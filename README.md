# ExWikipedia

`ExWikipedia` is a Elixir wrapper to the original Wikipedia [API](https://en.wikipedia.org/w/api.php).
It bundles the Wikipedia API's response into a struct. 

Currently the package only supports searching up Wikipedia Pages via Wikipedia IDs. e.g. `54173`

Searching up through `titles` e.g. "Pulp Fiction" or `revision_id` e.g. 1059110452 are not yet supported.

## Usage 
```
iex> ExWikipedia.page(54173)
{:ok,
 %ExWikipedia.Structs.WikipediaPage{
   categories: ["Webarchive template wayback links",
    "All articles with dead external links",
    "Articles with dead external links from June 2016", ...],
   content: "1994 film This article is about the film. For other uses, see  Pulp fiction .... <> _"
   external_links: ["https://www.bbfc.co.uk/releases/pulp-fiction-film-0",
    "https://web.archive.org/web/20150510235257/http://www.bbfc.co.uk/releases/pulp-fiction-film-0",
    "https://boxofficemojo.com/movies/?id=pulpfiction.htm", ...],
   images: ["https://upload.wikimedia.org/wikipedia/en/3/3b/Pulp_Fiction_%281994%29_poster.jpg",
    "https://upload.wikimedia.org/wikipedia/en/thumb/2/2e/Willis_in_Pulp_Fiction.jpg/", ...],
   page_id: 54173,
   revision_id: 1059110452,
   summary: "1994 film.mw-parser-output .hatnote{font-style:italic}.mw-parser-output div.hatnote{padding-left:1.6em;margin-bottom:0.5em}.mw-parser-output .hatnote i{font-style:normal}.mw-parser-output .hatnote+link+.hatnote{margin-top:-0.5em}",
   title: "Pulp Fiction",
   url: "https://en.wikipedia.org/wiki/Pulp_Fiction"
 }}
```

`Ex-Wikipedia` supports both `string` and `integer` ids:

```
iex> ExWikipedia.page("54173")

{:ok,
 %ExWikipedia.Structs.WikipediaPage{
   categories: ["Webarchive template wayback links",
    "All articles with dead external links",
    "Articles with dead external links from June 2016", ...],
   content: "1994 film This article is about the film. For other uses, see  Pulp fiction .... <> _"
   external_links: ["https://www.bbfc.co.uk/releases/pulp-fiction-film-0",
    "https://web.archive.org/web/20150510235257/http://www.bbfc.co.uk/releases/pulp-fiction-film-0",
    "https://boxofficemojo.com/movies/?id=pulpfiction.htm", ...],
   images: ["https://upload.wikimedia.org/wikipedia/en/3/3b/Pulp_Fiction_%281994%29_poster.jpg",
    "https://upload.wikimedia.org/wikipedia/en/thumb/2/2e/Willis_in_Pulp_Fiction.jpg/", ...],
   page_id: 54173,
   revision_id: 1059110452,
   summary: "1994 film.mw-parser-output .hatnote{font-style:italic}.mw-parser-output div.hatnote{padding-left:1.6em;margin-bottom:0.5em}.mw-parser-output .hatnote i{font-style:normal}.mw-parser-output .hatnote+link+.hatnote{margin-top:-0.5em}",
   title: "Pulp Fiction",
   url: "https://en.wikipedia.org/wiki/Pulp_Fiction"
 }}
```

When invalid ids are passed in:

```
iex> ExWikipedia.page("pulp fiction")
{:error, "The Wikipedia ID supplied is not valid."}

iex> ExWikipedia.page(%{title: "pulp fiction"})
{:error, "The Wikipedia ID supplied is not valid."}
```

String titles and other types that are not able to convert to integers are _not_ supported.


## Installation

```elixir
def deps do
  [
    {:ex_wikipedia, "~> 0.1.0"}
  ]
end
```
