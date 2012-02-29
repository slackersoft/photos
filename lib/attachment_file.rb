class AttachmentFile < StringIO
  attr_accessor :original_filename, :content_type
end
