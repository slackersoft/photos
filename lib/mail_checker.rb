class MailChecker
  class << self
    def check_for_mail
      Mail.all(delete_after_find: Rails.env.production? || Rails.env.test?).each do |mail|
        if valid_sender?(mail) && Photo.where(original_message_id: mail.message_id).count == 0
          image_attachment = find_image_attachment(mail.attachments)
          if image_attachment.present?
            photo_name = mail.subject.blank? ? image_attachment.original_filename : mail.subject
            Photo.create!(name: photo_name, image: image_attachment, original_message_id: mail.message_id)
          end
        end
      end
    end

    private

    def find_image_attachment(attachments)
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

    def valid_sender?(mail)
      %w(gregg@greggandjen.com jen@greggandjen.com).include? mail.from.first
    end
  end
end
