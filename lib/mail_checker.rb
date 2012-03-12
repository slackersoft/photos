class MailChecker
  def self.check_for_mail
    Mail.all(delete_after_find: true).each do |mail|
      if mail.from.first == 'gregg@greggandjen.com'
        image_attachment = find_image_attachment(mail.attachments)
        if image_attachment.present?
          photo_name = mail.subject.blank? ? image_attachment.original_filename : mail.subject
          Photo.create!(name: photo_name, image: image_attachment)
        end
      end
    end
  end

  private

  def self.find_image_attachment(attachments)
    attachments.reduce(nil) do |found, attachment|
      if found.nil? && attachment.content_type =~ /^image\//
        a = StringIO.new(attachment.body.decoded)
        a.content_type = attachment.content_type
        a.original_filename = attachment.filename
        a
      else
        found
      end
    end
  end
end
