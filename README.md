# Copilot Configuration

This repository contains custom instructions and skills to enhance GitHub Copilot's capabilities for web development and technical documentation.

---

## 📚 Instructions

Custom instruction sets for specific technology stacks and configurations:

### Frontend Frameworks & Libraries

- **[nextjs+react+typescript.md](instructions/nextjs+react+typescript.md)** - Next.js 14+ with React and TypeScript setup and best practices
- **[nextjs-14-tailwind-seo-setup.md](instructions/nextjs-14-tailwind-seo-setup.md)** - Next.js 14 with Tailwind CSS and SEO optimization
- **[typescript+react+shadcn-ui.md](instructions/typescript+react+shadcn-ui.md)** - React with TypeScript and shadcn/ui component library
- **[react+js+tailwind.instructions.md](instructions/react+js+tailwind.instructions.md)** - React with JavaScript and Tailwind CSS

### UI & Styling

- **[daisyui.instructions.md](instructions/daisyui.instructions.md)** - DaisyUI component framework setup and usage

### Backend & Deployment

- **[nextjs+vercel+supabase.md](instructions/nextjs+vercel+supabase.md)** - Next.js with Vercel deployment and Supabase backend

---

## 🛠️ Skills

Enhanced capabilities for specialized development tasks:

### Web Design & Testing

- **web-design-reviewer** - Visual inspection and fixing of website design issues (responsive design, accessibility, visual consistency, layout problems)
- **webapp-testing** - Automated testing and debugging of web applications using Playwright (browser automation, screenshot capture, UI verification)

### Development Tools & Documentation

- **readme-generator** - Comprehensive README documentation generation
- **webcoder** - Web development reference knowledge with documentation on:
  - HTML/CSS/JavaScript fundamentals
  - Web APIs and DOM manipulation
  - HTTP networking and protocols
  - Performance optimization
  - Security and authentication
  - Accessibility standards
  - Development tools and frameworks

---

## 📖 How to Use

1. **Select an Instruction** - Choose the appropriate setup guide based on your tech stack
2. **Activate Skills** - Skills automatically load when relevant to your request (e.g., "review website design" triggers web-design-reviewer)
3. **Ask Copilot** - Reference these instructions/skills in your requests for more tailored responses

---

## 🎯 Quick Reference

| Task | Relevant Instruction | Relevant Skill |
|------|----------------------|----------------|
| Build a Next.js + React + TS app | nextjs+react+typescript.md | webcoder |
| Design a responsive UI | typescript+react+shadcn-ui.md | web-design-reviewer |
| Test web application UI | react+js+tailwind.instructions.md | webapp-testing |
| Optimize SEO on Next.js | nextjs-14-tailwind-seo-setup.md | webcoder |
| Deploy to Vercel with backend | nextjs+vercel+supabase.md | readme-generator |
| Component library setup | daisyui.instructions.md | web-design-reviewer |
