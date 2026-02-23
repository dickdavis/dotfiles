# Writing Effective Migrations

This document covers best practices for writing safe, performant database migrations.

## Migration Safety

This project uses **strong_migrations** to catch unsafe operations. Migrations that block reads/writes or cause application errors will fail with guidance on how to fix them.

### Key Principles

1. **Avoid long locks** - Operations that lock tables for extended periods cause downtime
2. **Deploy in phases** - Separate DDL changes from data backfills
3. **Validate constraints separately** - Add constraints without validation first, then validate in a follow-up migration

## Common Patterns

### Creating Tables

```ruby
class CreateMilestones < ActiveRecord::Migration[7.1]
  def change
    create_table :milestones do |t|
      t.references :user, null: false, foreign_key: true
      t.references :habit, null: false, foreign_key: true
      t.integer :value, null: false

      t.timestamps
    end
  end
end
```

### Adding Columns

Add columns without defaults or with static defaults safely:

```ruby
class AddVisionBoardIdToAspirations < ActiveRecord::Migration[7.1]
  def change
    add_column :aspirations, :vision_board_id, :uuid
  end
end
```

### Adding Indexes (PostgreSQL)

Always add indexes concurrently to avoid blocking writes:

```ruby
class AddIndexToVisionBoardId < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!

  def change
    add_index :aspirations, :vision_board_id, algorithm: :concurrently
  end
end
```

### Adding Foreign Keys

Add foreign keys in two steps to avoid long locks:

**Step 1: Add without validation**
```ruby
class AddVisionBoardForeignKey < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key :aspirations, :vision_boards, validate: false
  end
end
```

**Step 2: Validate in separate migration**
```ruby
class ValidateAddVisionBoardForeignKey < ActiveRecord::Migration[7.1]
  def change
    validate_foreign_key :aspirations, :vision_boards
  end
end
```

### Using PostgreSQL Enums

```ruby
class CreateAspirations < ActiveRecord::Migration[7.0]
  def up
    create_enum :aspiration_life_area, %w[career financial spiritual physical]
    create_enum :aspiration_status, %w[active archived locked]

    create_table :aspirations do |t|
      t.enum :life_area, enum_type: "aspiration_life_area", null: false
      t.enum :status, enum_type: "aspiration_status", default: "active", null: false
      t.timestamps
    end

    add_index :aspirations, :life_area
    add_index :aspirations, :status
  end

  def down
    drop_table :aspirations
    execute "DROP TYPE aspiration_life_area;"
    execute "DROP TYPE aspiration_status;"
  end
end
```

## Operations to Avoid

| Operation | Problem | Solution |
|-----------|---------|----------|
| `add_index` without `algorithm: :concurrently` | Blocks writes | Use `disable_ddl_transaction!` + `algorithm: :concurrently` |
| `add_foreign_key` without `validate: false` | Scans entire table | Add unvalidated, then validate separately |
| `change_column_null` on existing column | Can timeout on large tables | Add a check constraint instead |
| `remove_column` without code changes | Causes exceptions until app reboots | Remove column references from code first |
| Using `json` type | No equality operator, causes errors | Use `jsonb` instead |

## Data Migrations

Use the **data-migrate** gem for data changes. Keep schema migrations separate from data migrations.

### Generate a Data Migration

```bash
podman compose exec app bin/rails g data_migration backfill_new_column
```

This creates a file in `db/data/`.

### Running Data Migrations

```bash
# Run pending data migrations only
podman compose exec app bin/rake data:migrate

# Run schema and data migrations together
podman compose exec app bin/rake db:migrate:with_data

# Check migration status
podman compose exec app bin/rake data:migrate:status
```

### Data Migration Examples

**Batch processing with `find_each`:**
```ruby
class CreateVisionBoardsForUsers < ActiveRecord::Migration[7.1]
  def up
    User.find_each do |user|
      vision_board = VisionBoard.find_or_create_by!(user:)
      user.aspirations.update_all(vision_board_id: vision_board.id)
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
```

**Using `in_batches` for bulk updates:**
```ruby
class InitializeCheckInsRecordedAt < ActiveRecord::Migration[7.1]
  def up
    CheckIn.in_batches do |relation|
      relation.each do |check_in|
        check_in.recorded_at = check_in.created_at
        check_in.save
      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
```

## Deployment Workflow

For complex changes, deploy in phases:

1. **Deploy schema migration** - Add columns/constraints (validated: false)
2. **Deploy code** - Update application to use new schema
3. **Run data migration** - Backfill data using data-migrate
4. **Deploy validation migration** - Validate constraints
5. **Clean up** - Remove old columns/code in final migration
