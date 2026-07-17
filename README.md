# Samaritan Theme

A minimal and simple sddm theme inspired by Samaritan from the CBS television show "Person of Interest", the basis of the theme was taken from the [Void SDDM Theme](https://github.com/talyamm/VoidSDDM) built by [talyamm](https://github.com/talyamm). So big credit to him,
go support his project too if you like this.

https://github.com/user-attachments/assets/4ed55303-bb48-4a4c-9c4a-4141624bdf30



## Features

- System loading sequence
- Animated Samaritan promot with password feedback
- System status panel showing real system information like hostname and cpu
- System profile containing both real and fictional stats 
- Configurable colors and fonts 
- Dark and light mode support

### Planned

- Option to turn off boot sequence



## Keyboard shortcuts

- Arrow keys: Navigation
- Enter: Select option or authenticate
- F2: Toggle password visibility
- F10: Suspend
- F11: Shutdown
- F12: Reboot



## Installation
Currently i am only providing a manual installation method since my install.sh script is not yet complete and might not work properly. I will add it as a method when I feel it becomes more complete and reliable to use.

### Method 1: Manual installation

```bash
git clone https://github.com/omerwk/samaritan-sddm-theme.git samaritan/
```

#### Copy theme to the sddm theme directory

```bash
sudo cp -r samaritan /usr/share/sddm/themes/
```

#### Edit the sddm config

```bash
sudo nano /etc/sddm.conf
```
```ini
[Theme]
Current=samaritan
```

### Preview the theme

You can preview the theme without having to logout by running:

```bash
sddm-greeter --test-mode --theme /usr/share/sddm/samaritan
```



## Customization

###  Dark and light mode

To switch between the default dark mode and the optional light mode, edit the following line 
in metadata.desktop:

```ini
ConfigFile=presets/dark.conf
```

Use presets/dark.conf for dark mode or presets/light.conf for light mode.


### Colors and font

Every color and font is configurable through the active preset (dark.conf or light.conf).
Each option has comments to explain what it controls. Leave a value empty 
to use the default.


### Animations

As of now you can't really customize the animations too much through the .conf files, might be 
changed in the future if there is enough interest.


### Other

Other things like the mouse cursor, password visibility indicator, keyboard shortcut helper and more
can be individually toggled on or off. 


## Inspiration

This project tries to recreate the visual style of the **Samaritan** artificial intelligence from the television series **Person of Interest**.

it is **not** intended to be an exact replica, but more of a faithful interpretation adapted to an sddm login screen.

it is also important for me to make it clear that most of the code in this project was taken from [Void SDDM Theme](https://github.com/talyamm/VoidSDDM) and also written with the assistance of an AI (how ironic). So I am sorry if you are against that, but I hope that you can enjoy this nonetheless.


## Requirements

- SDDM
- Qt6


