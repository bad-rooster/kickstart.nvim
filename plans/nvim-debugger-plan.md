# Best-in-Class Neovim Python Debugger

## Overview

Create `/Users/ayn/.config/nvim/lua/custom/plugins/debugger.lua` — auto-discovered by lazy.nvim via the existing `{ import = 'custom.plugins' }` at `init.lua:1037`. No changes to `init.lua` or the existing (disabled) `debug.lua`.

---

## Plugins

| Plugin | Role |
|--------|------|
| `mfussenegger/nvim-dap` | DAP core protocol client |
| `rcarriga/nvim-dap-ui` | Sidebar panels: scopes, watches, stack, breakpoints, REPL, console |
| `nvim-neotest/nvim-nio` | Required async lib for nvim-dap-ui |
| `mason-org/mason.nvim` | Declared as dep for load order (already installed); registry API used to ensure `debugpy` is installed |
| `mfussenegger/nvim-dap-python` | Python configs + pytest method/class debug support |
| `theHamsta/nvim-dap-virtual-text` | Inline variable values shown at end of each line |
| `nvim-telescope/telescope-dap.nvim` | Telescope pickers for configs, breakpoints, frames, variables |

---

## Plugin Maintenance Assessment

**Tier 1 — Solid, actively maintained**

| Plugin | Assessment |
|--------|-----------|
| `mfussenegger/nvim-dap` | ~7k stars, commits as recent as hours ago, the de-facto standard. mfussenegger is a Neovim core contributor. Very trustworthy. |
| `mfussenegger/nvim-dap-python` | Same author as nvim-dap. Mirrored from Codeberg. Actively maintained alongside the core. |
| `mason-org/mason.nvim` | The `mason-org` org is the official successor to the original `williamboman` repo — handed off intentionally. Very active, used by nearly every Neovim distro. |
| `nvim-neotest/nvim-nio` | Maintained by the neotest org, a well-funded community project. Required by nvim-dap-ui and actively kept up. |

**Tier 2 — Healthy but slower pace**

| Plugin | Assessment |
|--------|-----------|
| `rcarriga/nvim-dap-ui` | ~3k stars, issues open through Jan 2026. Stable and widely used; no signs of abandonment. |
| `theHamsta/nvim-dap-virtual-text` | Moderately active single-author project. Small and self-contained — low update frequency is not a red flag here. |

**Tier 3 — Watch closely**

| Plugin | Assessment |
|--------|-----------|
| `nvim-telescope/telescope-dap.nvim` | Lives in the nvim-telescope org (good sign), but sees minimal updates. Least essential of the seven — easily dropped. |

---

## Configuration Details

### Mason adapter (DIY — no bridge plugin)
```lua
local registry = require('mason-registry')
registry.refresh(function()
  local pkg = registry.get_package('debugpy')
  if not pkg:is_installed() then
    pkg:install()
  end
end)
-- installs to: ~/.local/share/nvim/mason/packages/debugpy/venv/bin/python
```

### Python adapter setup
```lua
require('dap-python').setup(
  vim.fn.stdpath('data') .. '/mason/packages/debugpy/venv/bin/python'
)
-- auto-detects VIRTUAL_ENV, CONDA_PREFIX, venv/.venv/env folders
```

### Breakpoint icons (nerd fonts enabled)
```lua
-- Breakpoint = ''  BreakpointCondition = ''  LogPoint = ''  Stopped = ''
-- DapBreak highlight: red   DapStop highlight: yellow
```

### Virtual text
```lua
require('nvim-dap-virtual-text').setup {
  commented = false,
  highlight_changed_variables = true,
  show_stop_reason = true,
  virt_text_pos = 'eol',
}
```

### dap-ui layout
- Left column: scopes + stack frames
- Right column: watches + breakpoints list
- Bottom: REPL + console
- Auto-opens on session init, auto-closes on terminate/exit

---

## Keymaps

`<leader>d` group registered with which-key:

| Key | Action |
|-----|--------|
| `<F5>` | Continue / Start session |
| `<F1>` | Step Into |
| `<F2>` | Step Over |
| `<F3>` | Step Out |
| `<F7>` | Toggle dap-ui panels |
| `<leader>db` | Toggle breakpoint |
| `<leader>dB` | Conditional breakpoint (prompts for expression) |
| `<leader>dl` | Log point (prompts for message) |
| `<leader>dr` | Toggle REPL |
| `<leader>dt` | Terminate session |
| `<leader>ds` | Telescope: pick debug configuration |
| `<leader>dp` | Telescope: list breakpoints |
| `<leader>df` | Telescope: list/jump frames |
| `<leader>dv` | Telescope: list variables |
| `<leader>dm` | Debug nearest test method (nvim-dap-python) |
| `<leader>dM` | Debug nearest test class (nvim-dap-python) |

---

## Verification Checklist

- [ ] Open `.py` file, press `<leader>db` → breakpoint icon appears in sign column
- [ ] Press `<F5>` → dap-ui panels open, stops at breakpoint
- [ ] Variable values appear as virtual text at end of line
- [ ] `<leader>ds` → Telescope picker shows available debug configs
- [ ] `<leader>dm` inside a pytest function → debugs that test only
- [ ] `<leader>dt` → session terminates, UI closes automatically

---

## Files Changed

| File | Change |
|------|--------|
| `lua/custom/plugins/debugger.lua` | **Create** (new) |
| `init.lua` | No change |
| `lua/kickstart/plugins/debug.lua` | No change (stays disabled) |
