PAPERCLIP_STORAGE_OPTIONS = if Rails.env.production?
   {
    :storage => :s3,
    :bucket => "gnj-photos",
    :s3_credentials => {
      :access_key_id => ENV['S3_KEY'],
      :secret_access_key => ENV['S3_SECRET']
    }
  }
#elsif Rails.env.development?
#  {
#    :storage => :s3,
#    :bucket => "gnj-photos-dev",
#    :s3_credentials => {
#      :access_key_id => ENV['S3_KEY'],
#      :secret_access_key => ENV['S3_SECRET']
#    }
#  }
else
  {
    :url => "/system/:attachment/:id/:style.:extension"
  }
end
