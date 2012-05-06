class MailChecker
  class << self
    def check_for_mail
      message_count = 0
      Mail.all(delete_after_find: Rails.env.production? || Rails.env.test?).each do |mail|
        message_count += 1
        log("Got message with subject: '#{mail.subject}' from:#{mail.from.first} with message_id: #{mail.message_id}")

        if valid_sender?(mail) && Photo.where(original_message_id: mail.message_id).count == 0
          image_attachment = find_image_attachment(mail.attachments)

          if image_attachment.present?
            photo_name = mail.subject.blank? ? image_attachment.original_filename : mail.subject
            description = extract_description mail.text_part.try(:body).to_s

            log("Found attachment, creating photo #{photo_name}")
            Photo.create!(name: photo_name, description: description, image: image_attachment, original_message_id: mail.message_id)
          end
        end
      end

      log("Processed #{message_count} message#{message_count == 1 ? '' : 's'}")
    end

    def log(message)
      puts message
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

    def extract_description(text_body)
      return nil unless text_body.is_a?(String)

      text_body.gsub(/^\s*--(-------- Forwarded message ----------)?\s*$.*\z/m, '').strip
    end
  end
end
