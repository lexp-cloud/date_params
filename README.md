# DateParams

Dates and times passed in as strings date-pickers or time-pickers need to be
converted from their string format to a ruby Date or DateTime to be able to be saved
and manipulated. This gem provides two simple controller add-ons to
facilitate the conversion.

## Installation

Rails 3.x and Ruby 1.9.3 or 2.x required.

Add this line to your application's Gemfile:

    gem 'date_params'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install date_params

## Usage

### date_params

Specify the dates to be parsed:
```ruby
class UsersController < ApplicationController
  # e.g. parameters come in as: { sign_up_on: '01/05/2013' }
  date_params :sign_up_on
  # and now params[:sign_up_on] is a Date object
end
```

Any options that a `before_filter` accepts can be passed in:
```ruby
date_params :sign_up_on, only: [:index]
```

If date fields are namespaced in a model that can be specified with the
`namespace` option:
```ruby
# will parse parameters in the format of: { user: { searched_on: '01/04/2013', sign_up_on: '04/03/2013' } }
date_params :searched_on, :sign_up_on, namespace: :user
```

Date format can be passed as an option (default is `%m/%d/%Y`):
```ruby
date_params :search_on, :sign_up_on, date_format: '%d-%m-%Y'
```

### datetime_params

Specify the datetime fields that need to be parsed:
```ruby
class UsersController < ApplicationController
  # e.g. parameters come in as: { sign_up_on: '01/05/2013', sign_up_time: '7:30 pm' }
  datetime_params :sign_up_at
  # and now params[:sign_up_at] is a timezone-aware DateTime object
end
```

In addition to the `:namespace` and `:date_format` options, the time format can be specified
(default is `%I:%M %p`):
```ruby
date_params :sign_up_at, time_format: '%H:%M:%S'
```

To specify exactly which fields should be parsed:
```ruby
date_params { date: :sign_up_on, time: :sign_up_time, field: :sign_up_at }, only: :create
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
