# Organizing Domain Logic

This document explains how to organize domain logic within the model layer using model namespaces and concerns.

## Organizational Patterns

Use these patterns based on the nature of the logic:

| Pattern | When to Use |
|---------|-------------|
| **Direct in model** | Core attributes, simple validations, basic associations |
| **Concern** | Shared behavior across models, or extractable feature sets |
| **Namespaced class** | Complex operations, service-like logic, objects with their own state |

## Model Namespaces

Group related logic within a model's namespace at `app/models/[model_name]/`. This keeps code organized without polluting the main model file.

### Example: User Namespace

```
app/models/
  user.rb                    # Core User model
  user/
    accountable.rb           # Concern for coaching account relationships
    subscribable.rb          # Concern for subscription methods
    preferenceable.rb        # Concern for user preferences
    activation.rb            # Service class for onboarding
    deactivation.rb          # Service class for account deactivation
    null.rb                  # Null object pattern implementation
```

## Writing Concerns

Use `ActiveSupport::Concern` for extractable behavior. Include associations, callbacks, scopes, and instance methods.

### Basic Structure

```ruby
# app/models/user/subscribable.rb
module User::Subscribable
  extend ActiveSupport::Concern

  included do
    # Associations, callbacks, scopes go here
    after_save :bust_entitlements_cache, if: :saved_change_to_subscribed?
  end

  # Instance methods
  def stripe_customer?
    stripe_customer_id.present?
  end

  def active_subscription?
    return false unless subscribed?
    active_subscription.present?
  end

  private

  def bust_entitlements_cache
    Rails.cache.delete([stripe_customer_id, "entitlements"])
  end
end
```

### Including in the Model

```ruby
# app/models/user.rb
class User < ApplicationRecord
  include User::Subscribable
  include User::Accountable
  include User::Preferenceable

  # Core model code...
end
```

### Complex Associations in Concerns

```ruby
# app/models/user/accountable.rb
module User::Accountable
  extend ActiveSupport::Concern

  included do
    has_many :coaching_account_memberships,
      -> { where(organizable_type: "CoachingAccount") },
      class_name: "Membership",
      inverse_of: :user,
      dependent: :destroy

    has_many :coaching_accounts,
      through: :coaching_account_memberships,
      source: :organizable,
      source_type: "CoachingAccount"

    scope :with_eager_loaded_coaching_accounts, lambda {
      includes(:coaching_accounts, :owned_coaching_accounts)
    }
  end

  def coach?
    owned_coaching_accounts.exists? || managed_coaching_accounts.exists?
  end
end
```

## Namespaced Service Classes

Use standalone classes for operations that:
- Have their own validation logic
- Orchestrate multiple model changes
- Need to be called from controllers or jobs

### Example: Activation Service

```ruby
# app/models/user/activation.rb
class User::Activation
  include ActiveModel::Model

  attr_reader :customer

  validate :customer_must_exist
  validate :customer_must_not_be_subscribed

  def initialize(stripe_customer_id:)
    @customer = User.find_by(stripe_customer_id:)
  end

  def process
    return self unless valid?

    ActiveRecord::Base.transaction do
      customer.update!(subscribed: true)
      customer.locked_habits.update_all(status: "active")
      customer.aspirations.locked_status.update_all(status: "active")
    end

    self
  rescue ActiveRecord::RecordInvalid => error
    errors.add(:base, error.message)
    self
  end

  private

  def customer_must_exist
    errors.add(:customer, :not_found) if customer.blank?
  end

  def customer_must_not_be_subscribed
    errors.add(:customer, :already_subscribed) if customer&.subscribed?
  end
end
```

### Example: Utility Class

```ruby
# app/models/habit/check_in_eligibility.rb
class Habit::CheckInEligibility
  attr_reader :habit, :performed_at, :last_performed_at

  def initialize(habit:, performed_at:, last_performed_at:)
    @habit = habit
    @performed_at = performed_at
    @last_performed_at = last_performed_at
  end

  def eligible?
    return false if performed_at.blank?
    return false if performed_at <= last_performed_at

    period_start(performed_at) > period_start(last_performed_at)
  end

  private

  def period_start(date)
    return nil if date.blank?

    case habit.frequency
    when "daily" then date.beginning_of_day
    when "weekly" then date.beginning_of_week
    when "monthly" then date.beginning_of_month
    end
  end
end
```

## Decision Guide

1. **Does this behavior apply to multiple models?**
   - Yes: Create a shared concern in `app/models/concerns/`
   - No: Continue to step 2

2. **Is this a cohesive feature set (associations + methods)?**
   - Yes: Create a namespaced concern under the model
   - No: Continue to step 3

3. **Does this operation need its own validation/state?**
   - Yes: Create a namespaced class using `ActiveModel::Model`
   - No: Keep it as methods in the model or a simple utility class

4. **Is the model file getting too long (>200 lines)?**
   - Yes: Extract related methods into a concern
   - No: Keep methods in the model
