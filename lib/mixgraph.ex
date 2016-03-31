defmodule Mixgraph do

  def main(args) do
    args |> parse_args |> process
  end

  def process([package: package]) do
    package_graph(package)
  end

  def process(x) do
    IO.puts "Run `mixgraph --package=<package_name>` "
    IO.puts "Example `mixgraph --package=hackney` "
  end

  def package_graph(package) do
    package
    |> get_package_deps
    |> get_connections
    |> append_single_entries
    |> GraphPlot.plot
  end

  def append_single_entries(connections) do
    existing_parents = connections
    |> Enum.map(fn {parent, _} -> parent end)
    unique_parents = connections
    |> Enum.map(fn connection -> create_unique_parents(connection) end)
    |> List.flatten
    |> Enum.uniq
    additional_connections = (unique_parents -- existing_parents)
    |> Enum.map(fn x -> {x, []} end)
    additional_connections ++ connections
  end

  def create_unique_parents({parent, children}) do
    [parent] ++ children
  end

  def get_connections(connections) do
    connections
    |> List.flatten
    |> Enum.uniq
  end

  def get_package_version(package) do
    HexApi.get(package).body[:releases] 
    |> Enum.at(0)
    |> Map.fetch!("version")
  end

  def get_package_deps(package) do
    package 
    |> get_package_version  
    |> get_package_deps(package, [])
  end

  def get_package_deps(package, packages) do
    package 
    |> get_package_version  
    |> get_package_deps(package, packages)
  end

  def get_package_deps(version, package, packages) do
    children = HexApi.get(package <> "/releases/" <> version).body[:requirements]
    |> Map.keys
    nested_children = children
    |> Enum.map(fn x -> Task.async(fn -> get_package_deps(x, packages ++ [{package, children}]) end) end)
    |> Enum.map(fn x -> Task.await(x, 10000) end)
    packages ++ nested_children
  end

  defp parse_args(args) do
    {options, _, _} = OptionParser.parse(args,
      switches: [foo: :string]
    )
    options
  end

end