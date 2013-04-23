# DateParams

Dates passed in by date-pickers or text-input fields need to be
converted from their string format to a ruby Date to be able to be saved
and manipulated. This gem provides a simple controller add-on to
facilitate the conversion.

## Installation

Add this line to your application's Gemfile:

    gem 'date_params'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install date_params

## Usage

Include the controller additions in the controller that needs to parse
date parameters and then specify dates to be formatted:
```ruby
class UsersController < ApplicationController
  # e.g. parameters come in as: { sign_up_on: '01/05/2013' }
  include DateParams::ControllerAdditions
  date_params :sign_up_on
  # and now params[:sign_up_on] is a Date object
end
```

Any options that a `before_filter` accepts can be passed in:
```ruby
include DateParams::ControllerAdditions
date_params :sign_up_on, only: [:index]
```

If date fields are namespaced in a model that can be specified with the
`namespace` option:
```ruby
# will parse parameters in the format of: { user: { searched_on: '01/04/2013', sign_up_on: '04/03/2013' } }
include DateParams::ControllerAdditions
date_params :searched_on, :sign_up_on, namespace: :user
```

Or specify a namespace for each parameter individually:
```ruby
include DateParams::ControllerAdditions
date_params [:user, :searched_on], [:company, :sign_up_on]
```

Date format can be passed as an option (default is `%m/%d/%Y`):
```ruby
include DateParams::ControllerAdditions
date_params :search_on, :sign_up_on, date_format: '%d-%m-%Y'
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
