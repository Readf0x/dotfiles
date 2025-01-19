{ ... }: {
  programs.kitty.extraConfig = ''
    enable_audio_bell no
    visual_bell_duration 0.1
    visual_bell_color #3a2828

    disable_ligatures never
    font_family family="Maple Mono NF" features="+zero +cv03 +ss03"
    font_size 11
    symbol_map U+2320,U+2321,U+239B-U+23B3 Noto Sans Math

    window_padding_width 15

    map ctrl+minus change_font_size all -0.5
    map ctrl+equal change_font_size all +0.5
  '';
}
