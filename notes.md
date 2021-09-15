# Notes

## Stuff done

- Minor changes to the Timeline section of an app.
 - Either green checkmark or red X mark have a tooltip indicating what they mean.
 - The date/time is displayed in a more user friendly format.
- Added a Deployment Status section, showing the status and version of the latest deployment, if available.
- Added an Instances section, with minimal data shown (id an status) and a link to show a full view of that allocation.
- Added a new Instance route, to show full details of a specific allocation
- Live refresh to all pages

## Nice to have

- The Instance data does not need to be shown as a grid, as there will be only one row per instance.
- Actions that affect the apps. Right now the view is pretty much read only.
- Some user configuration. For example, currently all allocations are shown with now way to change it to show only the running ones.
- Timeline to show only a few releases, with an option to show all of them
- When some sections do not have data yet, show the user some link to the docs explaning next steps or how to proceed. Or, when possible, a link to apply the required action. 
- Some data like the region, can probably be formatter to be more user friendly or understandable. For example, region: scl does not tell me much with my current knowledge, some dates can be formatted as (X hours ago)
- Given the GraphQL API, there seems to be a lot of more info to be added to an app's dashboard.
- Top header with the navigation always visible (maybe hidden when scrolling up, etc)

## Gotchas

- The UI may start breaking when there is tons of data, for example in the Timeline section or in the grids
- Some of the UI still appears emtpy when there is no data, where it could show a clearer message to the user, maybe with a link to an action or documentation.

## Determining if the feature is successfull

- One way is by using some sort of analytics, especially if there are user actions in the web UI. Like checking how much the users use the web UI vs the CLI. Analytics can be per user or just by checking the web server activity
- Community reactions or feedback in the forums or social media
- If the development team does not use the feature much, I would say there is bigger chances that the users aren't either