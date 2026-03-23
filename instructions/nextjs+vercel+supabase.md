# BA Copilot (Next.js + Vercel + Supabase) Copilot Instructions

## Project Overview

- BA Copilot is an assistant for business analysts, focused on creating and iterating on BPMN diagrams with AI-powered suggestions and document integration.
- MVP features: question input, BPMN diagram upload/editing, document upload, AI suggestions, and iterative workflow.
- Vision: A comprehensive tool for business analysts, including community, toolkit, job board, and more.

## UI Guidelines

- Clean, minimalist, and user-friendly interface.
- Hierarchical navigation: Home, Assistant, Vault, Library, History, Toolkit, Community, Job Board, Settings.
- Main interaction: "Ask anything..." box with quick action buttons for common BA tasks.
- Support for uploading/viewing BPMN diagrams and documents.
- Provide contextual suggestions and references from uploaded content.

## Technical Stack

- Next.js (App Router only, never Pages Router)
- Vercel AI
- Supabase (DB, Auth, type safety)
- Tanstack Query
- Material UI
- Orval (optional, for API typing and testing)
- Quokka
- App folder is `src/app` (never use `app/` at root)
- Follow Devias template and coding style when integrating elements from Devias Kit Pro.

## Development Guidelines

- Teach and explain Next.js concepts as needed (assume intermediate React, new to Next.js).
- Recommend improvements or replacements for stack elements if appropriate.
- Suggest missing stack elements with pros/cons and recommendations.
- Always check recommendations are for App Router, not Pages Router.
- Use type safety and best practices for all integrations.

## Best Practices

- Modular, maintainable, and accessible code.
- Use clear naming conventions and structure for components and files.
- Prioritize user experience and performance.
- Reference Devias template for structure and style.

Refer to project documentation and Devias template for further details and best practices.
