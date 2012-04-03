default_options = {
  convert_options: { all: '-auto-orient' },
  styles: {
    original: '',
    thumb: '100x100>',
    large: '500x500>'
  }
}

default_s3_options = {
  storage: :s3,
  s3_credentials: {
    access_key_id: ENV['S3_KEY'],
    secret_access_key: ENV['S3_SECRET']
  },
  s3_permissions: 'public-read',
  s3_protocol: 'https'
}

env_options = if Rails.env.production?
  default_s3_options.merge({
    bucket: "gnj-photos-prod"
  })
#elsif Rails.env.development?
#  default_s3_options.merge({
#    bucket: "gnj-photos-dev",
#  })
else
  {
    url: "/system/:attachment/:id/:style.:extension"
  }
end

PAPERCLIP_OPTIONS = default_options.merge(env_options)
