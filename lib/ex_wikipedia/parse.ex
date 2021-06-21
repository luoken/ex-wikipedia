defmodule ExWikipedia.Parser do
  def parse(
        %{
          title: title,
          pageid: page_id,
          revid: revision_id,
          externallinks: external_links,
          text: text
        } = json
      ) do
    %{}
    |> Map.put(:categories, parse_categories(json))
    |> Map.put(:title, title)
    |> Map.put(:page_id, page_id)
    |> Map.put(:revision_id, revision_id)
    |> Map.put(:external_links, external_links)
    |> Map.put(:url, get_url(json))
    |> Map.put(:content, parse_text(text))
    |> Map.put(:summary, parse_summary(text))
    |> Map.put(:images, parse_images(text))
  end

  # Images from `images` key are just relative urls. Grabbing absolute urls from body
  defp parse_images(%{*: text}) do
    {:ok, document} = Floki.parse_document(text)
    Floki.find(document, "img")
    |> Floki.attribute("src")
    |> Enum.map(fn x -> "https:" <> x end)
  end

  defp parse_summary(%{*: text}) do
    with {:ok, document} <- Floki.parse_document(text),
         [{_tag, _attr, ast} | _] <- Floki.filter_out(document, "table"),
         [_first, toc | _rest] = Floki.find(ast, "div") do
      toc_index = Enum.find_index(ast, fn x -> x == toc end)

      Enum.slice(ast, 0, toc_index)
      |> Floki.filter_out("sup")
      |> Floki.text()
      |> String.trim()
    else
      _ -> ""
    end
  end

  defp get_url(%{headhtml: %{*: headhtml}}) do
    with {:ok, head} <- Floki.parse_document(headhtml),
         link_ast <- Floki.find(head, "link[rel=\"canonical\"]"),
         [url] <- Floki.attribute(link_ast, "href") do
      url
    else
      _ -> ""
    end
  end

  defp parse_text(%{*: text}) do
    {:ok, document} = Floki.parse_document(text)
    [text | _] =
      Floki.find(document, ".mw-parser-output")
      |> Floki.filter_out("table")
      |> Floki.filter_out("div.toc")
      |> Floki.filter_out("sup")

    Floki.text(text, sep: " ")
    |> String.replace("[ edit ] ", "")
  end

  # The categories are inside of the "*" key
  defp parse_categories(%{categories: categories}) do
    Enum.map(categories, fn %{*: keys} -> String.replace(keys, "_", " ") end)
  end
end
