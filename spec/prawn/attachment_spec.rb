# frozen_string_literal: true

require "tempfile"

RSpec.describe Prawn::Attachment do
  it "has a version number" do
    expect(Prawn::Attachment::VERSION).not_to be nil
  end

  it "attaches an IO object" do
    expect do
      Prawn::Document.generate("hello.pdf") do
        text "Hello Spec!"
        attach "data.json", File.open("./example/data.json")
      end
    end.not_to raise_error
  end

  it "attaches a temp file" do
    expect do
      Tempfile.create do |f|
        f << File.read("./example/data.json")
        f.rewind
        Prawn::Document.generate("hello.pdf") do
          text "Hello Spec!"
          attach "data.json", f
        end
      end.not_to raise_error
    end
  end

  it "attaches a string" do
    expect do
      Prawn::Document.generate("hello.pdf") do
        text "Hello Spec!"
        attach "data.json", File.read("./example/data.json")
      end
    end.not_to raise_error
  end

  it "failes with junk" do
    expect do
      Prawn::Document.generate("hello.pdf") do
        text "Hello Spec!"
        attach "data.json", Object.new
      end
    end.to raise_error(Prawn::Attachment::InvalidDataError)
  end
end
