# Prawn::Attachment

Attach files to Prawn PDF documents according to the PDF/A-3 standard.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'prawn-attachment'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install prawn-attachment

## Usage

Simply require the gem and attach your files the PDF document you're building with Prawn.

```ruby
require "prawn"
require "prawn/attachment"

Prawn::Document.generate("hello.pdf") do
  text "Hello World!"
  attach "./data.json"
end
```

If you open up the PDF in a view that supports PDF/A-3, like the standard [Adobe Acrobat Reader](https://get.adobe.com/reader/) you should be able to see the attached data in the "attachments" section.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/invopop/prawn-attachment. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/invopop/prawn-attachment/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Prawn::Attachment project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/invopop/prawn-attachment/blob/master/CODE_OF_CONDUCT.md).
