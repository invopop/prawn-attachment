# frozen_string_literal: true

module Prawn
  module Attachment
    # EmbeddedFile represents a file to be embedded in the PDF.
    class EmbeddedFile
      attr_reader :checksum

      def initialize(data, options = {})
        @creation_date = options[:creation_date]
        @creation_date = Time.now.utc unless @creation_date.is_a?(Time)

        @modification_date = options[:modification_date]
        @modification_date = Time.now.utc unless @modification_date.is_a?(Time)

        @checksum = Digest::MD5.digest(data)
        @data = data
      end

      def build_pdf_object(document)
        obj = document.ref!(reference_params)
        obj << data
        obj.stream.compress! if document.compression_enabled?
        obj
      end

      private

      def reference_params
        {
          Type: :EmbeddedFile,
          Params: {
            CreationDate: creation_date,
            ModDate: modification_date,
            CheckSum: PDF::Core::LiteralString.new(checksum),
            Size: data.length
          }
        }
      end

      attr_reader :data, :creation_date, :modification_date
    end
  end
end
