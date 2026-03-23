# Next.js + React + TypeScript Copilot Instructions

## Key Principles

- Write concise, technical TypeScript code with accurate examples.
- Use functional, declarative programming; avoid classes.
- Prefer iteration and modularization over duplication.
- Use descriptive variable names (e.g., isLoading).
- Use lowercase with dashes for directories (e.g., components/auth-wizard).
- Favor named exports for components.
- Use the Receive an Object, Return an Object (RORO) pattern.

## JavaScript/TypeScript

- Use the `function` keyword for pure functions. Omit semicolons.
- Use TypeScript for all code; prefer interfaces over types. Avoid enums, use maps.
- File structure: exported component, subcomponents, helpers, static content, types.
- Avoid unnecessary curly braces in conditionals; use concise, one-line syntax for simple statements.

## Error Handling and Validation

- Handle errors and edge cases at the start of functions.
- Use early returns for error conditions; avoid deep nesting.
- Place the happy path last in the function.
- Avoid unnecessary else statements; use the if-return pattern.
- Use guard clauses for preconditions and invalid states.
- Implement proper error logging and user-friendly error messages.
- Use custom error types or factories for consistent error handling.

## React/Next.js

- Use functional components and TypeScript interfaces.
- Use declarative JSX.
- Use `function`, not `const`, for components.
- Use Shadcn UI, Radix, and Tailwind Aria for components and styling.
- Implement responsive, mobile-first design with Tailwind CSS.
- Place static content and interfaces at the end of files.
- Use content variables for static content outside render functions.
- Minimize 'use client', 'useEffect', and 'setState'; favor React Server Components (RSC).
- Use Zod for form validation.
- Wrap client components in Suspense with fallback.
- Use dynamic loading for non-critical components.
- Optimize images: use WebP, include size data, implement lazy loading.
- Model expected errors as return values; avoid try/catch for expected errors in Server Actions. Use useActionState to manage and return errors to the client.
- Use error boundaries (error.tsx, global-error.tsx) for unexpected errors.
- Use useActionState with react-hook-form for form validation.
- Code in services/ should throw user-friendly errors for tanStackQuery to catch and display.
- Use next-safe-action for all server actions:
  - Implement type-safe server actions with validation.
  - Use Zod for input schemas.
  - Handle errors gracefully and return ActionResponse type.
  - Use import type { ActionResponse } from '@/types/actions'.
  - Ensure all server actions return ActionResponse.
  - Implement consistent error and success responses.

## Key Conventions

- Use Next.js App Router for state changes.
- Prioritize Web Vitals (LCP, CLS, FID).
- Minimize 'use client':
  - Prefer server components and SSR features.
  - Use 'use client' only for Web API access in small components.
  - Avoid for data fetching or state management.
- Refer to Next.js documentation for Data Fetching, Rendering, and Routing best practices.
