# frozen_string_literal: true

require "prawn"
require_relative "../lib/prawn/attachment"

Prawn::Document.generate("hello.pdf") do
  text "Hello World!"
  attach "data.json", File.open("./data.json")
end
