# ExWikipedia

`ExWikipedia` is an Elixir client for the [Wikipedia API](https://en.wikipedia.org/w/api.php). Other languages are supported as they are passed in through options. See usage section for example.

## Usage

```elixir
iex> ExWikipedia.page(54173, by: :page_id)
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
```

```elixir
iex> ExWikipedia.page("Pulp Fiction", by: :title)
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
```

```elixir
 iex> ExWikipedia.page(54173, language: "ja")
 {:ok,
 %ExWikipedia.Page{
   categories: ["LCCN識別子が指定されている記事",
    "労働における休み", "参照方法", "曜日",
    "独自研究の除去が必要な記事/2019年4月"],
   content: "休日（きゅうじつ）とは、「休みの日」のことであり、業務・授業などを休む日である。辞書『広辞苑』では「休日」の2番目の意味として、特に日曜日や国民の祝日（≒各国の法定の祝日）など、という説明をしている。\n「休暇」（きゅうか）のほうも同様に、学校・会社・官庁などの「やすみ」のことである。そこに追加説明があり、しばしば日曜・祝日など以外のやすみを言う、とされる。\nなお、英語では土日" <> ...,
   # ... etc...
  }}
 ```

## Defaults

This currently uses `HTTPoison` as its default HTTP client.

If you wish to use a different HTTP client to drive the requests, e.g. `Tesla`, you can specify it as the `:http_client` option along with any needed customizations for the `:status_key` or `:body_key`.  E.g.

```elixir
 iex> ExWikipedia.page(54173, [http_client: Tesla, status_key: :status])
{:ok,
 %ExWikipedia.Page{
   categories: ["Webarchive template wayback links",
   # ... etc...
 }
}
```

`Jason` is the default JSON encoder (customize this via the `:decoder` option).
`Floki` is the default HTML parser used by the page parser. See `ExWikipedia.PageParser` for its use.
`"en"` is the default language for the wikipedia look up. The default language can be changed inside of 
`config.exs`. The `language` option is also available for setting language on a function call basis.
`language: "en"`
`page_id` is the default way the Wikipedia API will look up by.


See `ExWikipedia.Page.fetch/2` for full implementation details.

## Installation

```elixir
def deps do
  [
    {:ex_wikipedia, "~> 0.1.2"}
  ]
end
```
