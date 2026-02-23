# Ensuring Data Quality

This document covers best practices for validating data in the model layer.

## Validation Basics

Validations run before `save`, `create`, and `update` operations. They prevent invalid data from reaching the database.

```ruby
class Habit < ApplicationRecord
  validates :action, length: {minimum: 3, maximum: 75}
  validates :frequency, inclusion: {in: CHECK_IN_FREQUENCIES.values}
end
```

## Common Validators

### presence

Ensures the attribute is not nil or blank.

```ruby
validates :email, presence: true
validates :life_area, presence: true
```

### length

Constrains string length.

```ruby
validates :action, length: {minimum: 3, maximum: 75}
validates :identity, length: {minimum: 3, maximum: 45}
validates :username, length: {maximum: 25}
```

### uniqueness

Ensures the value is unique in the database.

```ruby
validates :email, uniqueness: true
validates :username, uniqueness: true
```

### inclusion

Validates value is within a specific set.

```ruby
STATUSES = {active: "active", archived: "archived", locked: "locked"}.freeze

validates :status, inclusion: {in: STATUSES.values}
validates :frequency, inclusion: {in: CHECK_IN_FREQUENCIES.values}
```

### numericality

Validates numeric values.

```ruby
validates :periods_active, numericality: {greater_than_or_equal_to: 0}
validates :value, numericality: {only_integer: true, greater_than: 0}
```

### format

Validates against a regular expression.

```ruby
validates :email, format: {with: URI::MailTo::EMAIL_REGEXP}
```

### comparison

Validates by comparing to another value or method result.

```ruby
validates :performed_at,
  presence: true,
  comparison: {
    less_than_or_equal_to: -> { Time.zone.now },
    message: lambda { |_object, data|
      return "must be on or before today" if data[:value].blank?
      "must be on or before #{I18n.l(data[:value].to_date, format: :mm_dd_yyyy)}"
    }
  }
```

## Enum Validations

When using enums, validate against the constant hash:

```ruby
class Habit < ApplicationRecord
  CHECK_IN_FREQUENCIES = {
    daily: "daily",
    weekly: "weekly",
    monthly: "monthly"
  }.freeze

  enum :frequency, CHECK_IN_FREQUENCIES, suffix: true
  validates :frequency, inclusion: {in: CHECK_IN_FREQUENCIES.values}
end
```

**Pattern:** Define the constants hash before the enum declaration, then validate against the hash values.

## Custom Validations

### Custom Validator Methods

```ruby
class User::Activation
  include ActiveModel::Model

  validate :customer_must_exist
  validate :customer_must_not_be_subscribed

  private

  def customer_must_exist
    errors.add(:customer, :not_found) if customer.blank?
  end

  def customer_must_not_be_subscribed
    errors.add(:customer, :already_subscribed) if customer&.subscribed?
  end
end
```

### Using Error Symbols

Use symbols for error types to enable I18n translation:

```ruby
errors.add(:customer, :not_found)
errors.add(:customer, :already_subscribed)
errors.add(:base, :invalid_state)
```

## Conditional Validations

### Using :if and :unless

```ruby
validates :stripe_customer_id, presence: true, if: :subscribed?
validates :bio, length: {maximum: 500}, unless: :admin?
```

### Using Procs

```ruby
validates :performed_at,
  comparison: {less_than_or_equal_to: -> { Time.zone.now }}
```

## Validation Options

### allow_blank and allow_nil

```ruby
validates :username, allow_blank: false, uniqueness: true
validates :middle_name, length: {maximum: 50}, allow_nil: true
```

### Custom Messages

```ruby
validates :action, length: {
  minimum: 3,
  maximum: 75,
  too_short: "must have at least %{count} characters",
  too_long: "must have at most %{count} characters"
}
```

### on: :create or :update

```ruby
validates :password, presence: true, on: :create
validates :current_password, presence: true, on: :update
```

## Validating Associated Objects

```ruby
class User < ApplicationRecord
  has_one :profile, dependent: :destroy
  accepts_nested_attributes_for :profile
  validates_associated :profile
end
```

## Methods That Skip Validations

These methods bypass validations - use with caution:

- `update_column` / `update_columns`
- `update_all`
- `insert` / `insert_all`
- `upsert` / `upsert_all`
- `touch`
- `save(validate: false)`

## Database Constraints vs Validations

Use both for critical data integrity:

| Layer | Purpose | Example |
|-------|---------|---------|
| **Validation** | User-friendly errors, business logic | `validates :email, presence: true` |
| **Database** | Last line of defense, data integrity | `null: false` in migration |

```ruby
# Migration
add_column :users, :email, :string, null: false

# Model
validates :email, presence: true
```

## Best Practices

1. **Validate at the model layer** - Don't rely solely on database constraints
2. **Use database constraints too** - For critical fields, add NOT NULL and foreign keys
3. **Keep validations simple** - Complex business rules belong in service objects
4. **Use symbols for error types** - Enables I18n and easier testing
5. **Validate enums against their constant hash** - Ensures consistency
6. **Test validation errors explicitly** - Check both valid and invalid states
