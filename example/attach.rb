require "prawn"
require "prawn/attachment"

Prawn::Document.generate("hello.pdf") do
  text "Hello World!"
  attach "./data.json"
end