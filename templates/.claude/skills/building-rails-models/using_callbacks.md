# Using Callbacks

This document covers how to properly use Active Record callbacks. **Use callbacks judiciously** - they can make code harder to understand and test when overused.

## Callback Lifecycle

### Creating a Record
```
before_validation -> after_validation -> before_save -> around_save ->
before_create -> around_create -> after_create -> after_save ->
after_commit / after_rollback
```

### Updating a Record
```
before_validation -> after_validation -> before_save -> around_save ->
before_update -> around_update -> after_update -> after_save ->
after_commit / after_rollback
```

### Destroying a Record
```
before_destroy -> around_destroy -> after_destroy ->
after_commit / after_rollback
```

## Common Callback Patterns

### Setting Defaults Before Validation

```ruby
class User < ApplicationRecord
  before_validation :set_default_username

  private

  def set_default_username
    return if persisted?
    self.username = generate_username
  end
end
```

### Creating Associated Records After Create

```ruby
class User < ApplicationRecord
  after_create :create_vision_board

  private

  def create_vision_board
    VisionBoard.create!(user: self)
  end
end
```

### Conditional Callbacks

```ruby
class User < ApplicationRecord
  after_save :send_welcome_email, if: -> { saved_change_to_confirmed_at? && confirmed_at.present? }
  after_save :bust_entitlements_cache, if: :saved_change_to_subscribed?

  private

  def send_welcome_email
    AccountMailer.with(user: self).welcome.deliver_later
  end
end
```

### Callbacks in Concerns

```ruby
module Streak::Milestoner
  extend ActiveSupport::Concern

  included do
    after_update :generate_streak_milestone, if: :should_generate_milestone?
  end

  private

  def should_generate_milestone?
    saved_change_to_periods_active? &&
      periods_active.positive? &&
      milestone_worthy?(periods_active)
  end

  def generate_streak_milestone
    Milestone.find_or_create_by(habit:, user:, value: periods_active)
  end
end
```

### After Commit for External Systems

Use `after_commit` when interacting with external services or background jobs:

```ruby
class Aspiration < ApplicationRecord
  after_create_commit :assign_random_default_image

  private

  def assign_random_default_image
    new_api_id = DEFAULT_IMAGES[life_area.to_sym].sample
    attach_image(new_api_id)
  end
end
```

## When to Use Callbacks

**Good use cases:**
- Setting default values before validation
- Auto-creating required associated records
- Busting caches after changes
- Triggering background jobs after commit
- Maintaining data consistency within the model

**Avoid callbacks for:**
- Operations that should be optional
- Side effects that depend on the calling context
- Logic that varies based on who is calling

## Methods That Skip Callbacks

Be aware these methods bypass callbacks entirely:

- `update_column` / `update_columns`
- `delete` / `delete_all`
- `insert` / `insert_all`
- `update_all`
- `touch` (with certain options)
- `increment!` / `decrement!`

## Testing Strategies

### Testing Callback Behavior

Test the outcome, not the callback itself:

```ruby
describe "callbacks" do
  describe "vision board creation" do
    it "creates a vision board after user creation" do
      user = build(:user)
      expect { user.save }.to change(VisionBoard, :count).by(1)
    end
  end
end
```

### Testing Callback Side Effects

```ruby
describe Streak::Milestoner do
  context "when the periods active increase to 7" do
    let(:periods_active) { 7 }

    it "generates a milestone" do
      expect { streak.update(periods_active:) }.to change(Milestone, :count).by(1)
    end
  end
end
```

### Disabling Callbacks in Factories

Use traits to create records without triggering callbacks:

```ruby
FactoryBot.define do
  factory :user do
    # Normal factory triggers callbacks

    trait :skip_callbacks do
      after(:build) do |user|
        user.class.skip_callback(:create, :after, :create_vision_board)
      end

      after(:create) do |user|
        user.class.set_callback(:create, :after, :create_vision_board)
      end
    end
  end
end
```

**Alternative:** Use `update_column` in tests when you need to set state without callbacks:

```ruby
# Skip callbacks by using update_column
user.update_column(:confirmed_at, Time.current)
```

### Using Stub to Bypass Callbacks

```ruby
describe "#process" do
  before do
    allow(activator).to receive(:valid?).and_return(false)
  end

  it "does not update the customer subscription status" do
    activator.process
    expect(user.reload.subscribed).to be(false)
  end
end
```

## Best Practices

1. **Keep callbacks focused** - Each callback should do one thing
2. **Declare methods as private** - Callbacks are implementation details
3. **Use conditional callbacks** - Avoid unnecessary work with `:if` / `:unless`
4. **Prefer `after_commit`** for external interactions - Ensures the transaction completed
5. **Document non-obvious callbacks** - Especially in concerns
6. **Test the behavior, not the mechanism** - Test what changes, not that a callback ran
7. **Avoid callback chains** - One callback triggering another becomes hard to debug
8. **Consider explicit method calls** - Sometimes calling a method directly is clearer than a callback
