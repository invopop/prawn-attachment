# frozen_string_literal: true

RSpec.describe Prawn::Attachment do
  it "has a version number" do
    expect(Prawn::Attachment::VERSION).not_to be nil
  end

  it "does something useful without failing" do
    expect do
      Prawn::Document.generate("hello.pdf") do
        text "Hello Spec!"
        attach "./example/data.json"
      end
    end.not_to raise_error
  end
end