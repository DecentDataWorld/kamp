require 'paperclip/media_type_spoof_detector'
module Paperclip

  Paperclip::Attachment.default_options[:path] = "prod_uploads/system/:class/:attachment/:id_partition/:style/:filename"
  class MediaTypeSpoofDetector
    def spoofed?
      false
    end
  end
end