---
name: building-rails-models
description: Build well-organized Rails models that encapsulate domain logic effectively. Use when implementing domain logic for the application.
---

# Building Rails Models

This skill guides the implementation of domain logic in the model layer of a Rails application using best practices.

## When to Use This Skill

Use when creating a new Rails model or extending an existing Rails model.

## Start Here: Workflow

**Always start with the workflow checklist.** Copy the appropriate checklist and track progress through each phase:

| Task | Workflow |
| ---- | -------- |
| **Create new model** | [New Model Workflow](workflow.md#new-model-workflow) |
| **Extending an existing model** | [Model Extension Workflow](workflow.md#model-extension-workflow) |

The workflow includes validation loops at each phase. **Do not skip validation steps.**

## Reference Documents

Consult these when implementing phases of the workflow:

| Document | Use When |
| -------- | -------- |
| [Writing effective migrations](writing_effective_migrations.md) | Explains how to write safe and performant migrations. Reference this document when writing a database schema migration. |
| [Organizing domain logic](organizing_domain_logic.md) | Explains how to effectively organize domain logic in the model layer. Reference this document when analyzing or planning the implementation. |
| [Tying models together via associations](tying_models_together_via_associations.md) | Explains how to use associations to effectively relate models to one another. Reference this document when implementing model associations. |
| [Ensuring data quality](ensuring_data_quality.md) | Explains best practices for model validations. Reference this document when implementing model layer data validations. |
| [Using callbacks](using_callbacks.md) | Explains the proper use of callbacks. Reference this document when implementing business logic that should be performed as part of the model lifecycle. |
| [Writing model specs](writing_model_specs.md) | Explains best practices for writing model specs. Reference this document when implementing specs to cover model behavior. |
