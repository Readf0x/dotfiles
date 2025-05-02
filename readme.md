# INSTRUCTIONS
- Add host & user definitions in `hosts/flake-module.nix`, `hosts/<HOSTNAME>/`, & `hosts/<HOSTNAME>/<USERNAME>/`
- `sudo nixos-rebuild switch --flake . && home-manager switch --flake .`
- `init-home`
- Open Firefox ESR
    - Configure site data exceptions
    - Set extension settings
        - [Firefox color](https://color.firefox.com/?theme=XQAAAAIQAQAAAAAAAABBKYhm849SCia2CaaEGccwS-xMDPr5iE6wEt17lnFu4uAqMsdEr67G-WikpgIK6fEElOKhOM86V0bBVjYWaEH1zRPWtF1_4JdEdbOk0mEdIjD4j2vHLbCcu-E5Ro0uYzZqFcqly5WlTsaEpUlMaVtGYhMZXBOFCW1L3uQHq-kEj3mp-uFzAureYlw6aUpL_fMfraA)
        - [YouTube enhancer](./settings/yt-ehancer.json)
        - [Vimium](./settings/vimium-options.json)

