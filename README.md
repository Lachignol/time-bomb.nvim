# Time-bomb.nvim


<table align="center"><tr><td>
	
![time-bomb](https://github.com/user-attachments/assets/efce3620-723a-404b-a600-ac82aad09b71)


</td></tr></table>

<p align="center">
<strong>A minimal Neovim plugin for timers and Pomodoro cycles, designed to help you stay focused.</strong>
</p>


## ✨ **Features**

- ⏰ **Custom timers** with floating window display
- 🍅 **Pomodoro cycles** (25/5/25/5/25/15) with automatic progression
- 📊 **Progress bars** (6 styles available)
- 🎨 **Customizable colors** (lime, blue, fuchsia, etc.)
- 📱 **Auto-reposition** after resize
- ⏸️ **Pause/resume** functionality
- 🔄 Cycle navigation (Next/Prev)
- ⌨️ **Configurable keymaps** (`<leader>tb*`)
- 🩺 **Health check** (`:checkhealth time-bomb`)

## 📷 Screenshots

### Style "normal"

<img width="2544" height="1356" alt="style_normal" src="https://github.com/user-attachments/assets/aa02bdc8-cc41-4dc2-81bd-88b76a0a127b" />

### Style "mama-lova"
<img width="2544" height="1356" alt="style_mama_lova" src="https://github.com/user-attachments/assets/5852821c-1a7d-4377-84c1-aae4ccf4d4e6" />

## 📦 Installation

### lazy.nvim

```lua
{
  "Lachignol/time-bomb.nvim",
  config = function()
    require("time-bomb").setup({
      enable_default_keymaps = true,
      timer_color = "lime",
    })
  end,
}
```

### packer.nvim

```lua
use {
  "Lachignol/time-bomb.nvim",
  config = function()
    require("time-bomb").setup()
  end
}
```

### vim.pack

```lua

vim.pack.add({{src = "https://github.com/Lachignol/time-bomb.nvim"}})


require("time-bomb").setup({
	enable_default_keymaps = true,
	timer_color = "lime",
})
```

## ⚙️ Configuration

### Minimal setup

```lua
require("time-bomb").setup({
  enable_default_keymaps = true,
  timer_color = "lime",
})
```

### Full configuration


```lua
require("time-bomb").setup({
  enable_default_keymaps = true,
  
  keymaps = {
    timer_custom   = "<leader>tbc",  -- Custom timer
    pomodoro_start = "<leader>tbs",  -- Start Pomodoro
    stop_timer     = "<leader>tbe",  -- Stop timer
    pause_timer    = "<leader>tbp",  -- Pause/Resume
    next_timer     = "<leader>tbn",  -- Next cycle
    prev_timer     = "<leader>tbb",  -- Previous cycle
  },
  
  pomodoro_cycles = {
    { title = "Work",       time = "25", style = "normal" },
    { title = "Short Break",time = "5",  style = "mama-lova" },
    { title = "Work",       time = "25", style = "normal" },
    { title = "Short Break",time = "5",  style = "mama-lova" },
    { title = "Work",       time = "25", style = "normal" },
    { title = "Long Break", time = "15", style = "normal" },
  },
  
  timer_color = "lime",           -- lime, blue, black, gray, silver, white, fuchsia
  enable_notification = false,    -- System notifications
  enable_confirmation = false,    -- Confirmation before next cycle
})
```

## 🎨 **Progress Bar Styles**

| Style | Aperçu (50%) | Width | Height | Description |
|-------|--------------|-------|--------|-------------|
| `normal` | `  12min30s` | 11 | 1 | Timer simple |
| `mama-lova` | `[❤️❤️❤️🩶🩶🩶🩶🩶🩶🩶]` | 22 | 2 | Cœurs ❤️🩶 |
| `cyberpunk` | `▐███░░░░░░░▌` | 20 | 2 | Néon futuriste |
| `fire` | `🟥🟥🟥🟥🟥⬜⬜⬜⬜⬜` | 20 | 1 | Feu gradient |
| `dots` | `●●●●●○○○○○` | 20 | 1 | Points élégants |
| `music` | `♪♪♪♪♪.....` | 20 | 1 | Notes musicales |

### **Configuration des cycles :**

```lua
pomodorro_cycles = {
  { title = "work",       time = "25", style = "normal" },
  { title = "break",      time = "5",  style = "mama-lova" },
  { title = "work",       time = "25", style = "cyberpunk" },
  { title = "long-break", time = "15", style = "fire" },
}
```

### **Styles disponibles :**

```
"normal", "mama-lova", "cyberpunk", "fire", "dots", "music"
```

## 🚀 Usage

### Commands

| Command       | Description                          |
|---------------|--------------------------------------|
| `:Timer [N]`  | Start custom **N-minute** timer      |
| `:Pomodoro`   | Start **Pomodoro cycle**             |
| `:StopTimer`  | **Stop** current timer               |
| `:PauseTimer` | **Toggle** pause/resume              |
| `:NextCycle`  | Jump to **next cycle**               |
| `:PrevCycle`  | Jump to **previous cycle**           |

### Default Keymaps

```
<leader>tbc  → :Timer      (Custom timer)
<leader>tbs  → :Pomodoro   (Pomodoro start)  
<leader>tbe  → :StopTimer  (Stop timer)
<leader>tbp  → :PauseTimer (Pause/resume toggle)
<leader>tbn  → :NextCycle  (Next cycle)
<leader>tbb  → :PrevCycle  (Previous cycle)
```

**Examples:**
```vim
:Timer 5        " 5-minute timer
:Timer 25       " 25-minute work session  
:Pomodoro       " Full cycle (25/5/25/5/25/15)
:PauseTimer     " Pause current timer
:NextCycle      " Skip to next cycle immediately
:PrevCycle      " Go back to previous cycle
:StopTimer      " Emergency stop
```

**💡 Pro tip**: `:Timer` sans argument ouvre une **input** pour la durée.

## 📖 Documentation

```
:help time-bomb
:checkhealth time-bomb
```

## 🤝 Contributing

Contributions welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Submit a Pull Request

## 📄 License

![Neovim](https://img.shields.io/badge/Neovim-0.8+-green.svg)

![Lua](https://img.shields.io/badge/Lua-5.1+-blue.svg)

![License](https://img.shields.io/badge/license-MIT-orange.svg)

MIT License - see [LICENSE](License) file.

***

**Made with ❤️ for Neovim developers**
