defmodule ExWikipedia.PageParserTest do
  use ExWikipedia.FileCase, async: true
  alias ExWikipedia.PageParser

  import Mox
  setup :verify_on_exit!

  describe "parse/2" do
    @tag contents: "54173.json"
    test "returns map of usable keys", %{contents: contents} do
      decoded_contents = Jason.decode!(contents, keys: :atoms)

      assert {:ok,
              %{
                categories: [
                  "Webarchive template wayback links",
                  "All articles with dead external links",
                  "Articles with dead external links from June 2016" | _
                ],
                content: "Pulp Fiction is a 1994 American black comedycrime film" <> _,
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
                revision_id: 1_059_110_452,
                summary: "Pulp Fiction is a 1994 American black comedycrime film" <> _,
                title: "Pulp Fiction",
                url: "https://en.wikipedia.org/wiki/Pulp_Fiction",
                is_redirect?: false
              }} = PageParser.parse(decoded_contents, [])
    end

    test ":errors when invalid id is passed in" do
      assert {:error, _} = PageParser.parse(%{error: %{info: "There is no page with ID 1."}})
    end

    test ":errors when id is too ambiguous" do
      json = %{
        title: "pulp fiction",
        pageid: 54_173,
        text: "some text in here"
      }

      assert {:error, _} = PageParser.parse(json)
    end

    @tag contents: "10971271.json"
    test "returns :error when content represents a redirected page but follow_redirect is false",
         %{contents: contents} do
      decoded_contents = Jason.decode!(contents, keys: :atoms)

      assert {:error, _} = PageParser.parse(decoded_contents, follow_redirect: false)
    end

    @tag contents: "10971271.json"
    test "returns :ok when content represents a redirected page and follow_redirect is true", %{
      contents: contents
    } do
      decoded_contents = Jason.decode!(contents, keys: :atoms)

      assert {:ok, %{is_redirect?: true}} =
               PageParser.parse(decoded_contents, follow_redirect: true)
    end

    test ":ok when categories is not present" do
      parse = %{
        parse: %{
          pageid: 54_173,
          redirects: [],
          revid: 1_063_115_250,
          text: %{
            *: "text in here"
          },
          title: "Pulp Fiction"
        }
      }

      assert {:ok,
              %{
                categories: [],
                content: "",
                title: "Pulp Fiction",
                external_links: nil,
                images: [],
                is_redirect?: false
              }} = PageParser.parse(parse)
    end
  end
end
