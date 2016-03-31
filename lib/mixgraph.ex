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

  def get_package_version(package) do
    HexApi.get(package).body[:releases] 
    |> Enum.at(0)
    |> Map.fetch!("version")
  end

  def package_graph(package) do
    package
    |> get_package_deps
    |> get_connections
    |> create_graph
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

  def create_graph(connections) do
    connections
    |> List.flatten
    |> Enum.group_by(fn {package, deps} -> package end)
    |> Enum.map(fn x -> create_edges(x) end)
  end

  def create_edges({parent, children}) do
    child_list = children
    |> Enum.map(fn {_, child} -> child end)
    {parent, child_list}
  end

  def get_connections({package, deps}) do
    deps
    |> Enum.map(fn x -> create_connection(package, x) end)
  end

  def create_connection(package, {dep, []}) do
    {package, dep}
  end

  def create_connection(package, {dep, sub_deps}) do
    get_connections({dep, sub_deps})
  end

  def get_package_deps(package) do
    package 
    |> get_package_version  
    |> get_package_deps(package)
  end

  def get_package_deps(version, package) do
    deps = HexApi.get(package <> "/releases/" <> version).body[:requirements]
    |> Map.keys
    |> Enum.map(fn x -> Task.async(fn -> get_package_deps(x) end) end)
    |> Enum.map(fn x -> Task.await(x) end)
    {package, deps}
  end

  defp parse_args(args) do
    {options, _, _} = OptionParser.parse(args,
      switches: [foo: :string]
    )
    options
  end

end