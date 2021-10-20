defmodule ExWikipedia.Parser do
  @moduledoc """
  The `Parser` will take in a Wikipedia's JSON response and parse it
  returning a JSON response with information extracted.
  """

  def default_opts do
    [html_parser: Floki]
  end

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
    %{}
    |> Map.put(:categories, parse_categories(json))
    |> Map.put(:title, title)
    |> Map.put(:page_id, page_id)
    |> Map.put(:revision_id, revision_id)
    |> Map.put(:external_links, external_links)
    |> Map.put(:url, get_url(json, opts))
    |> Map.put(:content, parse_content(text, opts))
    |> Map.put(:summary, parse_summary(text, opts))
    |> Map.put(:images, parse_images(text, opts))
  end

  # Images from `images` key are just relative urls. Grabbing absolute urls from body
  defp parse_images(%{*: text}, opts) do
    opts = Keyword.merge(default_opts(), opts)
    html_parser = Keyword.get(opts, :html_parser)

    {:ok, document} = html_parser.parse_document(text)

    html_parser.find(document, "img")
    |> html_parser.attribute("src")
    |> Enum.map(fn x -> "https:" <> x end)
  end

  defp parse_summary(%{*: text}, opts) do
    opts = Keyword.merge(default_opts(), opts)
    html_parser = Keyword.get(opts, :html_parser)

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
    opts = Keyword.merge(default_opts(), opts)
    html_parser = Keyword.get(opts, :html_parser)

    with {:ok, head} <- html_parser.parse_document(headhtml),
         link_ast <- html_parser.find(head, "link[rel=\"canonical\"]"),
         [url] <- html_parser.attribute(link_ast, "href") do
      url
    else
      _ -> ""
    end
  end

  defp parse_content(%{*: text}, opts) do
    opts = Keyword.merge(default_opts(), opts)
    html_parser = Keyword.get(opts, :html_parser)

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
