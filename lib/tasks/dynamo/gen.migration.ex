defmodule Mix.Tasks.Dynamo.Gen.Migration do
  use Mix.Task
  import Macro, only: [camelize: 1, underscore: 1]
  import Mix.Generator

  @shortdoc "Generates a new migration for DynamoDB"

  def run(args) do
    migrations_path = DynamoMigration.migration_file_path()
    name = args |> REnum.first()
    base_name = "#{underscore(name)}.exs"
    file = Path.join(migrations_path, "#{timestamp()}_#{base_name}")
    unless File.dir?(migrations_path), do: create_directory(migrations_path)
    fuzzy_path = Path.join(migrations_path, "*_#{base_name}")

    if Path.wildcard(fuzzy_path) != [] do
      Mix.raise(
        "migration can't be created, there is already a migration file with name #{name}."
      )
    end

    assigns = [mod: Module.concat([Dynamo, Migrations, camelize(name)])]
    create_file(file, migration_template(assigns))
    file
  end

  defp timestamp do
    {{y, m, d}, {hh, mm, ss}} = :calendar.universal_time()
    "#{y}#{pad(m)}#{pad(d)}#{pad(hh)}#{pad(mm)}#{pad(ss)}"
  end

  defp pad(i) when i < 10, do: <<?0, ?0 + i>>
  defp pad(i), do: to_string(i)

  embed_template(:migration, """
  defmodule <%= inspect @mod %> do
    def change do
    end
  end
  """)
end