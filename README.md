# Mixgraph

Create a dependency graph for any hex package published in hex.pm

As easy as `./mixgraph --package=addict`
![Image of interactive graph for addict](http://i.imgur.com/cfrWRMO.png)

### Installation and Usage

View [the module](https://github.com/sivsushruth/mixgraph/blob/master/lib/mixgraph.ex) to see list of available function calls.

Steps to generate using an escript:
```
git clone https://github.com/sivsushruth/mixgraph
cd mixgraph
mix deps.get
mix escript.build
./mixgraph --package=<package_name>
```
You can also do `Mixgraph.package_graph("<package_name>")`
```
Mixgraph.package_graph("addict")
```


The [package](https://hex.pm/packages/mixgraph) can also be installed as:

  1. Add mixgraph to your list of dependencies in `mix.exs`:

        def deps do
          [{:mixgraph, "~> 0.0.1"}]
        end

  2. Ensure mixgraph is started before your application:

        def application do
          [applications: [:mixgraph]]
        end
        
### TODO
- [ ] Read dependencies from a local mix.exs
- [ ] Improve ease of installation as a command line tool

### Help
* Clone repo and test the project
* Submit bug reports
* Provide suggestions for next release
* Help with completing the TODO


