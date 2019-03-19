defmodule EctoExtensions.PageableTest do
  use EctoExtensions.TestCase

  alias EctoExtensions.Repo
  alias EctoExtensions.Post
  alias EctoExtensions.{Pageable, Page}

  describe "paginate(queryable, repo, params)" do
    test "returns map" do
      page =
        Post
        |> Pageable.paginate(Repo, %{})

      assert %Page{} = page
    end
  end

  describe "apply_params(repo, params)" do
    test "casts params" do
      params = %{"page" => "2", "page_size" => "25"}

      assert %{
        page: 2,
        page_size: 25
      } = Pageable.apply_params(Repo, params)
    end

    test "accepts map with atoms as params" do
      params = %{page: 2, page_size: 25}

      assert %{
        page: 2,
        page_size: 25
      } = Pageable.apply_params(Repo, params)
    end

    test "accepts keyword list with atoms as params" do
      params = [page: 2, page_size: 25]

      assert %{
        page: 2,
        page_size: 25
      } = Pageable.apply_params(Repo, params)
    end
  end
end
