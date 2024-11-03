# Install (Windows):
```sh
powershell -c "irm https://raw.githubusercontent.com/Alixxx-please/passwd/master/install.ps1 | iex"`
```

# Possible arguments:
- `-l`: to set a custom password length (default: 48 characters)
- `-e`: to exclude any character from the password
- `upgrade`: to upgrade to the latest version
- `uninstall`: to properly uninstall passwd

# Usage:
Example command:
- `passwd`: will output a 48 characters long password with every letters, numbers and symbols
- `passwd -l 26 -e 01234abcedf-*/\!:`: will output a 26 characters long password without the excluded characters

Press any key to exit after the password is generated

Since it outputs only the password, it can be used as arguments for other commands.