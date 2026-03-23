# Copilot Configuration

This repository contains custom instructions, skills, agents, and prompts to enhance GitHub Copilot's capabilities for web development, technical documentation, and autonomous task execution.

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

### Programming Languages & Optimization

- **cpp-programming-guidelines** - C++ development best practices and coding guidelines
- **web-app-optimization** - Web application performance optimization techniques and strategies

---

## 🤖 Agents

Autonomous agents for specialized workflow automation:

### UX/UI Design & E-commerce

- **[se-ux-ui-designer.agent.md](agents/se-ux-ui-designer.agent.md)** - Senior UX/UI Designer agent for interface design and user experience
- **[shopify-export.agent.md](agents/shopify-export.agent.md)** - Shopify data export and integration automation

### AI Development Mode

- **[architect.agent.md](agents/ai-development-mode/architect.agent.md)** - Software architecture and system design planning
- **[clean-code.agent.md](agents/ai-development-mode/clean-code.agent.md)** - Code quality and clean code standards

---

## 💬 Prompts

Pre-defined prompts for task execution and generation:

- **[task-execution-prompt.md](prompts/task-execution-prompt.md)** - Framework for executing complex development tasks
- **[task-generation-prompt.md](prompts/task-generation-prompt.md)** - Framework for generating and planning new tasks

---

## 📖 How to Use

1. **Select an Instruction** - Choose the appropriate setup guide based on your tech stack
2. **Activate Skills** - Skills automatically load when relevant to your request (e.g., "review website design" triggers web-design-reviewer)
3. **Ask Copilot** - Reference these instructions/skills in your requests for more tailored responses

---

## 🔗 Using Copilot Config Across Your Projects

Reference and apply this copilot-config repository when working on other repositories for consistent AI assistance.

### Setup Options

#### Option 1: Clone Repository Alongside Projects
```bash
git clone https://github.com/yourusername/copilot-config.git ../copilot-config
```

#### Option 2: Project-Specific Settings
Create `.vscode/settings.json` in your project:
```json
{
  "copilot.instructions": [
    "${workspaceFolder}/../copilot-config/instructions"
  ]
}
```

#### Option 3: VS Code Multi-Root Workspace
Create a `.code-workspace` file:
```json
{
  "folders": [
    {
      "path": ".",
      "name": "Main Project"
    },
    {
      "path": "../copilot-config",
      "name": "Copilot Config"
    }
  ], Relevant Agent |
|------|----------------------|---|---|
| Build a Next.js + React + TS app | nextjs+react+typescript.md | webcoder | architect |
| Design a responsive UI | typescript+react+shadcn-ui.md | web-design-reviewer | se-ux-ui-designer |
| Test web application UI | react+js+tailwind.instructions.md | webapp-testing | clean-code |
| Optimize SEO on Next.js | nextjs-14-tailwind-seo-setup.md | webcoder | architect |
| Deploy to Vercel with backend | nextjs+vercel+supabase.md | readme-generator | architect |
| Component library setup | daisyui.instructions.md | web-design-reviewer | se-ux-ui-designer |
| Optimize web app performance | N/A | web-app-optimization | architect |
| C++ development | N/A | cpp-programming-guidelines | clean-code |
| Shopify integration | N/A | N/A | shopify-export

#### Option 4: Global Copilot Configuration
Edit `~/.vscode/settings.json` to apply globally:
```json
{
  "copilot.instructions": [
    "${userHome}/.copilot/instructions"
  ]
}
```

### Workflow

1. Clone or symlink copilot-config alongside your projects
2. Reference shared instructions in your project settings
3. All projects automatically inherit consistent Copilot behavior
4. Update copilot-config once, changes apply everywhere

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
