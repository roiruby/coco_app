module ApplicationHelper
    require "uri"
 
def text_url_to_link text
 
  URI.extract(text, ['http','https'] ).uniq.each do |url|
    sub_text = ""
    sub_text << "<a href=" << url << " target=\"_blank\">" << url << "</a>"
 
    text.gsub!(url, sub_text)
  end
 
  return text
end

def default_meta_tags
  {
    site: 'Cocomelo【ココメロ】',
    title: 'Cocomelo【ココメロ】┃"共通の目的"を持った人達をマッチングする新しいシェアリングサービス♪',
    reverse: true,
    separator: '|',
    description: 'ディナー・ランチ・遊び・ゲーム・スポーツ・レジャーなど様々なカテゴリから共通の趣味や目的を持った人をマッチング！簡単無料登録ですぐに始められる、新しいシェアリングサービスです！',
    keywords: 'シェアリングサービス,マッチング,ディナー,ランチ,遊び,ゲーム,スポーツ,レジャー,食事,趣味友,繋がる,SNS,学生,お茶会,ママ友',
    canonical: request.original_url,
    noindex: ! Rails.env.production?,
    icon: [
      { href: image_url('favicon.ico') },
    ],
    og: {
      site_name: :site,
      title: :title,
      description: :description,
      type: 'website',
      url: request.original_url,
      image: image_url('ogp.png'),
      locale: 'ja_JP',
    },
    twitter: {
      card: 'summary_large_image',
      site: '@Cocomelo_jp',
    }
  }
end

end
