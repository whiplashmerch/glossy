# Glossy
Glossy is a CLI utility to make iterating over datasets easier. It provides methods to check that rows match your conditions, fix them when necessary, and summarize the output.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'glossy'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install glossy

## Usage

Let's assume that you've got a table called `User`, and `:full_name` should always be equal to `:first_name` + `:last_name`. Glossy will help you test your records, and if you'd like, fix them.

Subclass Glossy and declare `:check` and `:fix` instance methods:

```ruby
class FullName < Glossy

  def check(id) #return true if row is broken
    user = User.find(id)
    return user.full_name != [user.first_name, user.last_name].join(' ')
  end

  def fix(id)
    user = User.find(id)
    user.update_attribute(:full_name, [user.first_name, user.last_name].join(' '))
  end
end
```


Create an instance of glossy and reference your newly created class:
```
glossy = Glossy::Base.new(fixer: FullName)
```

You can now check for failures on ID's of your choice:

```ruby
suspect_ids = [User.where(:created_at > Time.now() - 1.day).pluck(:id)]
glossy.check_all(suspect_ids)
=> 
Tested         Passed         Failed         % Failure      
4141           3757           384            9.273      
```


You can see the ID's that failed the check method:
```ruby
glossy.failed_ids
=> [23124, 23125, 23199...]

glossy.failed_ids.size
=> 384
```

Fix the failures. If your fix was effective, they'll pass now:
```ruby
glossy.fix_all
=> 
Tested         Passed         Failed         % Failure      
384            384            0              0.000          
```

Nicely done! You're a hero and a scholar.

## Tableize

Glossy can also make an easy-to-read table from an array of hashes:
```ruby

artists = [{name: "Meg White", band: "White Stripes"}, {name: "Robert Plant", band: "Led Zepplin"}, {name: "Robert Smith", band: "The Cure"}]
print Glossy::Base.tableize(artists, column_width: 20)

name                band                
Meg White           White Stripes       
Robert Plant        Led Zepplin         
Robert Smith        The Cure            


```

## Note
Glossy disables ActiveRecord logging for your session when it starts. You can reenable it:
```ruby
Glossy::Base.enable_active_record_logging
```

## TODO
- Auto-detect table width for columns
- Tableizer support for ActiveRecord
- Benchmarking
- Animated Status Display
- Config
- Save logs to dir in configs 


## Development

Run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

