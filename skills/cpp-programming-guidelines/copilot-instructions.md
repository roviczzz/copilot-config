# C++ Programming Copilot Instructions

## Basic Principles

- Use English for all code and documentation.
- Explicitly declare types for variables and functions.
- Create necessary types and classes.
- Use Doxygen-style comments for public classes and methods.
- Avoid blank lines within functions.
- Follow the one-definition rule (ODR).

## Naming Conventions

- PascalCase for classes and structures.
- camelCase for variables, functions, and methods.
- ALL_CAPS for constants and macros.
- snake_case for file and directory names.
- UPPERCASE for environment variables.
- Avoid magic numbers; define constants.
- Start functions with a verb.
- Use verbs for boolean variables (e.g., isLoading, hasError).
- Use complete words, not abbreviations, except for standard or well-known cases (API, URL, i, j, k, err, ctx, req, res).

## Functions

- Write short, single-purpose functions (less than 20 instructions).
- Name functions with a verb and a noun.
- For boolean returns, use isX, hasX, canX, etc.
- For void returns, use executeX, saveX, etc.
- Avoid nesting by early returns and utility extraction.
- Use standard library algorithms to avoid nesting.
- Use lambdas for simple operations, named functions for complex ones.
- Use default parameter values instead of null checks.
- Reduce parameters using structs or classes.
- Maintain a single level of abstraction.

## Data

- Prefer composite types over primitive types.
- Use classes with internal validation for data validation.
- Prefer immutability; use const and constexpr appropriately.
- Use std::optional for nullable values.

## Classes

- Follow SOLID principles.
- Prefer composition over inheritance.
- Declare interfaces as abstract classes or concepts.
- Write small, single-purpose classes (less than 200 instructions, 10 public methods, 10 properties).
- Use Rule of Five or Rule of Zero for resource management.
- Make member variables private; provide getters/setters as needed.
- Use const-correctness for member functions.

## Exceptions

- Use exceptions for unexpected errors only.
- Catch exceptions to fix problems or add context; otherwise, use a global handler.
- Use std::optional, std::expected, or error codes for expected failures.

## Memory Management

- Prefer smart pointers over raw pointers.
- Use RAII principles.
- Avoid memory leaks with proper resource management.
- Use standard containers instead of C-style arrays.

## Testing

- Use Arrange-Act-Assert convention.
- Name test variables clearly (inputX, mockX, actualX, expectedX).
- Write unit tests for each public function.
- Use test doubles for dependencies, except for inexpensive third-party dependencies.
- Write integration tests for each module.
- Use Given-When-Then convention.

## Project Structure

- Use modular architecture.
- Organize code into logical directories: include/ (headers), src/ (sources), test/ (tests), lib/ (libraries), doc/ (documentation).
- Use CMake or similar build system.
- Separate interface (.h) from implementation (.cpp).
- Use namespaces for logical organization (core, utils, etc.).

## Standard Library

- Prefer the C++ Standard Library.
- Use std::string, std::vector, std::map, std::unordered_map, etc.
- Use std::optional, std::variant, std::any for type safety.
- Use std::filesystem for file operations.
- Use std::chrono for time operations.

## Concurrency

- Use std::thread, std::mutex, std::lock_guard for thread safety.
- Prefer task-based parallelism.
- Use std::atomic for atomic operations.
- Avoid data races with proper synchronization.
- Use thread-safe data structures when needed.
