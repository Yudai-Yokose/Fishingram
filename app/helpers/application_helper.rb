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
      description: "釣れた時の状況や魚の画像を簡単に記録に残せるツール系サービスです。",
      keywords: "釣り,海,川,フィッシング",
      canonical: request.original_url,
      separator: "|",
      og: {
        site_name: :site,
        title: :title,
        description: :description,
        type: "website",
        url: request.original_url,
        image: "/banner_3_bg.png",
        locale: "ja-JP"
      },
      twitter: {
        card: "summary_large_image",
        site: "@",
        image: "/banner_3_bg.png"
      }
    }
  end
end
