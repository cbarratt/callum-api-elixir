defmodule Mix.Tasks.Api do
  defmodule Pulldata do
    import Ecto.Query

    use Mix.Task
    use Timex

    alias Callumapi.Repo
    alias Callumapi.Weight
    alias Callumapi.Macro

    @myfitnesspal_endpoint "https://www.myfitnesspal.com/account/login"
    @withings_endpoint     "http://callumbarratt.herokuapp.com/api/v1/weighins"

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
      HTTPoison.get!("http://www.myfitnesspal.com/reports/results/nutrition/#{macro}/400.json?report_name=#{macro}", %{"Cookie" => mfp_auth_session}).body
      |> Poison.decode!
    end

    def import_macros do
      ["calories", "carbs", "fat", "protein"]
      |> Enum.each fn macronutrient ->
        retrieve_data(macronutrient)["data"]
        |> Enum.each fn json ->
          if json["total"] > 0.0 do
            sanitized_value = json["total"] |> round |> to_string

            date = DateFormat.parse!("2015/#{json["date"]}", "{YYYY}/{0M}/{0D}") |> DateFormat.format!("%d %B %Y", :strftime)

            case Repo.get_by(Macro, logged_date: date) do
            record = %Macro{} ->
              update_macro(macronutrient, record, sanitized_value)
            _ ->
              create_macro(sanitized_value, date)
            end
          end
        end
      end
    end

    @doc """
    Initialise a row in the database for that specified date. At this point we have
    access only to the calories as it's the first retrieved macro from the JSON.
    """

    def create_macro(value, date) do
      Repo.insert(%Macro{calories: value, logged_date: date})
    end

    @doc """
    Used to update a pre-existing row and add in the individual macronutrient value.
    Calories will already be specified, we are only looping through carbs, fat and protein.
    """

    def update_macro(macronutrient, record, value) do
      macronutrient = macronutrient |> String.to_atom

      changed = Map.put(%{}, macronutrient, value)

      Macro.changeset(record, changed)
      |> Repo.update
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
