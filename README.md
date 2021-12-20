# ExWikipedia

`ExWikipedia` is a Elixir wrapper to the original Wikipedia [API](https://en.wikipedia.org/w/api.php).
It bundles the Wikipedia API's response into a struct. 

Currently the package only supports searching up Wikipedia Pages via Wikipedia IDs. e.g. `54173`

Searching up through `titles` e.g. "Pulp Fiction" or `revision_id` e.g. 1059110452 are not yet supported.

## Usage 
```
iex> ExWikipedia.page(54173)
#OR
iex> ExWikipedia.page("54173")
{:ok,
 %ExWikipedia.Structs.WikipediaPage{
   categories: ["Webarchive template wayback links",
    "All articles with dead external links",
    "Articles with dead external links from June 2016", ...],
   content: "Pulp Fiction is a 1994 American black comedycrime film written and directed by Quentin Tarantino, who conceived it with Roger Avary. Starring John Travolta, Samuel L. Jackson, Bruce Willis, Tim Roth, Ving Rhames, and Uma Thurman, it tells several stories of criminal Los Angeles. The title refers to the pulp magazines and hardboiled crime novels popular during the mid-20th century, known for their graphic violence and punchy dialogue.\nTarantino wrote Pulp Fiction in 1992 and 1993, incorporating scenes that Avary originally wrote for True Romance (1993). Its plot occurs out of chronological order. The film is also self-referential from its opening moments, beginning with a title card that gives two dictionary definitions of \"pulp\". Considerable screen time is devoted to monologues and casual conversations with eclectic dialogue revealing each character's perspectives on several subjects, and the film features an ironic combination of humor and strong violence. TriStar Pictures reportedly turned down the script as \"too demented\". Then Miramax co-chairman Harvey Weinstein was enthralled, however, and the film became the first that Miramax fully financed.\nPulp Fiction won the Palme d'Or at the 1994 Cannes Film Festival, and was a major critical and commercial success. It was nominated for seven awards at the 67th Academy Awards, including Best Picture, and won Best Original Screenplay; it earned Travolta, Jackson, and Thurman Academy Award nominations and boosted their careers. Its development, marketing, distribution, and profitability had a sweeping effect on independent cinema.\nPulp Fiction is widely regarded as Tarantino's masterpiece, with particular praise for its screenwriting. The self-reflexivity, unconventional structure, and extensive homage and pastiche have led critics to describe it as a touchstone of postmodern film. It is often considered a cultural watershed, influencing films and other media that adopted elements of its style. The cast was also widely praised, with Travolta, Thurman and Jackson earning particular acclaim. In 2008, Entertainment Weekly named it the best film since 1983 and it has appeared on many critics' lists of the greatest films ever made. In 2013, Pulp Fiction was selected for preservation in the United States National Film Registry by the Library of Congress as \"culturally, historically, or aesthetically significant\".Pulp Fiction's narrative is told out of chronological order, and follows three main interrelated stories that each have a different protagonist: Vincent Vega, a hitman; Butch Coolidge, a prizefighter; and Jules Winnfield, Vincent's business partner.The film begins with a diner hold-up staged by a couple, then begins to shift from one storyline to another before returning to the diner for the conclusion. There are seven narrative sequences; the three primary storylines are preceded by intertitles:\nIf the seven sequences were ordered chronologically, they would run: 4a, 2, 6, 1, 7, 3, 4b, 5. Sequences 1 and 7 partially overlap and are presented from different points of view, as do sequences 2 and 6. According to Philip Parker, the structural form is \"an episodic narrative with circular events adding a beginning and end and allowing references to elements of each separate episode to be made throughout the narrative\". Other analysts describe the structure as a \"circular narrative\".Hitmen Jules Winnfield and Vincent Vega arrive at an apartment to retrieve a briefcase for their boss, gangster Marsellus Wallace, from a business partner, Brett. After Vincent checks the contents of the briefcase, Jules shoots one of Brett's associates. He declaims a passage from the Bible, and he and Vincent kill Brett for trying to double-cross Marsellus. They take the briefcase to Marsellus and wait while he bribes boxer Butch Coolidge to take a dive in his upcoming match.\nThe next day, Vincent purchases heroin from his drug dealer, Lance. He shoots up and drives to meet Marsellus's wife Mia, having agreed to escort her while Marsellus is out of town. They eat at Jack Rabbit Slim's, a 1950s-themed" <> ...,
   external_links: ["https://www.bbfc.co.uk/releases/pulp-fiction-film-0",
    "https://web.archive.org/web/20150510235257/http://www.bbfc.co.uk/releases/pulp-fiction-film-0",
    "https://boxofficemojo.com/movies/?id=pulpfiction.htm", ...],
   images: ["https://upload.wikimedia.org/wikipedia/en/3/3b/Pulp_Fiction_%281994%29_poster.jpg",
    "https://upload.wikimedia.org/wikipedia/en/thumb/2/2e/Willis_in_Pulp_Fiction.jpg/", ...],
   page_id: 54173,
   revision_id: 1059110452,
   summary: "Pulp Fiction is a 1994 American black comedycrime film written and directed by Quentin Tarantino, who conceived it with Roger Avary. Starring John Travolta, Samuel L. Jackson, Bruce Willis, Tim Roth, Ving Rhames, and Uma Thurman, it tells several stories of criminal Los Angeles. The title refers to the pulp magazines and hardboiled crime novels popular during the mid-20th century, known for their graphic violence and punchy dialogue.\nTarantino wrote Pulp Fiction in 1992 and 1993, incorporating scenes that Avary originally wrote for True Romance (1993)." <> ...,
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

If another HTTP Client is supplied, follow instructions from package to install.
Supply new `http_client` into `config.exs`: 
```
config :ex_wikipedia,
  http_client: Tesla
```
And you can invoke `iex> ExWikipedia.page("54173")` as you would normally. Do keep note of
how the package handles `status_code` vs `status`. `HTTPoison` sends back a `status_code` 
while `Tesla` will send back a `status` key as part of the response.

```
{:ok,
  %Tesla.Env{
   body: "{\"parse\":{\"title\":\"Pulp Fiction\",\"pageid\":54173,\"revid\":1061142350,\"redirects\":[],\"text\":{\"*\":\"<div class=\\\"mw-parser-output\\\"><div class=\\\"shortdescription nomobile noexcerpt noprint searchaux\\\" style=\\\"display:none\\\">1994 film</div>\\n<style" <> ...,
   headers: [
     {"date", "Mon, 20 Dec 2021 18:20:13 GMT"},
     {"server", "mw1400.eqiad.wmnet"},
     {"x-content-type-options", "nosniff"} | _
   ],
   method: :get,
   opts: [],
   query: [],
   status: 200,
   url: "https://en.wikipedia.org/w/api.php?action=parse&pageid=54173&format=json&redirects=false&prop=text|langlinks|categories|links|templates|images|externallinks|sections|revid|displaytitle|iwlinks|properties|parsewarnings|headhtml"
 }}
 ```

```
{:ok,
 %HTTPoison.Response{
   body: "{\"parse\":{\"title\":\"Pulp Fiction\",\"pageid\":54173,\"revid\":1061142350,\"redirects\":[],\"text\":{\"*\":\"<div class=\\\"mw-parser-output\\\"><div class=\\\"shortdescription nomobile noexcerpt noprint searchaux\\\" style=\\\"display:none\\\">1994 film</div>\\n<style" <> ...,
   headers: [
     {"Date", "Mon, 20 Dec 2021 19:45:28 GMT"},
     {"Server", "mw1406.eqiad.wmnet"},
     {"X-Content-Type-Options", "nosniff"} | _
   ],
   request: %HTTPoison.Request{
     body: "",
     headers: [],
     method: :get,
     options: [],
     params: %{},
     url: "https://en.wikipedia.org/w/api.php?action=parse&pageid=54173&format=json&redirects=false&prop=text|langlinks|categories|links|templates|images|externallinks|sections|revid|displaytitle|iwlinks|properties|parsewarnings|headhtml"
   },
   request_url: "https://en.wikipedia.org/w/api.php?action=parse&pageid=54173&format=json&redirects=false&prop=text|langlinks|categories|links|templates|images|externallinks|sections|revid|displaytitle|iwlinks|properties|parsewarnings|headhtml",
   status_code: 200
 }}
```

Notice the difference in key for status code returned. Tesla returns the key as `status`
while `HTTPoison` returns the key as `status_code`


## Installation

```elixir
def deps do
  [
    {:ex_wikipedia, "~> 0.1.0"}
  ]
end
```
