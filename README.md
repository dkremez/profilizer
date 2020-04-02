# Profilizer

Profilizer is a Ruby gem for easy profile of methods. It helps you to track how fast you methods are, how much memory the consume and how much objects were allocated. 

The normal hand on profiling in Ruby doesn't require any gems and looks like this:

```ruby
def profile
  start = Time.now
  yield if block_given?
  end = Time.now
  puts "Duration: #{end - start}"
end
```

However, it is not handy in case you want more options of you just need to repeat this code many time in different application.

Here is what is gem propose instead:

```ruby
class A
  include Profilizer

  profilize def foo
    a = 1
    b = 2
    c = a + b
  end
end

A.new.foo 
```

It will output in STDOUT something like:

```
Objects Freed: 39
Time: 0.02 seconds
Memory usage: 2.05 MB
```


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'profilizer'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install profilizer

## Usage

### Basic usage

```ruby
class A
  include Profilizer

  profilize def foo
    a = 1
    b = 2
    c = a + b
  end
end

A.new.foo 
```

It prints in STDOUT something like:

```
Objects Freed: 39
Time: 0.02 seconds
Memory usage: 2.05 MB
```

### Configuration

What if you only want to profile time or just used memory or objects allocations only.
Here is how you could config

```ruby
class A
  include Profilizer

  def foo
    a = 1
    b = 2
    c = a + b
  end

  profilize :foo, time: true, memory: false, gc: false
end

A.new.foo 
```

It prints:

```
Time: 0.02 seconds
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dkremez/profilizer.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
