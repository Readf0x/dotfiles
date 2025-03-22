{ pkgs, ... }: {
  # darkreader.enable = true;
  # extraExtensions = let
  #   latest = addon_id: "https://addons.mozilla.org/firefox/downloads/latest/${addon_id}/latest.xpi";
  # in {
  #   "{36bdf805-c6f2-4f41-94d2-9b646342c1dc}".install_url = latest "export-cookies-txt";
  #   "{74145f27-f039-47ce-a470-a662b129930a}".install_url = latest "clearurls";
  #   "{b86e4813-687a-43e6-ab65-0bde4ab75758}".install_url = latest "localcdn-fork-of-decentraleyes";
  #   "DontFuckWithPaste@raim.ist".install_url = latest "don-t-fuck-with-paste";
  #   "{531906d3-e22f-4a6c-a102-8057b88a1a63}".install_url = latest "single-file";
  #   "skipredirect@sblask".install_url = latest "skip-redirect";
  #   "7esoorv3@alefvanoon.anonaddy.me".install_url = latest "libredirect";
  #   "moz-addon-prod@7tv.app".install_url = "https://extension.7tv.gg/v3.0.9/ext.xpi";
  #   "gdpr@cavi.au.dk".install_url = latest "consent_o_matic";
  #   "enhancerforyoutube@maximerf.addons.mozilla.org".install_url = latest "enhancer-for-youtube";
  #   "keepassxc-browser@keepassxc.org".install_url = latest "keepassxc-browser";
  #   "mouse-pinch-to-zoom@niziolek.dev".install_url = latest "mouse-pinch-to-zoom";
  #   "new-window-without-toolbar@tkrkt.com".install_url = latest "new-window-without-toolbar";
  #   "{9063c2e9-e07c-4c2c-9646-cfe7ca8d0498}".install_url = latest "old-reddit-redirect";
  #   "jid1-MnnxcxisBPnSXQ@jetpack".install_url = latest "privacy-badger17";
  #   "jid1-xUfzOsOFlzSOXg@jetpack".install_url = latest "reddit-enhancement-suite";
  #   "{762f9885-5a13-4abd-9c77-433dcd38b8fd}".install_url = latest "return-youtube-dislikes";
  #   "sponsorBlocker@ajay.app".install_url = latest "sponsorblock";
  #   "jid1-93WyvpgvxzGATw@jetpack".install_url = latest "to-google-translate";
  #   "tubemod@extension.com".install_url = latest "tubemod";
  #   "{d3d2a327-1ae0-4fd6-b732-0844d0b7fd4c}".install_url = latest "twitch-live-channels";
  #   "{3c79db25-5fc9-4386-aaf7-0aaf5e07930f}".install_url = latest "vimium-ff";
  programs.firefox = {
    enable = true;
    nativeMessagingHosts = [
      pkgs.keepassxc
    ];
  };
}
