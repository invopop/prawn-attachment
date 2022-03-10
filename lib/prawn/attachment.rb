# frozen_string_literal: true

require "prawn"
require_relative "../pdf/core/embedded_files"

require_relative "attachment/version"
require_relative "attachment/embedded_file"
require_relative "attachment/filespec"

module Prawn
  # Module that supports attachment of file data into a Prawn::Document
  module Attachment
    include PDF::Core::EmbeddedFiles

    # Missing data error
    class NoDataError < StandardError
      def message
        "Source data is empty"
      end
    end

    # Invalid data provided
    class InvalidDataError < StandardError
      def message
        "Source data must be an IO object or string"
      end
    end

    # Attach a file's data to the document. File IO Objects are expected.
    #
    # Arguments:
    # <tt>name</tt>:: name of attachment.
    # <tt>src</tt>:: String or IO object containing source file data.
    #
    # Options:
    # <tt>:created_at</tt>:: timestamp when the file was created.
    # <tt>:modified_at</tt>::  timestamp for when file was last modified.
    # <tt>:description</tt>:: file description.
    # <tt>:hidden</tt>:: if true, prevents the file from appearing in the
    # catalog. (default false)
    #
    #   Prawn::Document.generate("file1.pdf") do
    #     path = "#{Prawn::DATADIR}/images/dice.png"
    #     attach "dice.png", File.open(path), description: 'Example of an attached image file'
    #   end
    #
    # This method returns an instance of PDF::Core::NameTree::Value
    # corresponding to the file in the attached files catalog entry node. If
    # hidden, then nil is returned.
    #
    def attach(name, src, opts = {})
      data = extract_data_from_source(src)
      opts = prepare_options(name, opts)

      # Prepare embeddable representation of the source data
      file = EmbeddedFile.new(data, opts)

      filespec = Filespec.new(file_obj_from_registry(file), opts)
      filespec_obj = filespec.build_pdf_object(self)

      attach_file(filespec.file_name, filespec_obj) unless filespec.hidden?
    end

    private

    def extract_data_from_source(src)
      if src.respond_to?(:read)
        data = src.read
      elsif src.respond_to?(:b)
        data = src.b
      else
        raise InvalidDataError
      end
      raise NoDataError if data.length.zero?

      data
    end

    def prepare_options(name, opts)
      {
        name: name,
        creation_date: opts[:created_at] || Time.now.utc,
        modification_date: opts[:modified_at] || Time.now.utc,
        description: opts[:description],
        hidden: !!opts[:hidden]
      }
    end

    # attempt to find a previously stored version of the embedded file in the
    # registry, just in case the same file is attached twice with different names.
    def file_obj_from_registry(file)
      file_obj = file_registry[file.checksum]
      return file_obj if file_obj

      file_obj = file.build_pdf_object(self)
      file_registry[file.checksum] = file_obj
      file_obj
    end

    def file_registry
      @file_registry ||= {}
    end
  end
end

# Add ourselves to prawn
Prawn::Document.include Prawn::Attachment
