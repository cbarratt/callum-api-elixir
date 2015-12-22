defmodule Callumapi.BitcoinController do
  use Callumapi.Web, :controller

  def index(conn, _params) do
    data = Task.async(fn -> grab_balance end)

    render(conn, balance: Task.await(data))
  end

  def grab_balance do
    password = System.get_env("BLOCK_PASS")

    HTTPoison.get!("https://blockchain.info/merchant/2f4e54fe-e4ad-b0de-205a-93492b9ccf7d/address_balance?password=#{password}&address=1M5ahj4ZX6YqYC7BBpni8Kwio949J1invd").body
    |> Poison.decode!
    |> convert
  end

  defp convert(data), do: "0.#{data["balance"]}"
end
