# Samaritan sddm Theme

A minimal and simple sddm theme inspired by Samaritan from the CBS show "Person of Interest", the foundation of the theme was taken from the [Void SDDM Theme](https://github.com/talyamm/VoidSDDM) built by [talyamm](https://github.com/talyamm). So big credit to him,
go like his project too if you like this.

https://github.com/user-attachments/assets/4ed55303-bb48-4a4c-9c4a-4141624bdf30



## Features

- System loading sequence
- Animated Samaritan promot with password feedback
- System status panel showing real system information like hostname and cpu
- System profile containing both real and fictional stats 
- Configurable colors and fonts through theme.conf

### Planned

- Optional light mode



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


