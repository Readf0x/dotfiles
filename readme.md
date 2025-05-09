# INSTRUCTIONS
- Add host & user definitions in `hosts/flake-module.nix`, `hosts/<HOSTNAME>/`, & `hosts/<HOSTNAME>/<USERNAME>/`
- `sudo nixos-rebuild switch --flake . && home-manager switch --flake .`
- `init-home`
- Open Firefox ESR
    - Configure site data exceptions
    - Configure UI layout
    - Set extension settings
        - Connect Keepassxc
        - [Firefox color](https://color.firefox.com/?theme=XQAAAAIQAQAAAAAAAABBKYhm849SCia2CaaEGccwS-xMDPr9KfClJ4RswZ3ISmP_g7wOWoErLc32NRyBiE4RK6WXhrWWkHiSpOpYg-ZwKW5pPoh8rqGGLa9XesCuzXG4M8_NHqP77A51iTW0Fz8Ux6E6tVfb64pda5jV0ZJLdIqAc2xeJeGk0YF1fhxE28-AylzKYc1E9pa-r8_31-u8opr_6J0OAA)
        - [YouTube enhancer](./settings/yt-ehancer.json)
        - [Vimium](./settings/vimium-options.json)
        - [Sidebery Styling](./settings/sidebery.css)

