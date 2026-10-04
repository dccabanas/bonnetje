# Bonnetje

A collection of utilities for EPSON thermal printers, specifically models in the
TM series. Provides CUPS drivers and a Rust binary to send print jobs to a
printer.

## Installation

### Drivers

The recommend way to use the drivers is to install them into your system
configuration. First, add the inputs to your `flake.nix`
```nix
#...
inputs.bonje.url = github:dccabanas/bonnetje;
#...
```
and inside your configuration add
```nix
#...
services.printing = {
  enable = true;
  drivers = [
    inputs.bonje.packages.${pkgs.system}.epson-drivers
  ];
};
#...
```
Finally, switch to the new configuration with
```bash
sudo nixos-rebuild switch --flake path/to/your/config
```
To confirm the installation you can run 
```bash
lpinfo -m | grep -i epson
```
and you should see the following entries listed:
```
EPSON/tm-ba-thermal-rastertotmtr-180.ppd EPSON TM Thermal (180dpi)
EPSON/tm-ba-thermal-rastertotmtr-203.ppd EPSON TM Thermal (203dpi)
```

You can also build the drivers locally by running
```nix
nix build
```
and you will get
```
result/
├── lib/
│   └── cups/
│       └── filter/
│           └── rastertotmtr
└── share/
    └── cups/
        └── model/
            └── EPSON/
                ├── tm-ba-thermal-rastertotmtr-180.ppd
                └── tm-ba-thermal-rastertotmtr-203.ppd
```

### Crate

The Rust binary can be compiled with
```
nix build .#bonnetje
```

This already includes packages needed to compile the Rust crate, such as `pkg-config` and
`libudev-zero`.

## Usage

For now, the Rust binary is only a wrapper for
[escpos-rs](https://github.com/fabienbellanger/escpos-rs), so you can find the documentation
there.

## Acknowledgements

This original idea for this project was taken from
[here](https://git.inx.moe/Infinidoge/receipts).
The main differences here are the use of flakes and a different set of drivers.

The Rust crate builds upon [escpos-rs](https://github.com/fabienbellanger/escpos-rs) with
some niche utilities I wanted.

## License

[MIT](LICENSE)
