defmodule Mix.Tasks.Api do
  defmodule Pulldata do
    import Ecto.Query

    require IEx

    use Mix.Task
    use Timex

    alias Callumapi.Repo
    alias Callumapi.Weight
    alias Callumapi.Macro

    @shortdoc "Import Macronutrient & Withings data from Rails API"

    @moduledoc """
    Import data from Rails API.
    """

    def run(_) do
      Mix.Task.run "app.start", []

      import_macros
      # import_weight_data
    end

    def mfp_auth_session do
      auth = HTTPoison.post!("https://www.myfitnesspal.com/account/login", {:form, [username: System.get_env("MFP_USER"), password: System.get_env("MFP_PASS")]}, %{"Content-type" => "application/x-www-form-urlencoded"}).headers
      Enum.at(auth, 11)
      |> elem(1)
    end

    def retrieve_data(macro) do
      HTTPoison.get!("http://www.myfitnesspal.com/reports/results/nutrition/#{macro}/400.json?report_name=#{macro}", %{"Cookie" => mfp_auth_session}).body
      |> Poison.decode!
    end

    def import_macros do
      macros = ["calories", "carbs", "fat", "protein"]

      Enum.each macros, fn macronutrient ->
        mfp_data = retrieve_data(macronutrient)

        Enum.each mfp_data["data"], fn json ->
          recording = json["total"]
          sanitized_value = Float.to_string(recording, [decimals: 0])

          if recording > 0.0 do
            date = DateFormat.parse!("2015/#{json["date"]}", "{YYYY}/{0M}/{0D}") |> DateFormat.format!("%d %B %Y", :strftime)

            case Repo.get_by(Macro, logged_date: date) do
            record = %Macro{} ->
              if macronutrient == "calories", do: update_calories(record, sanitized_value)
              if macronutrient == "carbs", do: update_carbs(record, sanitized_value)
              if macronutrient == "fat", do: update_fat(record, sanitized_value)
              if macronutrient == "protein", do: update_protein(record, sanitized_value)
            _ ->
              create_macro(sanitized_value, date)
            end
          end
        end
      end
    end

    def create_macro(value, date) do
      Repo.insert(%Macro{calories: value, logged_date: date})
    end

    def update_calories(record, value) do
      macro = %{record | calories: value}
      Repo.update(macro)
    end

    def update_carbs(record, value) do
      macro = %{record | carbs: value}
      Repo.update(macro)
    end

    def update_fat(record, value) do
      macro = %{record | fat: value}
      Repo.update(macro)
    end

    def update_protein(record, value) do
      macro = %{record | protein: value}
      Repo.update(macro)
    end

    def import_weight_data do
      weight_data = HTTPoison.get!("http://callumbarratt.co.uk/api/v1/weighins").body
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
