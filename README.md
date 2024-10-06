# My dotfiles for [ClockworkPi uConsole](https://www.clockworkpi.com/uconsole)

Uses [chezmoi](https://www.chezmoi.io/) to manage dotfiles

## <a name="chezmoi-data">chezmoi data</a>

The first time you run `chezmoi apply`, it will prompt for some information

|Data|Explanation|
|-|-|
|Full name|Your full name, used to set `user.name` in gitconfig|
|Bitbucket email|Your [Bitbucket](https://bitbucket.org/) email address, used to set `user.email` in gitconfig when the repository remote is `bitbucket.org`|
|Bitbucket subdomain|Your [Bitbucket](https://bitbucket.org/) subdomain (e.g. `https://bitbucket.org/subdomain`), used to populate the commit message template when the repository remote is `bitbucket.org`|
|Github private email|Your [Github](https://github.com/) private email address, used to set `user.email` in gitconfig when the repository remote is `github.com`. To find your private email address, go to https://github.com/settings/emails|

## Setup steps
1. Flash [ClockworkPi bookworm](https://forum.clockworkpi.com/t/bookworm-6-6-y-for-the-uconsole-and-devterm/13235) (or latest) Lite OS to MicroSD card
1. Boot up with MicroSD card
    - It will boot twice. The first time to resize the partition
    - Unplug any USB cables. Otherwise, it may stall with a watchdog error. If so, just wait, it will eventually (after 10 mins) reboot
1. Set up username (`admin`) and password
1. Login as `admin`
1. Set bigger font: `sudo vi /etc/default/console-setup`
    - Change `FONTFACE` to `Terminus`
    - Change `FONTSIZE` to `14x28`
    - *Reference*: https://manpages.ubuntu.com/manpages/bionic/man5/console-setup.5.html
1. Fix keyboard layout: `sudo vi /etc/default/keyboard`
    - Change `XKBLAYOUT` to `us`
    - *Reference*: https://manpages.ubuntu.com/manpages/bionic/man5/keyboard.5.html
1. Reboot: `sudo reboot`
1. Set up Wi-Fi
    1. Get the device name: `nmcli` - probably `wlan0`
    1. Configure wi-fi: `nmcli d wifi connect '<ssid>' password '<password>' ifname <device>`
       - Test: `curl http://google.com` - should return a `301` redirect
       - *Reference*: https://joshtronic.com/2023/06/11/how-to-connect-to-wi-fi-from-the-command-line-on-debian/
1. Set up SSH
    1. `sudo raspi-config`
    1. Choose: 3 Interface Options > 11 SSH > Enable > Finish
        - **NOTE**: Can perform the remaining steps over SSH
1. Set up locale
    1. `sudo raspi-config`
    1. Choose: 5 Localisation Options > L1 locale
    1. Check `en_US.UTF-8`. Choose **OK**
    1. Select `en_US.UTF-8` as default. Choose **OK**
1. Set up time zone:
    1. `sudo raspi-config`
    1. Choose: 4 Localisation Options > L2 Timezone
    1. Select `US`. Choose **OK**
    1. Select `Pacific Ocean`. Choose **OK**
1. Add non-admin user: `sudo adduser <username>`
1. Add user to sudo and systemd-journal groups: `sudo usermod -aG sudo,systemd-journal <username>`
    - Test: `groups <username>` - should return `sudo` and `systemd-journal`
1. Login as `<username>`
1. Install [chezmoi](https://www.chezmoi.io/install/) 
    1. Find the latest `arm64` package here: https://www.chezmoi.io/install/#download-a-pre-built-linux-package
    1. Download the package: `wget https://github.com/twpayne/chezmoi/releases/download/v2.52.1/chezmoi_2.52.1_linux_arm64.deb`
    1. Install git: `sudo apt update -yq && sudo apt install -yq git`
    1. Install chezmoi: `sudo dpkg -i chezmoi_2.52.1_linux_arm64.deb && rm chezmoi_2.52.0_linux_arm64.deb`
    1. Initialize and apply chezmoi
        1. Step-by-step (recommended)
            1. Initialize: `chezmoi init git@github.com:jllacuna/uconsole-dotfiles.git` - Will prompt for info (see [chezmoi data](#chezmoi-data))
            1. Preview the changes (*optional*): `chezmoi diff`
            1. Apply the changes: `chezmoi apply 2>&1 | tee ~/chezmoi.log` - saves output to `~/chezmoi.log`
                - ***WARNING***: Do this on device in case SSH gets disconnected
        1. **- or -** All-in-one (only use with a validated stable configuration)
            1. `chezmoi init --apply git@github.com:jllacuna/uconsole-dotfiles.git` - Will prompt for info (see [chezmoi data](#chezmoi-data))
                - ***WARNING***: Do this on device in case SSH gets disconnected
1. Change default shell to `zsh`: `chsh -s $(which zsh)`
1. Reboot: `sudo reboot`
1. Start up neovim to let it install plugins, lsp servers, and treesitter parsers: `e`
    - Check plugin installs: `:Lazy`
    - Check LSP server installs: `:Mason`
    - Check neovim health: `:checkhealth` - make sure there are no `ERROR` lines
