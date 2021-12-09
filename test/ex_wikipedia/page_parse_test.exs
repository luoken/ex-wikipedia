defmodule ExWikipedia.ParserTest do
  use ExWikipedia.FileCase
  alias ExWikipedia.PageParser

  describe "parse/2" do
    @tag contents: "54173.json"

    test "returns map of usable keys", %{contents: contents} do
      %{parse: contents} = Jason.decode!(contents, keys: :atoms)

      assert %{
               categories: [
                 "Webarchive template wayback links",
                 "All articles with dead external links",
                 "Articles with dead external links from June 2016" | _
               ],
               content:
                 "1994 film This article is about the film. For other uses, see  Pulp fiction . Pulp Fiction  is a 1994 American  crime film  written" <>
                   _,
               external_links: [
                 "https://www.bbfc.co.uk/releases/pulp-fiction-film-0",
                 "https://web.archive.org/web/20150510235257/http://www.bbfc.co.uk/releases/pulp-fiction-film-0",
                 "https://boxofficemojo.com/movies/?id=pulpfiction.htm",
                 "https://web.archive.org/web/20110430222745/http://www.boxofficemojo.com/movies/?id=pulpfiction.htm"
                 | _
               ],
               images: [
                 "https://upload.wikimedia.org/wikipedia/en/3/3b/Pulp_Fiction_%281994%29_poster.jpg",
                 "https://upload.wikimedia.org/wikipedia/en/thumb/2/2e/Willis_in_Pulp_Fiction.jpg/220px-Willis_in_Pulp_Fiction.jpg",
                 "https://upload.wikimedia.org/wikipedia/commons/thumb/4/4f/Quentin_Tarantino_Uma_Thurman_John_Travolta_Cannes_2014.jpg/220px-Quentin_Tarantino_Uma_Thurman_John_Travolta_Cannes_2014.jpg",
                 "https://upload.wikimedia.org/wikipedia/en/thumb/f/fe/PulpFictionCase.jpg/200px-PulpFictionCase.jpg"
                 | _
               ],
               page_id: 54_173,
               revision_id: 1_048_639_245,
               summary:
                 "1994 film.mw-parser-output .hatnote{font-style:italic}.mw-parser-output div.hatnote{padding-left:1.6em;margin-bottom:0.5em}.mw-parser-output .hatnote i{font-style:normal}.mw-parser-output .hatnote+link+.hatnote{margin-top:-0.5em}",
               title: "Pulp Fiction",
               url: "https://en.wikipedia.org/wiki/Pulp_Fiction"
             } = PageParser.parse(contents, [])
    end
  end
end
