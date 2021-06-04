crumb :root do
  link "Sharingoodトップ", root_path
end

crumb :login do
  link "ログイン", login_path
end

crumb :signup do
  link "会員登録", signup_path
end

crumb :mypage do
  link "マイページ", mypage_path
end

crumb :posts do
  link "投稿したイベント", user_posts_path
end

crumb :information do
  link "お知らせ", informations_path
end

crumb :news do |news|
  link "#{news.title}", information_path(news)
  parent :information
end

crumb :contact do
  link "お問い合わせ", contact_path
end

crumb :confirm do
  link "下書き一覧", confirm_posts_path
end

crumb :entries do
  link "エントリーしたイベント", entries_user_path
end

crumb :favorites do
  link "お気に入り", favorites_user_path
end

crumb :followings do
  link "フォロー", followings_user_path
end

crumb :followers do
  link "フォロワー", followers_user_path
end

crumb :users do
  link "ユーザー一覧", users_path
end

crumb :user do |user|
  link "#{user.name}", user_path(user)
end

crumb :category do |category|
  link "#{category.name}", category_path(category)
end

crumb :post do |post|
  link "#{post.title}", post_path(post)
  parent :category, post.category
end

crumb :entry do |post|
  link "エントリー一覧", entry_page_path(post)
  parent :post, post
end

crumb :member do |post|
  link "メンバートークルーム", member_path(post)
  parent :post, post
end

crumb :keywords do |tag|
  link "【#{params[:tag]}】のイベント一覧"
end

crumb :user_report do |user|
  link "不適切なユーザーの報告", user_report_path(user)
  parent :user, user
end

crumb :post_report do |post|
  link "不適切な投稿の報告", post_report_path(post)
  parent :post, post
end

crumb :cancel do |post|
  link "キャンセル申請", cancel_path(post)
  parent :post, post
end

crumb :contact do
  link "お問い合わせ", contact_path
end

# crumb :projects do
#   link "Projects", projects_path
# end

# crumb :project do |project|
#   link project.name, project_path(project)
#   parent :projects
# end

# crumb :project_issues do |project|
#   link "Issues", project_issues_path(project)
#   parent :project, project
# end

# crumb :issue do |issue|
#   link issue.title, issue_path(issue)
#   parent :project_issues, issue.project
# end

# If you want to split your breadcrumbs configuration over multiple files, you
# can create a folder named `config/breadcrumbs` and put your configuration
# files there. All *.rb files (e.g. `frontend.rb` or `products.rb`) in that
# folder are loaded and reloaded automatically when you change them, just like
# this file (`config/breadcrumbs.rb`).