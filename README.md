# Time-bomb.nvim


<table align="center"><tr><td>
	
![time-bomb](https://github.com/user-attachments/assets/b04d6da8-5215-4435-9ccd-203c967b2494)



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


<div align="center">
	
| ![Style "normal"](https://github.com/user-attachments/assets/8a28cc21-acd9-422d-9398-bc95d169c872) | ![Style "music"](https://github.com/user-attachments/assets/9f87bd14-a10e-400e-9f96-ab5040069654) |
|:--:|:--:|
| **Style "normal"** | **Style "music"** |

| ![Style "mama-lova"](https://github.com/user-attachments/assets/a052ee0a-c979-42de-b837-0d43e42bbcd1) | ![Style "fire"](https://github.com/user-attachments/assets/205a6f00-911a-4498-b834-4c83245e6b81) |
|:--:|:--:|
| **Style "mama-lova"** | **Style "fire"** |

| ![Style "dots"](https://github.com/user-attachments/assets/708eae07-d0a7-4570-b1d8-a3e22afde5ef) | ![Style "cyberpunk"](https://github.com/user-attachments/assets/a76237ac-cc4b-4758-8e00-640c0e82e7ff) |
|:--:|:--:|
| **Style "dots"** | **Style "cyberpunk"** |

</div>



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

### Full configuration (DEFAULT)

```lua
require("time-bomb").setup({
  enable_default_keymaps = true,
  

-- If you want overload with custom keymaps don't set enable_default_keymaps at false.
  keymaps = {
    timer_custom   = "<leader>tbc",  -- Custom timer
    pomodoro_start = "<leader>tbs",  -- Start Pomodoro
    stop_timer     = "<leader>tbe",  -- Stop timer
    pause_timer    = "<leader>tbp",  -- Pause/Resume
    next_timer     = "<leader>tbn",  -- Next cycle
    prev_timer     = "<leader>tbb",  -- Previous cycle
  },
  position = {
	layout = "top-right",            -- Options: bottom-right, top-left, bottom-left, top-right
	margin = { top = 1, right = 2 }, -- Margin for the popup
  },
  
  pomodoro_cycles = {
		{ title = "Work",        time = "25", style = "mama-lova" }, -- Time in minute*
		{ title = "Short-Break", time = "5",  style = "cyberpunk" },
		{ title = "Work",        time = "25", style = "fire" },
		{ title = "Short-Break", time = "5",  style = "dots" },
		{ title = "Work",        time = "25", style = "music" },
		{ title = "Long-Break",  time = "15", style = "normal" },
	},
  -- *Time must be upper than 1 min and less than 1440 min (1 day)
  timer_color = "lime",           -- lime, blue, black, gray, silver, white, fuchsia
  enable_notification = true,    -- System notifications
})
```

## 🎨 **Progress Bar Styles**

| Style | Aperçu (50%) | Width | Height | Description |
|-------|--------------|-------|--------|-------------|
| `normal` | `  12min30s` | 11 | 1 | Simple timer |
| `mama-lova` | `[❤️❤️❤️🩶🩶🩶🩶🩶🩶🩶]` | 22 | 2 | Hearts  ❤️🩶 |
| `cyberpunk` | `▐███░░░░░░░▌` | 20 | 2 | Futuristic neon |
| `fire` | `🟥🟥🟥🟥🟥⬜⬜⬜⬜⬜` | 20 | 1 | Gradient fire |
| `dots` | `●●●●●○○○○○` | 20 | 1 | Elegant dots |
| `music` | `♪♪♪♪♪.....` | 20 | 1 | Musical notes |

### **Cycle configuration :**

```lua
pomodorro_cycles = {
  { title = "work",       time = "25", style = "normal" },
  { title = "break",      time = "5",  style = "mama-lova" },
  { title = "work",       time = "25", style = "cyberpunk" },
  { title = "long-break", time = "15", style = "fire" },
}
```

### **Available styles :**

```
"normal", "mama-lova", "cyberpunk", "fire", "dots", "music"
```

## 🚀 Usage

### Commands

| Command                | Description                          |
|------------------------|--------------------------------------|
| `:TimeBomb timer [N]`  | Start custom **N-minute** timer      |
| `:TimeBomb pomodoro`   | Start **Pomodoro cycle**             |
| `:TimeBomb stop`       | **Stop** current timer               |
| `:TimeBomb pause`      | **Toggle** pause/resume              |
| `:TimeBomb next`       | Jump to **next cycle**               |
| `:TimeBomb prev`       | Jump to **previous cycle**           |

### Default Keymaps

```
<leader>tbc  → :TimeBomb timer      (Custom timer)
<leader>tbs  → :TimeBomb pomodoro   (Pomodoro start)  
<leader>tbe  → :TimeBomb stop       (Stop timer)
<leader>tbp  → :TimeBomb pause      (Pause/resume toggle)
<leader>tbn  → :TimeBomb next       (Next cycle)
<leader>tbb  → :TimeBomb prev       (Previous cycle)
```

**Examples:**
```vim
:TimeBomb timer 5        " 5-minute timer
:TimeBomb timer 25       " 25-minute work session  
:TimeBomb pomodoro       " Full cycle (25/5/25/5/25/15)
:TimeBomb pause          " Pause current timer
:TimeBomb next           " Skip to next cycle immediately
:TimeBomb prev           " Go back to previous cycle
:TimeBomb stop           " Emergency stop
```

**💡 Pro tip**: `:TimeBomb timer` without an argument opens an *input* for the duration.

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

<a href="https://dotfyle.com/plugins/Lachignol/time-bomb.nvim"><img src="https://dotfyle.com/plugins/Lachignol/time-bomb.nvim/shield" /></a>

MIT License - see [LICENSE](License) file.

***

**Made with ❤️ for Neovim developers**
