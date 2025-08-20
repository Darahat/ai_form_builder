# Best Practices

## State Management with Riverpod

Use **Riverpod** for all state management:

- Avoid using `setState` for complex or app-wide state.
- Use `StateNotifier` or `Provider` for managing app state.

## Error Handling

Use `try-catch` blocks for all API calls:

- Handle exceptions gracefully and provide meaningful error messages to users.

## Clean Architecture

Maintain a clear separation of concerns:

- **Presentation**: UI-related code
- **Domain**: Business logic
- **Data**: Data sources and repositories
