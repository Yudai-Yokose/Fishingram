module ApplicationHelper
  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def resource_class
    User
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def default_meta_tags
    {
      site: "Fishingram",
      title: "釣り人のための釣果記録サービス",
      reverse: true,
      charset: "utf-8",
      description: "Fishingramは手軽に釣果や位置情報などを記録することができるツール系サービスです。",
      keywords: "釣り,海,川,フィッシング",
      canonical: request.original_url,
      separator: "|",
      og: {
        site_name: "Fishingram",
        title: "釣り人のための釣果記録サービス",
        description: "Fishingramは手軽に釣果や位置情報などを記録することができるツール系サービスです。",
        type: "website",
        url: request.original_url,
        image: '/banner_2_bg.png',
        locale: "ja-JP"
      },
      twitter: {
        card: "summary_large_image",
        site: "@",
        image: '/banner_2_bg.png'
      }
    }
  end
end
