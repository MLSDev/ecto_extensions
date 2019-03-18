defmodule EctoExtensionsTest do
  use EctoExtensions.TestCase

  import EctoExtensions.Factory

  alias EctoExtensions.Repo
  alias EctoExtensions.Post

  describe "using EctoExtensions" do
    defmodule TestRepo do
      use EctoExtensions, default_page_size: 5,
                          max_page_size: 10
    end

    test "use options" do
      assert TestRepo.default_page_size() == 5
      assert TestRepo.max_page_size() == 10
    end
  end

  describe "sort(queryable, sortable, params)" do
    test "sortable settings" do
      assert [:title, :published_at] == Post.sort_fields()
      assert {:published_at, :desc} == Post.default_sort()
    end

    test "sorts entities" do
      insert(:post, title: "a post")
      insert(:post, title: "the post")
      insert(:post, title: "z post")

      posts =
        Post
        |> Repo.sort(Post, sort_by: :title, sort_order: :desc)
        |> Repo.all()

      assert [
        %Post{title: "z post"},
        %Post{title: "the post"},
        %Post{title: "a post"}
      ] = posts
    end

    test "uses defaults" do
      insert(:post, published_at: ~N[2019-03-10 09:00:30], title: "old post")
      insert(:post, published_at: ~N[2019-03-11 10:30:00], title: "post")
      insert(:post, published_at: ~N[2019-03-12 14:15:45], title: "latest post")

      posts =
        Post
        |> Repo.sort(Post)
        |> Repo.all()

      assert [
        %Post{title: "latest post"},
        %Post{title: "post"},
        %Post{title: "old post"}
      ] = posts
    end
  end

  describe "search(queryable, searchable, params)" do
    test "searchable settings" do
      assert [:title, :content] == Post.search_fields()
    end

    test "searches for entities" do
      insert(:post, title: "About Elixir", content: "Post about elixir")
      insert(:post, title: "About ruby", content: "Yukihiro Matsumoto")
      insert(:post, title: "Cool new stuff", content: "Elixir and Phoenix")

      posts =
        Post
        |> Repo.search(Post, search: "elixir")
        |> Repo.all()

      assert [
        %Post{title: "About Elixir"},
        %Post{title: "Cool new stuff"}
      ] = posts
    end
  end

  describe "paginate(queryable, params)" do
    test "paginates entries" do
      insert_list(10, :post)

      params = %{page: 1, page_size: 5}

      assert %{
        page: 1,
        page_size: 5,
        total_entries: 10,
        total_pages: 2,
        entries: posts
      } = Repo.paginate(Post, params)

      assert [%Post{} | _rest] = posts
    end

    test "defaults" do
      insert_list(10, :post)

      assert %{
        page: 1,
        page_size: 10,
        total_pages: 1
      } = Repo.paginate(Post)
    end

    test "validates params and falls back to defaults" do
      insert_list(10, :post)

      params = %{page: -1, page_size: 200}

      assert %{
        page: 1,
        page_size: 10,
        total_pages: 1
      } = Repo.paginate(Post, params)

      params = %{page: 1, page_size: 0}

      assert %{
        page: 1,
        page_size: 10,
        total_pages: 1
      } = Repo.paginate(Post, params)
    end
  end
end
