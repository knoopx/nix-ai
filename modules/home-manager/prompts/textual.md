# BEST PRACTICES for Textual TUI Development

This document outlines essential best practices, coding standards, and architectural guidelines for developing Textual-based TUI (Text User Interface) applications. It is based on internal experience and the latest recommendations from the Textual project.

## Project Architecture

- **Widget Design**: Subclass `Widget` for custom UI components. Compose widgets for complex UIs. Each widget should have a single, clear responsibility.
- **Screens**: Use `Screen` or `ModalScreen` for full-terminal containers, dialogs, and navigation. Register screens with `SCREENS` or `install_screen()`.
- **App Structure**: Subclass `App` and implement `compose()` to define your UI. Use lifecycle hooks (`on_mount`, `on_ready`) for setup and teardown.

## Coding Standards

- **Follow [PEP 8](https://peps.python.org/pep-0008/)** for code style and naming conventions.
- **Imports**: Order as standard library, third-party, then local modules. Place all imports at the top of the file. Avoid unnecessary comments on imports.
- **Type Annotations**: Use type hints as per [PEP 484](https://peps.python.org/pep-0484/) and [PEP 526](https://peps.python.org/pep-0526/).
- **Resource Management**: Use `with` statements for files and resources.
- **Naming**: Modules: short, lowercase. Classes: CapWords. Functions/variables: lowercase_with_underscores. Constants: ALL_CAPS.

## UI Best Practices

- **Input Handling**: Use key bindings and actions for keyboard shortcuts. Define `BINDINGS` for mapping keys to actions. Use `focus()` and focus/blur events for input management.
- **Navigation**: Use `Screen`/`ModalScreen` for navigation and overlays. Use `push_screen()`, `pop_screen()`, `switch_screen()` for navigation.
- **Command Palette**: Override `get_system_commands()` in your `App` to add commands. Use fuzzy matching for discoverability.
- **Workers**: Use `run_worker()` or `@work` for background tasks. Prefer async for I/O, `thread=True` for CPU-bound tasks. Use message passing for UI updates from threads.
- **Styles & CSS**: Prefer CSS for static styles; use Python for dynamic changes. Organize `.tcss` files for maintainability.
- **Queries**: Use `query()` for selecting/manipulating widgets. Prefer specific selectors.
- **Layout**: Use containers, grid, and flex layouts for complex UIs. Prefer grid/flex for responsive designs.
- **Events & Messages**: Use event-driven patterns. Handle events with `on_event` or custom message classes.
- **Actions**: Define `action_` methods for user-invoked behaviors. Bind keys to actions.
- **Reactivity**: Use reactive properties for automatic UI updates. Avoid unnecessary recomputation.
- **Themes**: Use built-in or custom themes. Organize theme files for maintainability.
- **Content**: Use labels, markdown, and rich text for display. Bind content to reactive properties for dynamic updates.
- **Animation**: Use built-in animation APIs to enhance UX, not distract.
- **Devtools**: Use `textual run --dev` for live inspection and debugging.
- **Testing**: Write unit/integration tests for widgets and logic. Use Textual's testing tools to simulate user input and verify UI state.

## Anti-Patterns to Avoid

- **Superfluous Comments**: Only comment to clarify intent or complex logic. Avoid restating what the code does.
- **Using `hasattr` for Required Attributes**: Access required attributes directly. Use `hasattr` only for truly optional or dynamic attributes.
- **Silent Exception Handling**: Always log or handle exceptions meaningfully. Avoid silencing errors.
- **Unused Code and Debug Statements**: Remove unused code, commented-out sections, and debug prints before committing.
- **Hard-Coded Values**: Use constants, configuration files, or environment variables for values that should be configurable.
- **Spaghetti Code**: Refactor code that is hard to read or maintain. Use meaningful names, modularize logic, and avoid deep nesting.

## Reference

- [Textual Documentation](https://textual.textualize.io/guide/)
- [Textual Input Guide](https://textual.textualize.io/guide/input/)
- [Textual Screens Guide](https://textual.textualize.io/guide/screens/)
- [Textual Workers Guide](https://textual.textualize.io/guide/workers/)
- [Textual CSS Guide](https://textual.textualize.io/guide/css/)
- [Textual Testing Guide](https://textual.textualize.io/guide/testing/)
- [Textual Command Palette Guide](https://textual.textualize.io/guide/command_palette/)
- [Textual Styles Guide](https://textual.textualize.io/guide/styles/)
- [Textual Queries Guide](https://textual.textualize.io/guide/queries/)
- [Textual Layout Guide](https://textual.textualize.io/guide/layout/)
- [Textual Events & Messages Guide](https://textual.textualize.io/guide/events/)
- [Textual Actions Guide](https://textual.textualize.io/guide/actions/)
- [Textual Reactivity Guide](https://textual.textualize.io/guide/reactivity/)
- [Textual Themes Guide](https://textual.textualize.io/guide/themes/)
- [Textual Widgets Guide](https://textual.textualize.io/guide/widgets/)
- [Textual Content Guide](https://textual.textualize.io/guide/content/)
- [Textual Animation Guide](https://textual.textualize.io/guide/animation/)
- [Textual Devtools Guide](https://textual.textualize.io/guide/devtools/)
- [Textual App Guide](https://textual.textualize.io/guide/app/)
- [DuckDB Documentation](https://duckdb.org/docs/)
