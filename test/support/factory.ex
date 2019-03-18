defmodule EctoExtensions.Factory do
  @moduledoc false

  use ExMachina.Ecto, repo: EctoExtensions.Repo


  def post_factory do
    %EctoExtensions.Post{
      title: sequence(:room, &"Title #{&1}"),
      content: "Post content"
    }
  end
end
