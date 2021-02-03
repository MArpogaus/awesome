[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![GNU GPLv3 License][license-shield]][license-url]

<!-- markdown-toc start - Don't edit this section. Run M-x markdown-toc-refresh-toc -->
**Table of Contents**

- [About](#about)
- [Used libraries](#used-libraries)
- [Installation](#installation)
    - [Optional: Install Fonts](#optional-install-fonts)
- [Configuration](#configuration)
    - [Key bindings](#key-bindings)
    - [Widget Parameters](#widget-parameters)
- [License](#license)

<!-- markdown-toc end -->

# About

This is my [awesome][awesome] configuration.

# Used libraries

The following libraries are used:

 * [vicious][vicious] - widget library for the wibar and desktop widgets
 * [revelation][revelation] - Mac OSX like 'Expose' view of all clients. 

They are included as git subtrees in the root of this repository.

# Installation

This configuration requires [awesome v4.3][awesome].

 1. Backup your current awesome configuration
    ```shell
    mv $HOME/.config/awesome $HOME/.config/awesome_$(date -I)
    ```

 2. Clone my configuration to `~/.config/awesome/`
    ```shell
    git clone --recursive https://github.com/MArpogaus/awesome-rc.git $HOME/.config/awesome 
    ```

## Optional: Install Fonts

The configuration uses [Font Awesome 4][font-awesome4] for widget and tag icons and [owfont][owfont] for weather icons.
If you want to use this functionality, make sure to install them on your system.

 1. Install [Font Awesome 4][font-awesome4]
    ```shell
    # Debian / Ubuntu
    apt install fonts-font-awesome 
    # Manjaro
    pamac build ttf-font-awesome-4
    ```
 
 1. Download and install [owfont][owfont]
    ```shell
    wget -O ~/.local/share/owfont-regular.ttf 'https://github.com/websygen/owfont/blob/master/fonts/owfont-regular.ttf?raw=true'
    ```

 1. Update font cache
    ```shell
    fc-cache -v
    ```

# Configuration

You can use the provided template to create your initial configuration file:

```shell
cd $HOME/.config/awesome 
cp config.lua.tmpl config.lua
``` 

The configuration file `config.lua` defines parameters like your default applications, modkeys, the look & feel of awesome, keybindings etc.
Every parameter has a reasonable fallback value defined in `rc/defaults.lua`.
Without any configuration it should behave like the stock awesome rc.

The following table gives an overview of all configuration parameters:

| Name                      | Description                                           | Type   | Default                     |
|:--------------------------|:------------------------------------------------------|:------:|:----------------------------|
| `browser`                 | command to run the web browser                        | string | 'firefox'                   |
| `gui_editor`              | command to run the gui editor                         | string | 'nano'                      |
| `filemanager`             | command to run the file manger                        | string | 'thunar'                    |
| `terminal`                | command to run the terminal emulator                  | string | 'xterm'                     |
| `lock_command`            | command to lock the current session                   | string | 'light-locker-command -l'   |
| `altkey`                  | the alt key to use for key bindings                   | string | 'Mod1'                      |
| `modkey`                  | the mod key to use for key bindings                   | string | 'Mod4'                      |
| `key_bindings`            | the keybindings to load                               | array  | {'default'}                 |
| `bind_numbers_to_tags`    | bind number keys 0-9 to the corresponding tags        | book   | true                        |
| `dynamic_tagging`         | enable dynamic tagging                                | bool   | nil                         |
| `exitmenu`                | add exit menu to the wibar                            | bool   | nil                         |
| `mainmenu`                | add the main menu to the wibar                        | bool   | true                        |
| `tasklist`                | behavior. set to 'windows' group similar clients      | string | 'default'                   |
| `layouts`                 | overwrite default layout list                         | array  | see rc.defaults             |
| `default_layout`          | index of default layout to use on new tags            | int    | 0                           |
| `dpi`                     | set explicit dpi for every screen                     | int    | nil                         |
| `auto_dpi`                | enable automatic calculation of the screen DPI        | bool   | true                        |
| `assets`                  | set custom theme assets ('recolor' or 'mac')          | string | nil                         |
| `theme`                   | theme to load                                         | string | 'default'                   |
| `theme_overwrite`         | overwrite certain theme variables                     | table  | nil                         |
| `wallpaper`               | path to your wallpaper or 'xfconf-query' to use xconf | string | nil                         |
| `desktop`                 | select desktop elements ('arcs')                      | string | nil                         |
| `desktop_widgets_visible` | show / hide desktop widgets                           | book   | true                        |
| `arc_widgets`             | widgets to be added to the desktop pop up             | array  | {'cpu', 'mem', 'fs', 'vol'} |
| `wibar`                   | select wibar configuration ('default' or 'dual')      | string | 'default'                   |
| `wibar_widgets`           | widgets to be added to the wibar                      | array  | {'cpu', 'mem', 'fs', 'vol'} |
| `widgets_arg `            | configure widgets                                     | table  | {}                          |

## Key bindings

The definition of keybindings has been abstracted into two separate tables:

* the `keys` table defines the "actual" keybindings
* the `actions` table holds the function that should be triggered when the corresponding keys are pressed.

Keybindings can be separated in different modules.
This allows easy modification and extension of keybindings.

Keybindings are controlled through the `key_bindings` parameter.
It expects a list of folders containing the two lua modules for keys and actions and searches for them first in `~/.config/awesome/config` and then in `~/.config/awesome/rc`.
If no folder is found it is ignored, *without an error message*.
All the given modules are loaded and merged together, this allows you to overload or extend the keybindings easily.

This configuration comes with two sets of keybindings:

* `default` keybindings taken from the stock rc.lua
* `extra` keybindings to extend the default ones

**Note:** Make sure to load the `extra` keybindings after the default ones, otherwise all the default commands wont work: `{'defaults', 'extra'}`

Do not alter the keybindings in the `rc` folder directly, instead put them in `$HOME/.config/awesome/config`.
You can copy the default ones as a starting point:

``` shell
cd $HOME/.config/awesome/
mkdir -p config/key_bindings/my_keys
cp rc/key_bindings/default/* config/key_bindings/my_keys
```

Then apply your changes and add `'my_keys'` to `key_bindings` in your configuration file.

**Note:** Keybindings get merged, so you can omit everything defined inside the keybindings loaded beforehand i.e.: `{'defaults', 'my_keys'}` would extend / overload the default keys.

## Widget Parameters

Some widgets (`weather`, `temp`, `net`) require additional configuration.
The parameters for each widget are stored in the table `widgets_arg` in the configuration file.

A example configuration is shown in the following listing:

```lua
widgets_arg = {
    weather = {
        -- Your city for the weather widget
        city_id = '2643743',
        app_id = '4c57f0c88d9844630327623633ce269cf826ab99'
    },
    temp = {
        -- Set resource for temperature widget
        thermal_zone = 'thermal_zone0'
    },
    net = {
        -- Network interface
        net_interface = 'eth0'
    }
}
```

The following table gives an overview of all widget parameters:

| Name            | Description                                                                                                    | Type   |
|:----------------|:---------------------------------------------------------------------------------------------------------------|:-------|
| `city_id`       | open weather map id of your city. Find it here: https://openweathermap.org/find?q=                             | string |
| `app_id`        | open weather map API key. Sign up here: https://home.openweathermap.org/users/sign_up                          | string |
| `thermal_zone`  | resource for temperature widget: https://vicious.readthedocs.io/en/latest/widgets.html#vicious-widgets-thermal | string |
| `net_interface` | network interface to monitor: https://vicious.readthedocs.io/en/latest/widgets.html#vicious-widgets-net        | string |

# License

Copyright (C) 2021 Marcel Arpogaus

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

[awesome]: https://awesomewm.org/
[vicious]: https://github.com/vicious-widgets/vicious
[revelation]: https://github.com/guotsuan/awesome-revelation
[owfont]: http://websygen.github.io/owfont/
[font-awesome4]: https://github.com/FortAwesome/Font-Awesome
[contributors-shield]: https://img.shields.io/github/contributors/MArpogaus/awesome.svg?style=for-the-badge
[contributors-url]: https://github.com/MArpogaus/awesome/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/MArpogaus/awesome.svg?style=for-the-badge
[forks-url]: https://github.com/MArpogaus/awesome/network/members
[stars-shield]: https://img.shields.io/github/stars/MArpogaus/awesome.svg?style=for-the-badge
[stars-url]: https://github.com/MArpogaus/awesome/stargazers
[issues-shield]: https://img.shields.io/github/issues/MArpogaus/awesome.svg?style=for-the-badge
[issues-url]: https://github.com/MArpogaus/awesome/issues
[license-shield]: https://img.shields.io/github/license/MArpogaus/awesome.svg?style=for-the-badge
[license-url]: https://github.com/MArpogaus/awesome/blob/master/COPYING
