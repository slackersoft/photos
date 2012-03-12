Mail.defaults do
  if Rails.env.test?
    retriever_method :test
  else
    retriever_method :imap,
      address: 'mail.greggandjen.com',
      user_name: 'photos@greggandjen.com',
      password: ENV['EMAIL_PASSWORD']
  end
end
