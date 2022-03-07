# frozen_string_literal: true

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

  it "attaches a string" do
    expect do
      Prawn::Document.generate("hello.pdf") do
        text "Hello Spec!"
        attach "data.json", File.read("./example/data.json")
      end
    end.not_to raise_error
  end
end
