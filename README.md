# Agentic Dev

AI agent configuration — custom instructions, skills, agents, and prompts for agentic development workflows, technical documentation, and autonomous task execution.

---

## Quick Start

| Step | Action |
| ---- | ------ |
| 1    | `git clone https://github.com/yourusername/agentic-dev.git && cd agentic-dev` |
| 2    | Run `./install.sh` (macOS/Linux) or `install.ps1` (Windows) |
| 3    | Select your tools from the interactive menu |
| 4    | Restart your IDE — skills and agents load automatically |

### Headless (CI / automation)

```bash
./install.sh --tools copilot,opencode,claude-code
```
```powershell
install.ps1 -Tools copilot,opencode,claude-code
```

---

## Installation by Tool

### GitHub Copilot (VS Code)

Copilot reads from `~/.copilot/` and makes agents, instructions, prompts, and skills available in VS Code.

**Option A: Install Script**

| OS          | Command                                                  |
| ----------- | -------------------------------------------------------- |
| Windows     | `powershell -ExecutionPolicy Bypass -File install.ps1` |
| macOS/Linux | `chmod +x install.sh && ./install.sh`                  |

**Option B: Manual**

```bash
mkdir -p ~/.copilot/{agents,instructions,prompts,skills}
cp -r agentic-dev/agents/* ~/.copilot/agents/
cp -r agentic-dev/instructions/* ~/.copilot/instructions/
cp -r agentic-dev/prompts/* ~/.copilot/prompts/
cp -r agentic-dev/skills/* ~/.copilot/skills/
```

**Windows (PowerShell):**

```powershell
$dirs = @('agents','instructions','prompts','skills')
foreach ($d in $dirs) { New-Item -Path "$env:USERPROFILE\.copilot\$d" -Type Directory -Force | Out-Null }
Copy-Item -Path "agentic-dev\agents\*" -Destination "$env:USERPROFILE\.copilot\agents\" -Recurse -Force
Copy-Item -Path "agentic-dev\instructions\*" -Destination "$env:USERPROFILE\.copilot\instructions\" -Recurse -Force
Copy-Item -Path "agentic-dev\prompts\*" -Destination "$env:USERPROFILE\.copilot\prompts\" -Recurse -Force
Copy-Item -Path "agentic-dev\skills\*" -Destination "$env:USERPROFILE\.copilot\skills\" -Recurse -Force
```

**Project-level config** — `.vscode/settings.json`:

```jsonc
{
  "copilot.instructions": [
    "${workspaceFolder}/agentic-dev/instructions"
  ]
}
```

---

### OpenCode

OpenCode reads from `~/.config/opencode/opencode.json`. Skills load from `~/.agents/skills/`.

```bash
# Symlink skills into agentic-dev
ln -sf "$PWD/agentic-dev/skills"/* ~/.agents/skills/
```

**Windows (PowerShell):**

```powershell
$skillsDir = "$env:USERPROFILE\.agents\skills"
New-Item -Path $skillsDir -Type Directory -Force | Out-Null
Get-ChildItem "agentic-dev\skills" -Directory | ForEach-Object {
    $target = Join-Path $skillsDir $_.Name
    if (-not (Test-Path $target)) {
        New-Item -Path $target -ItemType Junction -Target $_.FullName
    }
}
```

Or use `opencode sync` to link this repo.

---

### Cursor

```bash
# Project-level symlinks
ln -sf "$PWD/agentic-dev/instructions" .cursor/instructions
ln -sf "$PWD/agentic-dev/agents" .cursor/agents

# Global install
cp -r agentic-dev/instructions/* ~/.cursor/instructions/
cp -r agentic-dev/agents/* ~/.cursor/agents/
```

---

### Windsurf (Codeium)

```bash
# Global
cp -r agentic-dev/instructions/* ~/.windsurf/instructions/
# Project-level
cp -r agentic-dev/instructions/* .windsurf/instructions/
```

---

### Claude Code

Claude Code reads skills from `~/.claude/skills/`. Skills become available when you describe tasks that match them.

```bash
# Via install script (recommended)
./install.sh --tools claude-code

# Manual
cp -r agentic-dev/skills/* ~/.claude/skills/
```

---

### Antigravity

Shares skills with OpenCode via `~/.agents/skills/`:

```bash
ln -sf "$PWD/agentic-dev/skills"/* ~/.agents/skills/
```

---

### Cline (VS Code Extension)

| Scope   | File                                                      |
| ------- | --------------------------------------------------------- |
| Project | `.clinerules` or `.github/copilot-instructions.md`    |
| Global  | VS Code `settings.json` → `cline.customInstructions` |

```bash
# Project-level
cp agentic-dev/instructions/typescript+react+shadcn-ui.md .clinerules
```

---

### Zed

| Scope   | Path                            |
| ------- | ------------------------------- |
| Global  | `~/.config/zed/settings.json` |
| Project | `.zed/settings.json`          |

```bash
cp -r agentic-dev/instructions/* ~/.config/zed/instructions/
```

---

## What Gets Installed

### Instructions

| Category   | File                                  | Stack                               |
| ---------- | ------------------------------------- | ----------------------------------- |
| Frontend   | `nextjs+react+typescript.md`        | Next.js 14+ • React • TypeScript  |
|            | `nextjs-14-tailwind-seo-setup.md`   | Next.js 14 • Tailwind CSS • SEO   |
|            | `typescript+react+shadcn-ui.md`     | React • TypeScript • shadcn/ui    |
|            | `react+js+tailwind.instructions.md` | React • JavaScript • Tailwind CSS |
| UI/Styling | `daisyui.instructions.md`           | daisyUI 5 component library         |
| Fullstack  | `nextjs+vercel+supabase.md`         | Next.js • Vercel • Supabase       |

### Skills

| Domain                 | Skill                          | Purpose                                                              |
| ---------------------- | ------------------------------ | -------------------------------------------------------------------- |
| **Humanization** | `roviczzz-humanize`          | Academic text humanization — strips AI tells, enforces active voice |
|                        | `anti-slop`                  | Detect & eliminate generic AI patterns in text, code, design         |
|                        | `hoomanize`                  | Remove AI writing signs: inflated symbolism, passive voice           |
|                        | `stop-slop`                  | Eliminate predictable AI writing patterns from prose                 |
|                        | `humanizer`                  | Two-pass edit + audit for natural tone                               |
|                        | `caveman`                    | Ultra-compressed token-efficient communication                       |
| **Frontend**     | `frontend-developer`         | React components, responsive layouts, modern architecture            |
|                        | `frontend-design`            | Production-grade interfaces, avoid generic aesthetics                |
|                        | `web-design-reviewer`        | Visual inspection for responsive, accessible, consistent design      |
|                        | `mobile-design`              | Mobile-first, touch-first, platform-respectful patterns              |
|                        | `scroll-experience`          | Narrative scrolling with delight moments                             |
|                        | `form-cro`                   | Conversion rate optimization for forms                               |
|                        | `ui-ux-pro-max`              | Color palettes, typography, UX review, component design              |
|                        | `canvas-design`              | Design philosophies expressed visually (MD, PDF, PNG)                |
| **React**        | `react-best-practices`       | 12 performance rules across 6 categories                             |
|                        | `react-patterns`             | Hooks, composition, performance, TypeScript patterns                 |
| **Next.js**      | `nextjs-best-practices`      | App Router, Server Components, data fetching                         |
| **Tailwind**     | `tailwind-patterns`          | CSS-first config, container queries, design tokens                   |
| **Backend**      | `backend-dev-guidelines`     | Node.js/Express/TypeScript/microservices                             |
|                        | `api-patterns`               | REST vs GraphQL vs tRPC, auth, rate-limiting                         |
|                        | `stripe-integration`         | Checkouts, subscriptions, webhooks, PCI                              |
| **Database**     | `database-design`            | Schema, indexing, ORM selection, serverless                          |
| **3D**           | `3d-web-experience`          | Three.js, R3F, WebGL, Spline workflows                               |
| **C++**          | `cpp-programming-guidelines` | Modern C++, Doxygen, ODR compliance                                  |
| **Testing**      | `webapp-testing`             | Playwright automation, screenshots, UI verification                  |
|                        | `systematic-debugging`       | Root cause analysis before fixes                                     |
| **Fullstack**    | `senior-fullstack`           | Modern fullstack toolkit + best practices                            |
| **Optimization** | `web-app-optimization`       | SSR, SSG, compile-time, minimal JS                                   |
| **SEO**          | `seo-audit`                  | Crawlability, indexation, rankings diagnostics                       |
| **Planning**     | `concise-planning`           | Atomic checklists for coding tasks                                   |
| **Meta**         | `find-skills`                | Discover & install new agent skills                                  |

### Agents

| Agent                 | File                                        | Role                                              |
| --------------------- | ------------------------------------------- | ------------------------------------------------- |
| Senior UX/UI Designer | `se-ux-ui-designer.agent.md`              | Jobs-to-be-done, journeys, personas, UX research  |
| Shopify Expert        | `shopify-export.agent.md`                 | Liquid theming, Admin/Storefront APIs, metafields |
| Architect             | `ai-development-mode/architect.agent.md`  | Domain-driven design, ADRs, system architecture   |
| Clean Code            | `ai-development-mode/clean-code.agent.md` | Code quality, naming, DRY, test coverage          |

### Prompts

| Prompt                        | Purpose                                |
| ----------------------------- | -------------------------------------- |
| `task-execution-prompt.md`  | Execute complex dev tasks step by step |
| `task-generation-prompt.md` | Generate actionable tasks from PRDs    |

---

## Task-to-Resource Quick Reference

| Task                           | Instruction                           | Skill                      | Agent             |
| ------------------------------ | ------------------------------------- | -------------------------- | ----------------- |
| Build Next.js + React + TS app | `nextjs+react+typescript.md`        | webcoder                   | architect         |
| Design responsive UI           | `typescript+react+shadcn-ui.md`     | web-design-reviewer        | se-ux-ui-designer |
| Test web app UI                | `react+js+tailwind.instructions.md` | webapp-testing             | clean-code        |
| Optimize Next.js SEO           | `nextjs-14-tailwind-seo-setup.md`   | seo-audit                  | architect         |
| Deploy Vercel + Supabase       | `nextjs+vercel+supabase.md`         | senior-fullstack           | architect         |
| Setup component library        | `daisyui.instructions.md`           | frontend-developer         | se-ux-ui-designer |
| Humanize AI-generated text     | —                                    | roviczzz-humanize          | —                |
| Strip slop from code           | —                                    | anti-slop                  | —                |
| Optimize web app perf          | —                                    | web-app-optimization       | architect         |
| C++ development                | —                                    | cpp-programming-guidelines | clean-code        |
| Shopify integration            | —                                    | —                         | shopify-export    |
| Debug systematically           | —                                    | systematic-debugging       | —                |

---

## Verify Installation

| Tool              | Check                                         |
| ----------------- | --------------------------------------------- |
| Copilot (VS Code) | Open Copilot chat — check `/agents` list   |
| OpenCode          | Skills load automatically on matching prompts |
| Cursor            | `@Agent` — verify rules are available      |
| Windsurf          | Cascade panel — confirm instructions visible |

**CLI check:**

```bash
ls ~/.copilot/agents && ls ~/.copilot/instructions && ls ~/.copilot/prompts && ls ~/.copilot/skills
```

---

## Troubleshooting

| Issue                     | Fix                                                     |
| ------------------------- | ------------------------------------------------------- |
| Config not loading        | Restart the IDE / tool                                  |
| No write permission       | Check `~/.copilot/` and target dir ownership          |
| Execution policy (Win)    | `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser` |
| Permissions (macOS/Linux) | `chmod +x install.sh && ./install.sh`                 |
| Skills not appearing      | Symlinks broken — re-run install for your tool         |

---

## Uninstallation

| Tool              | Command                                                                                   |
| ----------------- | ----------------------------------------------------------------------------------------- |
| Copilot (VS Code) | `rm -rf ~/.copilot/agents ~/.copilot/instructions ~/.copilot/prompts ~/.copilot/skills` |
| OpenCode          | `rm ~/.agents/skills/*` (remove symlinks)                                               |
| Cursor            | `rm -rf ~/.cursor/instructions`                                                         |
| Windsurf          | `rm -rf ~/.windsurf/instructions`                                                       |

---

## Support

For issues, updates, or contributions, visit the [agentic-dev repository](https://github.com/roviczzz/agentic-dev).

---

**Last Updated:** June 3, 2026
