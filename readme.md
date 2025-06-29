# INSTRUCTIONS
- Add host & user definitions in `hosts/flake-module.nix`, `hosts/<HOSTNAME>/`, & `hosts/<HOSTNAME>/<USERNAME>/`
- `sudo nixos-rebuild switch --flake . && home-manager switch --flake .`
- run `init`
- Open Firefox ESR
    - Configure site data exceptions
    - Configure UI layout
    - Set extension settings
        - Connect Keepassxc
        - [YouTube enhancer](./settings/yt-ehancer.json)
        - [Vimium](./settings/vimium-options.json)
        - [Sidebery Styling](./settings/sidebery.css)

