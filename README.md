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

> Please refer to the [wiki](https://github.com/MArpogaus/awesome/wiki) for details on the configuration.

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
