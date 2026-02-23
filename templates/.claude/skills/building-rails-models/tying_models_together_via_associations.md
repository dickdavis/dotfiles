# Tying Models Together via Associations

This document covers how to establish relationships between models using Active Record associations.

## Association Types

### belongs_to

Declares that this model holds the foreign key.

```ruby
class Habit < ApplicationRecord
  belongs_to :aspiration
end
```

### has_many

The parent side of a one-to-many relationship.

```ruby
class Aspiration < ApplicationRecord
  has_many :habits, dependent: :destroy
end
```

### has_one

One-to-one relationship where this model is the parent.

```ruby
class User < ApplicationRecord
  has_one :profile, dependent: :destroy
  has_one :vision_board, dependent: :destroy
end
```

### has_many :through

Many-to-many through a join model. Use when the join needs attributes or behavior.

```ruby
class User < ApplicationRecord
  has_many :memberships, dependent: nil
  has_many :groups, through: :memberships, source: :organizable, source_type: "Group"
end

class Habit < ApplicationRecord
  has_many :streaks, dependent: :destroy
  has_many :check_ins, through: :streaks
end
```

### has_one :through

Access an associated model through an intermediate association.

```ruby
class Habit < ApplicationRecord
  belongs_to :aspiration
  has_one :vision_board, through: :aspiration
  has_one :user, through: :vision_board
end
```

## Key Options

### :dependent

Controls what happens to associated records when the parent is destroyed.

| Option | Behavior |
|--------|----------|
| `:destroy` | Calls destroy on associated objects (runs callbacks) |
| `:delete_all` | Deletes directly from database (skips callbacks) |
| `:nullify` | Sets foreign key to NULL |
| `nil` | No automatic handling |

```ruby
has_many :habits, dependent: :destroy
has_many :memberships, dependent: nil  # Managed elsewhere
```

### :touch

Updates the parent's `updated_at` when the child changes.

```ruby
class Streak < ApplicationRecord
  belongs_to :habit, touch: true
end
```

### :inverse_of

Explicitly declare the inverse for bidirectional associations. Required when using scoped associations.

```ruby
has_many :coaching_account_memberships,
  -> { where(organizable_type: "CoachingAccount") },
  class_name: "Membership",
  inverse_of: :user,
  dependent: :destroy
```

### :class_name, :source, :source_type

Override naming conventions for complex associations.

```ruby
has_many :owned_coaching_accounts,
  through: :account_owner_memberships,
  source: :organizable,
  source_type: "CoachingAccount"
```

## Polymorphic Associations

Allow a model to belong to multiple other models.

```ruby
# app/models/image_attachment.rb
class ImageAttachment < ApplicationRecord
  belongs_to :attachable, polymorphic: true
end

# app/models/aspiration.rb
class Aspiration < ApplicationRecord
  has_one :image_attachment, as: :attachable, dependent: :destroy
  has_one :unsplash_image, through: :image_attachment
end
```

Migration for polymorphic:
```ruby
create_table :image_attachments do |t|
  t.references :attachable, polymorphic: true, null: false
  t.references :unsplash_image, foreign_key: true
end
```

## Scoped Associations

Use lambdas to filter associated records.

```ruby
class User < ApplicationRecord
  has_many :account_owner_memberships,
    -> { where(role: Membership::MEMBERSHIP_ROLES[:owner]) },
    class_name: "Membership",
    inverse_of: :user

  has_many :owned_coaching_accounts,
    -> { distinct },
    through: :account_owner_memberships,
    source: :organizable,
    source_type: "CoachingAccount"
end
```

## Delegation

Use `delegate` to expose associated model methods cleanly.

```ruby
class Streak < ApplicationRecord
  belongs_to :habit

  delegate :user, to: :habit
  delegate :aspiration, to: :habit
end

class CheckIn < ApplicationRecord
  belongs_to :streak

  delegate :user, to: :streak
  delegate :aspiration, to: :streak
  delegate :habit, to: :streak
end
```

## Eager Loading and N+1 Prevention

This project uses the **bullet** gem to detect query performance issues. Bullet catches:

- **N+1 queries** - Separate DB calls for each associated record in a loop
- **Unused eager loading** - Preloaded associations that are never accessed
- **Counter cache opportunities** - COUNT queries that could be cached

### When to Use Eager Loading

Use `.includes()` when you will access associated data for multiple records:

```ruby
# Good: Preloads aspirations to avoid N+1 when iterating
habits = Habit.includes(:aspiration).where(status: "active")
habits.each { |h| puts h.aspiration.identity }

# Bad: N+1 query - each iteration hits the database
habits = Habit.where(status: "active")
habits.each { |h| puts h.aspiration.identity }
```

### When NOT to Eager Load

Don't preload associations you won't use - it wastes memory and database resources:

```ruby
# Bad: Loading aspirations unnecessarily
habits = Habit.includes(:aspiration).where(status: "active")
habits.each { |h| puts h.action }  # Never accesses aspiration

# Good: Only load what you need
habits = Habit.where(status: "active")
habits.each { |h| puts h.action }
```

### Eager Loading Scopes

Define scopes to standardize eager loading patterns:

```ruby
class User < ApplicationRecord
  scope :with_eager_loaded_coaching_accounts, lambda {
    includes(
      :default_coaching_account,
      :coaching_account_memberships,
      :owned_coaching_accounts,
      :managed_coaching_accounts
    )
  }
end
```

### Resolving Bullet Warnings

When Bullet reports an issue:

1. **N+1 Query detected** - Add `.includes(:association_name)` to your query
2. **Unused eager loading** - Remove the unnecessary `.includes()` call
3. **Counter cache** - Consider adding `counter_cache: true` to the belongs_to

## Association Best Practices

1. **Always set `:dependent`** - Be explicit about cleanup behavior
2. **Use `:inverse_of`** with scoped associations to prevent extra queries
3. **Prefer `has_many :through`** over `has_and_belongs_to_many` for flexibility
4. **Use delegation** to expose deeply nested associations cleanly
5. **Add database indexes** on foreign key columns for performance
6. **Add foreign key constraints** in migrations for data integrity
7. **Trust Bullet** - Let it guide your eager loading decisions during development
