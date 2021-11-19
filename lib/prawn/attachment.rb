# frozen_string_literal: true

require "prawn"
require_relative "../pdf/core/embedded_files"

require_relative "attachment/version"
require_relative "attachment/embedded_file"
require_relative "attachment/filespec"

module Prawn
  module Attachment
    include PDF::Core::EmbeddedFiles

    class Error < StandardError; end

    # Attach a file's data to the document. Any kind of data with
    # a string representation can be embedded.
    #
    # Arguments:
    # <tt>src</tt>:: path to file, data string, or an object that responds to #to_str
    # and #length.
    #
    # Options:
    # <tt>:name</tt>:: explicit default filename override.
    # <tt>:creation_date</tt>:: date when the file was created.
    # <tt>:modification_date</tt>::  date when the file was last modified.
    # <tt>:description</tt>:: file description.
    # <tt>:hidden</tt>:: if true, prevents the file from appearing in the
    # catalog. (default false)
    #
    #   Prawn::Document.generate("file1.pdf") do
    #     path = "#{Prawn::DATADIR}/images/dice.png"
    #     attach path, description: 'Example of an attached image file'
    #   end
    #
    # This method returns an instance of PDF::Core::NameTree::Value
    # corresponding to the file in the attached files catalog entry node. If
    # hidden, then nil is returned.
    #
    def attach(src, opts = {})
      path = Pathname.new(src)
      opts = options.dup

      raise ArgumentError, 'Data source can\'t be a directory' if path.directory?
      
      # Determine what sort of source we're dealing with
      if path.file?
        data = path.read
        opts = {
          name: path.basename,
          creation_date: path.birthtime,
          modification_date: path.mtime
        }.merge(opts)
      else
        data = src
      end

      file = EmbeddedFile.new(data, opts)
      file_obj = file_registry[file.checksum]

      if file_obj.nil?
        file_obj = file.build_pdf_object(self)
        file_registry[file.checksum] = file_obj
      end

      filespec = Filespec.new(file_obj, opts)
      filespec_obj = filespec.build_pdf_object(self)

      unless filespec.hidden?
        attach_file(filespec.file_name, filespec_obj)
      end
    end

    private

    def file_registry
      @file_registry ||= {}
    end

  end

end

# Add ourselves to prawn
Prawn::Document.send :include, Prawn::Attachment
