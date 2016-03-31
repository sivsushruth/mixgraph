# Mixgraph

Create a dependency graph for any hex package published in hex.pm
As easy as `./mixgraph --package=hackney`
![Image of interactive graph for hackney](http://i.imgur.com/BE8hQH3.png)

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add mixgraph to your list of dependencies in `mix.exs`:

        def deps do
          [{:mixgraph, "~> 0.0.1"}]
        end

  2. Ensure mixgraph is started before your application:

        def application do
          [applications: [:mixgraph]]
        end

View [the module](https://github.com/sivsushruth/mixgraph/blob/master/lib/mixgraph.ex) to see list of available function calls.
Steps to generate using an escript:
```
git clone https://github.com/sivsushruth/mixgraph
cd mixgraph
mix deps.get
mix escript.build
./mixgraph --package=<package_name>   #./mixgraph --package=hackney
```
You can also do 
```
Mixgraph.package_graph("hackney")
```
