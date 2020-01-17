defmodule ExCast.MixProject do
  use Mix.Project

  def project do
    [
      app: :cast,
      version: "0.1.0",
      elixir: "~> 1.9",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(Mix.env()),
      deps: deps(),
      description: description(),
      package: package(),
      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:sweet_xml, "~> 0.6"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp aliases(:test) do
    [
      compile: [&compile_examples/1, "compile"],
      "deps.get": [&prereqs/1, "deps.get"],
      clean: [&clean_examples/1, "clean"]
    ]
  end

  defp aliases(_), do: []

  defp elixirc_paths(:test), do: ["lib", "test/support"]

  defp elixirc_paths(_), do: ["lib"]

  defp prereqs(_) do
    [
      {"castxml",
       "castxml not found - install it with apt-get install castxml or by following the instructions under: https://github.com/fnchooft/CastXML"},
      {"make", "make not found"}
    ]
    |> Enum.reduce([], &check_tool/2)
    |> Enum.map(&Mix.shell().info/1)
    |> case do
      [] -> :ok
      _ -> raise "Missing pre-requisite(s)"
    end
  end

  defp check_tool({tool, err}, errors) do
    tool
    |> System.find_executable()
    |> case do
      nil -> [err | errors]
      _path -> errors
    end
  end

  @examples ["c_example"]
  defp compile_examples(_),
    do:
      @examples
      |> Enum.each(&System.cmd("make", [], cd: Path.join("test/support", &1)))

  defp clean_examples(_),
    do:
      @examples
      |> Enum.each(&System.cmd("make", ["clean"], cd: Path.join("test/support", &1)))

  defp description,
    do: "C(++) AST to elixir"

  defp package,
    do: [
      maintainers: ["Jean Parpaillon"],
      licenses: ["Apache 2"],
      links: %{"GitHub" => "https://github.com/jeanparpaillon/ex_cast"},
      files: ~w(mix.exs README.md lib test .formatter.exs)
    ]

    defp docs,
    do: [
    main: "Cast",
    extras: ["README.md"]
    ]
end
