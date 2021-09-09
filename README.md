# Fly.io Full Stack Phoenix Hiring Project

Hello! This is a hiring project for our [Full Stack developer position](https://fly.io/blog/fly-io-is-hiring-full-stack-developers/). If you apply, we'll ask you to do this project so we can assess your ability build customer facing features with the Fly.io GraphQL api in an Elixir/Phoenix/LiveView application.

## The Job

As a full stack developer at Fly.io, you'll be working with the parts of our product that customers interact directly with, such as our web dashboard, conversion funnels, landing pages, blog, and critical systems for authentication, billing, emails, and more. Most of our UX stack is built on Ruby and Rails, but after falling in love with Phoenix, we'll be doing a lot more Phoenix than Rails. To be effective in this role, you'll need to get comfortable working in both Rails and Phoenix, but it's okay to learn on the fly.

## Hiring Project

This app is a simplified version of the fly.io web dashboard built with the [Phoenix Framework](https://phoenixframework.org). It uses our GraphQL api to fetch data from your account and render it with LiveView. You can see a running version here: https://full-stack-phoenix-starter.fly.dev.

This project is built on Elixir Phoenix. It's ok if you don't yet know Elixir or Phoenix! We think you can learn, and are happy to have you learn while you do this project if you'd like.

Right now it has a list of your apps, and clicking on one loads a detail page. We need you to improve it.

`flyctl status` is a command that shows the most recent deployment and a list of VMs. It looks like this:

```
$ flyctl status
App
  Name     = flyio-web-staging          
  Owner    = fly                        
  Version  = 118                        
  Status   = running                    
  Hostname = flyio-web-staging.fly.dev  

Deployment Status
  ID          = d2f306ae-803b-fa48-d2f1-7d56a16de9ff         
  Version     = v118                                         
  Status      = successful                                   
  Description = Deployment completed successfully            
  Instances   = 3 desired, 3 placed, 3 healthy, 0 unhealthy  

Instances
ID       TASK   VERSION REGION DESIRED STATUS  HEALTH CHECKS      RESTARTS CREATED   
ed63d501 web    118     iad    run     running 1 total, 1 passing 0        2h38m ago 
38ece520 web    118     iad    run     running 1 total, 1 passing 0        2h39m ago 
3bf5f208 worker 118     iad    run     running                    0        2h39m ago 
```

We want you to add this to the web dashboard. And because it has LiveView, it should refresh every few seconds. The design is up to you -- make the best UX you can reasonably build in a reasonable amount of time. 

We expect this to take about 4 hours if you're experienced with Rails, and a little less if you know Phoenix. We're not timing you, though. If you're learning and enjoying the project, spend as much time as you want.

### Submitting your work

Once you're happy with your work, deploy it to a new fly app so we can see it in action. The repo already has a `Dockerfile`, so it should be as simple as `flyctl launch`.

Then submit the following via email:
- a link to your live app
- a link to your source code
- add a `notes.md` file with a short summary of
  - what you built and what you didn't build
  - what you'd improve or fix if you had more time
  - how you'd determine if this feature is successful

After you've submitted your project, we'll have 3 Fly.io engineers evaluate your work with standardized criteria. This takes 3-5 days and we'll let you know as soon as we have results.

### What we care about

- Always strive to make the best developer UX possible (a great UX can be ugly, though! we're not grading you on graphic design skills)
- Don't spend time making this perfect. Rough edges are fine if it helps you move quickly, just note them in the summary.
- Your code should be clear and easy to understand.
- If something is too complicated, try to get by without it and explain what you wanted to do in the summary.
- The notes are important! We want to know how you think about end users and how you think we should solve their problems.

### What we don't care about

- Don't spend time writing tests for this sample. Tests are great, but time consuming.
- If you're like us, pride pushes you to make things better than they need to be. Don't do that for this project. Channel that energy into your notes, keep the scope of your code small.
- Edge cases. Don't solve every scenario in code. If you think of edge cases or gotchas that might affect users, put 'em in your notes.

## Getting Started 

To start your Phoenix server:

  * [Install `flyctl` and sign up for a Fly.io account](https://fly.io/docs/getting-started/installing-flyctl/)
  * Install dependencies with `mix deps.get`
  * Install Node.js dependencies with `npm install` inside the `assets` directory
  * Compile assets with `npm run deploy`
  * Start Phoenix endpoint with `mix phx.server`
  * Run `flyctl auth token` to print your API token

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guide](https://fly.io/docs/getting-started/elixir/).

### Tips and Tricks

- You'll need a fly.io personal access token in order to use the api. You can get your api token by running `flyctl auth token` or from the [web dashboard](https://web.fly.io/user/personal_access_tokens).
- Test your queries in our [GraphQL playground](https://api.fly.io/graphql).
- Refer to the GraphQL queries in [`flyctl`'s GitHub repo](https://github.com/superfly/flyctl). Here's the one for [`flyctl status`](https://github.com/superfly/flyctl/blob/master/api/resource_monitoring.go#L5-L54).
- You're going to need some apps in your account in order to test with. Use `flyctl launch` with one of the [example](https://github.com/fly-apps/go-example) [apps](https://github.com/superfly/rails-example), or try launching a postgres or keydb cluster.
- Use `flyctl scale count`, `flyctl vm stop`, `flyctl vm restart`, and deploys to change your test app's VMs 
- The app is built with [Tailwind CSS](https://tailwindcss.com). It's okay to refer to the docs or use whatever markup you found on StackOverflow to get the look you want without spending too much time
- We have designers to make things look pretty, but it's up to you to make a great experience. 
