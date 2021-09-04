SitemapGenerator::Sitemap.default_host = "https://cocomelo.jp/"

SitemapGenerator::Sitemap.create do
  add root_path
  add new_arrival_path
  add deadline_approaching_path
  add posts_path
  posts = Post.published
  posts.each do |post|
    add post_path(post), :lastmod => post.updated_at
  end
end
