defmodule Mix.Tasks.Api do
  defmodule Pulldata do
    import Ecto.Query

    use Mix.Task
    use Timex

    alias Callum.{Repo, Weight, Macro}

    @myfitnesspal_endpoint "https://www.myfitnesspal.com/account/login"
    @withings_endpoint     "http://home.barratt.me:4000/api/v1/weighins"
    @macro_types           ["calories", "carbs", "fat", "protein"]

    @shortdoc "Import Macronutrient & Withings data from Rails API"

    @moduledoc """
    Import the following data:
    import_macros -> Fetch MyFitnessPal JSON data and store it in the "macros" table
    import_weighins -> Fetch Withings JSON data and store it in the "weighins" table
    """

    def run(_) do
      Mix.Task.run "app.start", []

      import_macros
      import_weighins
    end

    @doc """
    Fetch the Rails login session_cookie from MyFitnessPal
    We use this to gain access to JSON api's from within a logged in state.
    """

    def mfp_auth_session do
      HTTPoison.post!(@myfitnesspal_endpoint, {:form, [username: System.get_env("MFP_USER"), password: System.get_env("MFP_PASS")]}, %{"Content-type" => "application/x-www-form-urlencoded"}).headers
      |> Enum.at(11)
      |> elem(1)
    end

    @doc """
    Use the MyFitnessPal session cookie to request an endpoint used on the front end
    for the users data on a graph.
    """

    def retrieve_data(macro) do
      HTTPoison.get!("http://www.myfitnesspal.com/reports/results/nutrition/#{macro}/200.json?report_name=#{macro}", %{"Cookie" => mfp_auth_session}).body
      |> Poison.decode!
    end

    @doc """
    Loop through each macro type in @macro_types and retrieve the JSON data for each.
    Initially checks to see if the data on that day is empty, if so it is skipped (we don't want to store 0 calories/carbs/fats/protein)
    If there is a value, it will parse the date associated and check the database to see if a record for that day exists already,
    if it doesn't it will create the row with the first value. If it does, it will individually update the value for each macronutrient.
    """

    def import_macros do
      @macro_types
      |> Enum.each(fn macronutrient ->
        retrieve_data(macronutrient)["data"]
        |> process_data(macronutrient)
      end)
    end

    def process_data(data, macronutrient) do
      data
      |> Enum.each(fn json ->
        if json["total"] > 0.0 do
          sanitized_value = json["total"] |> round |> to_string
          formatted_date = format_date(json)

          record = macro_exist?(formatted_date)

          new_macro = %{macronutrient: macronutrient, sanitized_value: sanitized_value, date: formatted_date}
          |> save_macro(record)
        end
      end)
    end

    def macro_exist?(date) do
      Repo.get_by(Macro, logged_date: date)
    end

    def format_date(%{"date" => date}) do
      Timex.parse!("2015/#{date}", "{YYYY}/{0M}/{0D}")
      |> Timex.format!("%d %B %Y", :strftime)
    end

    @doc """
    Used to update a pre-existing row and add in the individual macronutrient value.
    Calories will already be specified, we are only looping through carbs, fat and protein.
    """

    def save_macro(%{sanitized_value: value, macronutrient: macronutrient}, record = %Macro{}) do
      Macro.changeset(record, %{macronutrient => value})
      |> Repo.update
    end

    @doc """
    Initialise a row in the database for that specified date. At this point we have
    access only to the calories as it's the first retrieved macro from the JSON.
    """

    def save_macro(%{sanitized_value: value, date: date}, _) do
      Repo.insert(%Macro{calories: value, logged_date: date})
    end

    @doc """
    Pull Withings data from Rails API and inserts it into the database unless it already exists.
    """

    def import_weighins do
      weight_data = HTTPoison.get!(@withings_endpoint).body
      |> Poison.decode!

      Enum.each weight_data["weighins"], fn json ->
        if weight_already_exists?(json["withings_id"]) do
          Mix.shell.info "Not imported record with ID: #{json["withings_id"]}, the record already exists in the database."
        else
          Repo.insert(%Weight{withings_id: json["withings_id"], weight: json["weight"], bodyfat_mass: json["bodyfat_mass"], bodyfat_percentage: json["bodyfat_percentage"], lean_mass: json["lean_mass"], taken_at: json["taken_at"]})
        end
      end
    end

    def weight_already_exists?(w_id) do
      query = from w in Weight,
        where: w.withings_id == ^w_id
      any = Repo.all(query)
      not Enum.empty?(any)
    end
  end
end
