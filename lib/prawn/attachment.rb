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

    class Error < StandardError; end

    # Attach a file's data to the document. Any kind of data with
    # a string representation can be embedded.
    #
    # Arguments:
    # <tt>name</tt>:: name of attached file.
    # <tt>data</tt>:: data string, or an object that responds to #to_str and
    # #length.
    #
    # Options:
    # <tt>:creation_date</tt>:: date when the file was created.
    # <tt>:modification_date</tt>::  date when the file was last modified.
    # <tt>:description</tt>:: file description.
    # <tt>:hidden</tt>:: if true, prevents the file from appearing in the
    # catalog. (default false)
    #
    #   Prawn::Document.generate("file1.pdf") do
    #     path = "#{Prawn::DATADIR}/images/dice.png"
    #     attach name, data, description: 'Example of an attached image file'
    #   end
    #
    # This method returns an instance of PDF::Core::NameTree::Value
    # corresponding to the file in the attached files catalog entry node. If
    # hidden, then nil is returned.
    #
    def attach(name, data, options = {})
      opts = options.merge(name: name)
      opts[:creation_date] ||= Time.now

      file = EmbeddedFile.new(data, opts)

      filespec = Filespec.new(file_obj_from_registry(file), opts)
      filespec_obj = filespec.build_pdf_object(self)

      attach_file(filespec.file_name, filespec_obj) unless filespec.hidden?
    end

    private

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
