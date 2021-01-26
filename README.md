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

The configuration file `config.lua` defines parameters like your default applications, modkeys or the look & feel of awesome.
Every parameter has a reasonable fallback value.
Without any configuration it should behave like the stock awesome rc.

The following table gives an overview of all configuration parameters:

| Name                      | Description                                           | Type   |
|:--------------------------|:------------------------------------------------------|:-------|
| `browser`                 | command to run the web browser                        | string |
| `filemanager`             | command to run the file manger                        | string |
| `gui_editor`              | command to run the gui editor                         | string |
| `terminal`                | command to run the terminal emulator                  | string |
| `lock_command`            | command to lock the current session                   | string |
| `altkey`                  | the alt key to use for key bindings                   | string |
| `modkey`                  | the mod key to use for key bindings                   | string |
| `theme`                   | theme to load                                         | string |
| `dynamic_tagging`         | enable dynamic tagging                                | bool   |
| `exitmenu`                | add exit menu to the wibar                            | bool   |
| `mainmenu`                | add the main menu to the wibar                        | bool   |
| `tasklist`                | behavior. set to 'windows' group similar clients      | string |
| `layouts`                 | overwrite default layout list                         | array  |
| `default_layout`          | index of default layout to use on new tags            | int    |
| `dpi`                     | set explicit dpi for every screen                     | int    |
| `auto_dpi`                | enable automatic calculation of the screen DPI        | bool   |
| `assets`                  | set custom theme assets ('recolor' or 'mac')          | string |
| `theme`                   | select theme                                          | string |
| `theme_overwrite`         | overwrite certain theme variables                     | table  |
| `wallpaper`               | path to your wallpaper or 'xfconf-query' to use xconf | string |
| `desktop`                 | select desktop elements ('arcs')                      | string |
| `desktop_widgets_visible` | show / hide desktop widgets                           | book   |
| `arc_widgets`             | widgets to be added to the desktop pop up             | array  |
| `wibar`                   | select wibar configuration ('default' or 'dual')      | string |
| `wibar_widgets`           | widgets to be added to the wibar                      | array  |
| `widgets_arg `            | configure widgets                                     | table  |

## Widget Parameters

Some widgets (`weather`, `temp`, `net`) require additional configuration.
The parameters for each widget are stored in a table under the key `widgets_arg` in the configuration.

A example configuration is shown in the following listing:

```lua
{
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
