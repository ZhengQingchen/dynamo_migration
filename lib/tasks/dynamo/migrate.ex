defmodule Mix.Tasks.Dynamo.Migrate do
  use Mix.Task
  @shortdoc "Execs migration files"

  @spec run(any) :: :ok
  def run(_) do
    Mix.Task.run("app.start")
    DynamoMigration.migrate()
  end
end
