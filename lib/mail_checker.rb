class MailChecker
  class << self
    def check_for_mail
      message_count = 0
      Mail.all(delete_after_find: Rails.env.production? || Rails.env.test?).each do |mail|
        message_count += 1
        log("Got message with subject: '#{mail.subject}' from:#{mail.from.first} with message_id: #{mail.message_id}")
        sender = find_sender(mail)

        if sender.present? && Photo.where(original_message_id: mail.message_id).count == 0
          image_attachment = find_image_attachment(mail.attachments)

          if image_attachment.present?
            from_subject = extract_name_and_tags(image_attachment, mail)
            photo_name = from_subject[:name]
            description = extract_description mail.text_part.try(:body).to_s

            log("Found attachment, creating photo #{photo_name}")
            pic = Photo.create!(name: photo_name, description: description, image: image_attachment, original_message_id: mail.message_id, user: sender)

            from_subject[:tags].each do |tag|
              pic.add_tag(tag)
            end
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
          a = AttachmentFile.new(attachment.body.decoded)
          a.content_type = attachment.content_type
          a.original_filename = attachment.filename
          a
        else
          found
        end
      end
    end

    def find_sender(mail)
      User.authorized.with_email mail.from.first
    end

    def extract_description(text_body)
      return nil unless text_body.is_a?(String)

      text_body.gsub(/^\s*--(-------- Forwarded message ----------)?\s*$.*\z/m, '').strip
    end

    def extract_name_and_tags(image_attachment, mail)
      if mail.subject.blank?
        return { name: image_attachment.original_filename, tags: [] }
      end

      name = mail.subject
      name.gsub!(/^fwd:\s*/i, '')

      tags = []
      leading_tags = /\G\s*\[[^\]]+\]/
      trailing_tags = /\[[^\]]+\](\s*|\[[^\]]+\])*$/
      remove_brackets = /^\[|\]$/

      name.gsub!(leading_tags) do |tag|
        tags << tag.strip.gsub(remove_brackets, '')
        ''
      end
      name.gsub!(trailing_tags) do |ending_tags|
        ending_tags.gsub(leading_tags) do |tag|
          tags << tag.strip.gsub(remove_brackets, '')
        end
        ''
      end

      { :name => name.strip, :tags => tags }
    end
  end
end
