# Rails Model Workflows

This document provides step-by-step workflows with validation checkpoints for implementing domain logic in the Rails model layer.

## Contents

- [New Model Workflow](#new-model-workflow)
- [Model Extension Workflow](#model-extension-workflow)

## New Model Workflow

Use this checklist when creating a new Rails model.

```
## New Model: [NAME]

### Phase 1: Migration
- [ ] Initialize the model using the Rails CLI: `podman compose exec app bin/rails g model [NAME]`
- [ ] Add migration code for making the appropriate schema changes using best practices
- [ ] Run the formatter: `podman compose exec app bundle exec standardrb --fix`
- [ ] Run the migration: `podman compose exec app bin/rails db:migrate`
- [ ] Fix any errors (if necessary)
- [ ] Run the migration again (if necessary)
- [ ] Pause to allow the user to commit and deploy the migration

### Phase 2: Basic Model Implementation
- [ ] Ensure the model file, model spec file, and model factory file have all been created
- [ ] Add appropriate factory attributes for testing purposes
- [ ] Add relationship expectations to model spec file (skip if no relationships)
- [ ] Run the specs to ensure they fail: `podman compose exec app bundle exec rspec path/to/model/spec` (skip if no relationships)
- [ ] Add the relationships to the model (skip if no relationships)
- [ ] Run the specs again to ensure they succeed (skip if no relationships)
- [ ] Add validation expectations to model spec file
- [ ] Run the specs to ensure they fail: `podman compose exec app bundle exec rspec path/to/model/spec`
- [ ] Add validations to the model
- [ ] Run the specs again to ensure they succeed
- [ ] Run the formatter: `podman compose exec app bundle exec standardrb --fix`
- [ ] Pause to allow the user to commit the work done in this phase

### Phase 3: Public Interface
- [ ] Analyze purpose of the model
- [ ] Determine the public interface the model will expose
- [ ] Write specs for each public method
- [ ] Run the specs to ensure they fail
- [ ] Implement the model's public interface
- [ ] Run the specs to ensure they succeed
- [ ] Run the formatter: `podman compose exec app bundle exec standardrb --fix`
- [ ] Run the code smell detector: `podman compose exec app bundle exec reek`
- [ ] Fix any code smells indicated by the detector
- [ ] Pause to allow the user to commit the work done in this phase
```

## Model Extension Workflow

Use this checklist when extending an existing Rails model.

```
## Existing Model: [NAME]

### Phase 1: Analyze requirements
- [ ] Research sections of the codebase that are relevant to the task provided by the user
- [ ] Consider options for how the required task should be implemented, either directly in the model, as a model concern, or as a class within the model's namespace
- [ ] Determine the best path forward based on trade-offs; you may present the options to the user so they may decide

### Phase 2: Set-up
- [ ] Create any necessary files, including the implementation as well as specs.
- [ ] Ensure model concern is included in the model (skip if not implemented as a model concern)

### Phase 3: Public Interface (skip if no public interface needed)
- [ ] Determine the public interface the model will expose
- [ ] Write specs for each public method
- [ ] Run the specs to ensure they fail
- [ ] Implement the model's public interface
- [ ] Run the specs to ensure they succeed
- [ ] Run the formatter: `podman compose exec app bundle exec standardrb --fix`
- [ ] Run the code smell detector: `podman compose exec app bundle exec reek`
- [ ] Fix any code smells indicated by the detector
- [ ] Pause to allow the user to commit the work done in this phase
```

