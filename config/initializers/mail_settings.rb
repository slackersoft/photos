Mail.defaults do
  if Rails.env.test?
    retriever_method :test
  else
    retriever_method :pop3,
      address: 'mail.greggandjen.com',
      user_name: 'photos@greggandjen.com',
      password: ENV['EMAIL_PASSWORD']
  end
end
