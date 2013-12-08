enum_type
=========

**Enumerated Types in ActiveRecord**

|             |                                 |
|:------------|:--------------------------------|
| **Author**  | Tim Morgan                      |
| **Version** | 2.1.2 (Nov 10, 2013)            |
| **License** | Released under the MIT license. |

About
-----

`enum_type` allows you to effectively use the PostgreSQL `ENUM` data type in
your ActiveRecord models. It's a really simple gem that just adds a convenience
method to take care of the usual "witch chant" that accompanies building an
enumerated type in Rails.

Installation
------------

**Important Note:** This gem requires Ruby 1.9+. Ruby 1.8 is not supported, and
will never be.

First, add the `enum_type` gem to your `Gemfile`:

```` ruby
gem 'enum_type'
````

Then, extend your model with the `EnumType` module:

```` ruby
class MyModel < ActiveRecord::Base
  extend EnumType
end
````

Usage
-----

In your model, call the `enum_type` method, providing one or more enumerated
fields, and any additional options:

```` ruby
class MyModel < ActiveRecord::Base
  extend EnumType
  enum_type :status, %w( active pending admin superadmin banned )
end
````

See the {EnumType#enum_type} method documentation for more information.
