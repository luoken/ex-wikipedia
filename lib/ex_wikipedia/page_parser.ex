defmodule ExWikipedia.PageParser do
  @moduledoc """
  Parses Wikipedia's JSON response.

  The response returned from the Wikipedia API is valid JSON but we still need to sanitize
  it before returning to the user. Any HTML tags will get sanitized during this stage.
  """

  @behaviour ExWikipedia.Parser

  @doc """
  Sanitizes the response received from Wikipedia before returning to user. The response returned
  could be either

  options:

  -- `:html_parser`: Parser used to parse HTML. Default: Floki


  ## Examples

      iex> ExWikipedia.PageParser.parse(%{
        categories: [
          %{*: "Webarchive_template_wayback_links", hidden: "", sortkey: ""},
          %{*: "All_articles_with_dead_external_links", hidden: "", sortkey: ""}
        ],
        title: "Pulp Fiction",
        pageid: 54173,
        revid: 1059110452,
        externallinks: [
          "https://www.bbfc.co.uk/releases/pulp-fiction-film-0",
          "https://web.archive.org/web/20150510235257/http://www.bbfc.co.uk/releases/pulp-fiction-film-0",
          "https://boxofficemojo.com/movies/?id=pulpfiction.htm" | _],
        text: %{
         *: "<div class=\"mw-parser-output\"><div class=\"shortdescription nomobile noexcerpt noprint
            searchaux\" style=\"display:none\">1994 film</div><style data-mw-deduplicate=\"
            TemplateStyles:r1033289096\">.mw-parser-output .hatnote{font-style:italic}.mw-parser-output
            div.hatnote{padding-left:1.6em;margin-bottom:0.5em}..."}
        })
      %{
        categories: [
          "Webarchive template wayback links",
          "All articles with dead external links",
          "Articles with dead external links from June 2016" | _
        ],
        content: "1994 film This article is about the film. For other uses, see  Pulp fiction .
        Pulp Fiction  is a 1994 American  black comedy crime  film written and directed
        by  Quentin Tarantino , who conceived it with  Roger Avary .  Starring  John Travolta ,
        Samuel L. Jackson ,  Bruce Willis ,  Tim Roth ...",
        page_id: 54173,
        revision_id: 1059110452,
        summary: "1994 film...",
        title: "Pulp Fiction",
        url: "https://en.wikipedia.org/wiki/Pulp_Fiction"
      }

      iex> ExWikipedia.page(1)
      {:error, "There is no page with ID 1."}

      iex> ExWikipedia.page(%{})
      {:error, "The Wikipedia ID supplied is not valid."}

  """
  @impl true
  def parse(json, opts \\ [])

  def parse(
        %{
          title: title,
          pageid: page_id,
          revid: revision_id,
          externallinks: external_links,
          text: text
        } = json,
        opts
      ) do
    {:ok,
     %{}
     |> Map.put(:categories, parse_categories(json))
     |> Map.put(:title, title)
     |> Map.put(:page_id, page_id)
     |> Map.put(:revision_id, revision_id)
     |> Map.put(:external_links, external_links)
     |> Map.put(:url, get_url(json, opts))
     |> Map.put(:content, parse_content(text, opts))
     |> Map.put(:summary, parse_summary(text, opts))
     |> Map.put(:images, parse_images(text, opts))}
  end

  def parse(%{error: %{info: info}}, _opts), do: {:error, info}

  def parse(_, _opts), do: {:error, "Wikipedia response too ambiguous."}

  # Images from `images` key are just relative urls. Grabbing absolute urls from body
  defp parse_images(%{*: text}, opts) do
    html_parser = Keyword.get(opts, :html_parser, Floki)

    {:ok, document} = html_parser.parse_document(text)

    html_parser.find(document, "img")
    |> html_parser.attribute("src")
    |> Enum.map(fn x -> "https:" <> x end)
  end

  defp parse_summary(%{*: text}, opts) do
    html_parser = Keyword.get(opts, :html_parser, Floki)

    with {:ok, document} <- html_parser.parse_document(text),
         [{_tag, _attr, ast} | _] <- html_parser.filter_out(document, "table"),
         [_first, toc | _rest] <- html_parser.find(ast, "div") do
      toc_index = Enum.find_index(ast, fn x -> x == toc end)

      Enum.slice(ast, 0, toc_index)
      |> html_parser.filter_out("sup")
      |> html_parser.text()
      |> String.trim()
    else
      _ -> ""
    end
  end

  defp get_url(%{headhtml: %{*: headhtml}}, opts) do
    html_parser = Keyword.get(opts, :html_parser, Floki)

    with {:ok, head} <- html_parser.parse_document(headhtml),
         link_ast <- html_parser.find(head, "link[rel=\"canonical\"]"),
         [url] <- html_parser.attribute(link_ast, "href") do
      url
    else
      _ -> ""
    end
  end

  defp parse_content(%{*: text}, opts) do
    html_parser = Keyword.get(opts, :html_parser, Floki)

    {:ok, document} = html_parser.parse_document(text)

    [text | _] =
      html_parser.find(document, ".mw-parser-output")
      |> html_parser.filter_out("table")
      |> html_parser.filter_out("div.toc")
      |> html_parser.filter_out("sup")

    html_parser.text(text, sep: " ")
    |> String.replace("[ edit ] ", "")
  end

  # The categories are inside of the "*" key
  defp parse_categories(%{categories: categories}) do
    Enum.map(categories, fn %{*: keys} -> String.replace(keys, "_", " ") end)
  end
end
