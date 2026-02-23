# Writing Model Specs

This document covers best practices for writing model specs using RSpec, shoulda-matchers, and FactoryBot.

## Spec Structure

Organize specs by category: associations, validations, database traits, scopes, then instance methods.

```ruby
require "rails_helper"

RSpec.describe Habit do
  subject(:habit) { build(:habit) }

  # Associations first
  it { is_expected.to belong_to(:aspiration) }
  it { is_expected.to have_many(:streaks).dependent(:destroy) }

  # Validations
  it { is_expected.to validate_length_of(:action).is_at_least(3).is_at_most(75) }

  # Database traits / enums
  describe "database traits" do
    it do
      expect(described_class.new).to define_enum_for(:frequency)
        .with_values(Habit::CHECK_IN_FREQUENCIES)
        .backed_by_column_of_type(:enum)
        .with_suffix(:frequency)
    end
  end

  # Scopes
  describe "scopes" do
    describe ".active" do
      # ...
    end
  end

  # Instance methods
  describe "#check_in" do
    # ...
  end
end
```

## shoulda-matchers Reference

### Association Matchers

```ruby
it { is_expected.to belong_to(:aspiration) }
it { is_expected.to belong_to(:habit).touch(true) }
it { is_expected.to have_many(:habits).dependent(:destroy) }
it { is_expected.to have_many(:check_ins).through(:streaks) }
it { is_expected.to have_one(:profile).dependent(:destroy) }
it { is_expected.to have_one(:vision_board).through(:aspiration) }
it { is_expected.to have_one(:mastery_point_award).dependent(:destroy) }
```

### Validation Matchers

```ruby
it { is_expected.to validate_presence_of(:email) }
it { is_expected.to validate_uniqueness_of(:username) }
it { is_expected.to validate_length_of(:action).is_at_least(3).is_at_most(75) }
it { is_expected.to validate_numericality_of(:periods_active).is_greater_than_or_equal_to(0) }
it { is_expected.to validate_inclusion_of(:status).in_array(%w[active archived]) }
```

### Database Matchers

```ruby
it { is_expected.to have_db_index(:performance) }
it { is_expected.to have_db_index(:life_area) }
```

### Enum Matchers

```ruby
it do
  expect(described_class.new).to define_enum_for(:status)
    .with_values(Aspiration::STATUSES)
    .backed_by_column_of_type(:enum)
    .with_suffix(:status)
end
```

### Delegation Matchers

```ruby
it { is_expected.to delegate_method(:user).to(:streak) }
it { is_expected.to delegate_method(:aspiration).to(:habit) }
```

## Named Subjects

Use named subjects for clarity:

```ruby
describe "#active?" do
  subject(:active) { streak.active? }

  let(:streak) { build(:streak, last_performed_at: 1.day.ago) }

  it { is_expected.to be true }
end
```

For method calls:

```ruby
describe "#archive_self_and_children" do
  subject(:method_call) { aspiration.archive_self_and_children }

  let(:aspiration) { create(:aspiration) }

  it "archives aspiration" do
    expect { method_call }.to change(aspiration, :status).to("archived")
  end
end
```

## Testing Scopes

```ruby
describe "scopes" do
  describe ".active" do
    subject(:active) { described_class.active }

    let(:aspiration) { create(:aspiration, vision_board:) }

    before do
      create(:habit, status: "active", aspiration:)
      create(:habit, status: "mastered", aspiration:)
      create_list(:habit, 2, status: "archived", aspiration:)
    end

    it "returns active and mastered habits" do
      expect(active.count).to eq(2)
    end

    it "includes mastered habits" do
      expect(active.pluck(:status)).to include("mastered")
    end
  end
end
```

## Testing Instance Methods

### Basic Pattern

```ruby
describe "#buildable?" do
  let(:aspiration) { create(:aspiration, vision_board:) }

  it "returns true when habit is active" do
    habit = create(:habit, aspiration:, status: "active")
    expect(habit).to be_buildable
  end

  it "returns false when habit is archived" do
    habit = create(:habit, aspiration:, status: "archived")
    expect(habit).not_to be_buildable
  end
end
```

### Testing with Context Blocks

```ruby
describe "#check_in" do
  subject(:method_call) { habit.check_in(**params) }

  let(:params) { {performance:, performed_at:, progress:} }
  let(:performance) { "green" }
  let(:performed_at) { Time.zone.now }
  let(:progress) { "foobar" }

  context "when check_in has invalid attributes" do
    let(:performance) { nil }

    it "does not persist a new check_in" do
      expect { method_call }.not_to change(CheckIn, :count)
    end

    it "returns the check_in with errors" do
      result = method_call
      expect(result.errors.attribute_names).to include(:performance)
    end
  end

  context "when check_in has valid attributes" do
    it "persists a new check_in" do
      expect { method_call }.to change(CheckIn, :count).by(1)
    end
  end
end
```

## Testing Callbacks

Test the behavior, not the callback mechanism:

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

## Using aggregate_failures

Group related assertions to get all failures at once:

```ruby
it "returns a hash with periods_active, active status, and recent_check_ins" do
  summary = streak.summary_for_assessment

  aggregate_failures do
    expect(summary).to be_a(Hash)
    expect(summary[:periods_active]).to eq(3)
    expect(summary[:active]).to be true
    expect(summary[:recent_check_ins]).to be_an(Array)
  end
end
```

## Time-Sensitive Tests

Use `travel_to` for time-dependent behavior:

```ruby
context "when checking in the next day" do
  let!(:streak) { create(:streak, habit:, last_performed_at: "2024-01-15 08:00:00") }

  it "increments the streak" do
    travel_to("2024-01-16 08:30:00")
    method_call
    expect(streak.reload.periods_active).to eq(2)
  end
end
```

## Factory Patterns

### Basic Factory Usage

```ruby
let(:user) { create(:user) }
let(:habit) { build(:habit, aspiration:) }
```

### Using Traits

```ruby
FactoryBot.define do
  factory :user do
    trait :subscriber do
      stripe_customer_id { "cus_#{Faker::Alphanumeric.alphanumeric(number: 14)}" }
      subscribed { true }
    end

    trait :unconfirmed do
      confirmed_at { nil }
    end
  end
end

# In specs
let(:user) { create(:user, :subscriber) }
let(:unconfirmed_user) { create(:user, :unconfirmed) }
```

### Factories with Transient Attributes

```ruby
factory :aspiration_with_habits do
  transient do
    habits_count { 5 }
    habits_status { "active" }
  end

  after(:create) do |aspiration, context|
    create_list(:habit, context.habits_count, status: context.habits_status, aspiration:)
  end
end

# Usage
create(:aspiration_with_habits, habits_count: 3, habits_status: "locked")
```

### Mock Helpers

Create helper methods for common patterns:

```ruby
# spec/support/mocks/users.rb
module Mocks::Users
  def mock_user(options = {})
    create(:user, **options)
  end

  def mock_subscribed_user(options = {})
    create(:user, :subscriber, **options)
  end
end

# In specs
let(:user) { mock_user }
let(:subscriber) { mock_subscribed_user }
```

## Testing Validation Errors

```ruby
describe "validations" do
  context "when a customer is not found" do
    let(:stripe_customer_id) { "not-valid" }

    it "is not valid" do
      aggregate_failures do
        expect(activator).not_to be_valid
        expect(activator.errors.details[:customer]).to include(error: :not_found)
      end
    end
  end
end
```

## Best Practices

1. **Use named subjects** - Makes specs readable and reusable
2. **Prefer `build` over `create`** when persistence isn't needed
3. **Use `create_list`** for multiple records
4. **Avoid `let!`** unless you need eager evaluation
5. **Group with `aggregate_failures`** for related assertions
6. **Test edge cases** - nil values, boundaries, error conditions
7. **Use descriptive context blocks** - "when user is subscribed", "with invalid attributes"
8. **Avoid mocks/doubles** unless testing external integrations
9. **Use factory traits** to express different states
10. **Test outcomes, not implementation** - What changed, not how
