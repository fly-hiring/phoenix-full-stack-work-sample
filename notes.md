# Fly.io assignment notes. Toni UP
## Done
- Added a few graphql query fragments to convey the point of avoiding long multi-line hardcoded queries. Why?
  - Fragmentizing queries enables re-usability. 
  - Fragmentizing queries enables step-wise building of queries à la Ecto.

- Dashboard landing similar to scaleway & digital ocean. ie. table-ish UI.
  - `AppList` and `AppListItem` allow us to componentize the rendering logic in an isolated and convenient manner.
- Small branding touches
- PubSub-based monitoring of CPU usage. 
  - The source of data is an artificial system read `FlyWeb.Monitor` that broadcasts data per app.
- I abstracted away the Layout to `live.html.heex` parent template to convey the point of different liveview routes under the same layout (AppLive.Index and AppLive.Billing)
- Removed the `/show` route, I was focusing the UX on SidePanel for each App instead of different route. This is up for discussion since a side panel might not be enough for some features!
- Main top navigation indicates the current link highlighted in purple -> Accomplished that thanks to the `handle_params` at live_view, under `fly_web.ex`.


## Improvements & ToDos
### General
- Helper to obtain full https URL from `app.hostname`(gql query response)
- Extract (from `AppListItem`) the rendering of `app.regions` and `app.backupRegions` to its own subcomponent(s), different styling for enabled vs backup.
- Tooltips possibilities at the `AppList`:
  - Hovering on top of `app.name` displays IP address
  - Hovering on top of a region pill displays full city info
  - More tooltips all around.
- I don't enjoy the current layout snippet; feels like it's one of these off the shelves Tailwind templates that behave unpredictably. I would start the layout from scratch minimalistically, and build on top of that gradually.
- URL query params to define the state of the UI -> eg `/apps?selected=appKey&tab=volumes` would render the app index, wich `appKey` app in the SidePane and its `Volumes` tab open.
- Animations eg. `SideApp` appearance.
- One could definitely find many opportunities to componentize plenty of UI elements' render logic and CSS conditionals. Eg. Badges, SideApp sections, generic buttons, red vs green, backgrounds etc
- Make use of an isolated & agnostic Tab component, probably something similar to Surface's https://surface-ui.org/samplecomponents/Tabs
- Refactor `SideApp` into a `Phoenix.LiveComponent`, that will allow for it to receive updates from PubSub (via its DOM `id`) or stemming from its LiveView Parent `AppLive.Index`.
- Implement, as a tab at `SideApp`, an Environment Variable editor; to match the cli's `flyctl secrets` functionality.
- `Attached Volumes` inside `SideApp`, fill it with real data from query.
### GraphQL
- GraphQL improvements. Several fields have String type, some could potentially be more safely limited to a set of Enum? eg. `app.status` in GraphQL.
- Our graphql client `Neuron` does not provide subscription functionality as far as I read, it would be great to explore this possibility with this or any other client. 
- GraphQL. `AppList` does not require to fetch so many fields, reduce the number of fields according to the UI needs to save network data.
- If `SideApp` was accepted as a UI pattern -> Also fetch necessary data ONLY upon click (it's already in the socket now, which is not necessary).
- Implement a graphQL query for `app.logs`, result similar to CLI's `flyctl logs`, that will allow us to have visibility on what's going on at runtime.


## Questions
- Why is there a query field inside `app.ipAddress(addres: String!)` ? I'd expect only the `ipAddresses` that returns a List/Connection.
- Why is `app.appUrl` pointing to the public IP?
- Obfuscate the GraphQL schema unless it's a feature