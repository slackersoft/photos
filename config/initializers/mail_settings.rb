Mail.defaults do
  if Rails.env.test?
    retriever_method :pop3,
      address: 'mail.example.com',
      user_name: 'username',
      password: 'password'
  else
    retriever_method :pop3,
      address: 'mail.greggandjen.com',
      username: 'photos@greggandjen.com',
      password: ENV['EMAIL_PASSWORD']
  end
end
