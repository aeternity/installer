# Install Aeternity node on Windows using the Windows Subsystem Linux

NOTE: These steps describe the setup for a basic CPU mining configuration.
      Windows Subsystem Linux has no GPU-passthrough support yet. Therefore,
      a native Windows setup will be required to leverage GPU mining.

## Prerequisites

- An up-to-date Windows 10 installation which supports Windows Subsystem linux
- A working Microsoft Store
- PowerShell (which usually comes with Windows 10)
- Execution of unsigned PowerShell scripts must be allowed.
  This can usually be achieved by running `Set-ExecutionPolicy -ExecutionPolicy Unrestricted`.
  Read [Microsoft TechNet](https://technet.microsoft.com/en-us/library/bb613481.aspx)
  for more information

## Step 1: Get helper scripts

The helper scripts are located in the `/` folder in the `installer` Git repository.
You may download the whole repository by

1. Downloading the [Git repository](https://github.com/aeternity/installer) itself;
2. Or downloading and unpacking a
   [Zip archive](https://github.com/aeternity/installer/archive/master.zip)
   provided by Github.

Alternatively, you can also download the individual scripts:

- `windows/setup-wsl.ps1`
- `windows/wsl-run.ps1`
- `install.sh`
