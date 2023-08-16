require 'paperclip/io_adapters/uri_adapter'
module Paperclip
  Paperclip::Attachment.default_options[:path] = "prod_uploads/system/:class/:attachment/:id_partition/:style/:filename"
  class UriAdapter < AbstractAdapter

    def content_type_from_content
      content_type = @content.meta["content-type"]
      return nil if content_type.blank?

      content_type.split(/[:;\s]+/).first
    end

  end
end