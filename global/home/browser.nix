{ pkgs, lib, ... }: {
  programs.firefox = {
    enable = true;
    nativeMessagingHosts = [
      pkgs.keepassxc
    ];
    policies = {
      DisableAppUpdate = true;
      AppUpdateURL = "https://localhost/";
      OverrideFirstRunPage = "";
      OverridePostUpdatePage = "";
      DisableFirefoxStudies = true;
      DisableTelemetry = true;
      DisableFeedbackCommands = true;
      DisablePocket = true;
      DisableSetDesktopBackground = true;
      NoDefaultBookmarks = true;
      Extensions = {
        Uninstall = [
          "google@search.mozilla.org"
          "bing@search.mozilla.org"
          "amazondotcom@search.mozilla.org"
          "ebay@search.mozilla.org"
          "twitter@search.mozilla.org"
        ];
      };
      ExtensionSettings = let
        latest = addon_id: "https://addons.mozilla.org/firefox/downloads/latest/${addon_id}/latest.xpi";
        mapExt = lib.mapAttrs (name: value: {
          installation_mode = "normal_installed";
          install_url = value;
        });
      in mapExt {
        "addon@darkreader.org" = latest "darkreader";
        "{36bdf805-c6f2-4f41-94d2-9b646342c1dc}" = latest "export-cookies-txt";
        "{74145f27-f039-47ce-a470-a662b129930a}" = latest "clearurls";
        "{b86e4813-687a-43e6-ab65-0bde4ab75758}" = latest "localcdn-fork-of-decentraleyes";
        "DontFuckWithPaste@raim.ist" = latest "don-t-fuck-with-paste";
        "{531906d3-e22f-4a6c-a102-8057b88a1a63}" = latest "single-file";
        "skipredirect@sblask" = latest "skip-redirect";
        "7esoorv3@alefvanoon.anonaddy.me" = latest "libredirect";
        "moz-addon-prod@7tv.app" = "https://extension.7tv.gg/v3.0.9/ext.xpi";
        "gdpr@cavi.au.dk" = latest "consent_o_matic";
        "enhancerforyoutube@maximerf.addons.mozilla.org" = latest "enhancer-for-youtube";
        "keepassxc-browser@keepassxc.org" = latest "keepassxc-browser";
        "mouse-pinch-to-zoom@niziolek.dev" = latest "mouse-pinch-to-zoom";
        "new-window-without-toolbar@tkrkt.com" = latest "new-window-without-toolbar";
        "{9063c2e9-e07c-4c2c-9646-cfe7ca8d0498}" = latest "old-reddit-redirect";
        "jid1-MnnxcxisBPnSXQ@jetpack" = latest "privacy-badger17";
        "jid1-xUfzOsOFlzSOXg@jetpack" = latest "reddit-enhancement-suite";
        "{762f9885-5a13-4abd-9c77-433dcd38b8fd}" = latest "return-youtube-dislikes";
        "sponsorBlocker@ajay.app" = latest "sponsorblock";
        "jid1-93WyvpgvxzGATw@jetpack" = latest "to-google-translate";
        "tubemod@extension.com" = latest "tubemod";
        "{d3d2a327-1ae0-4fd6-b732-0844d0b7fd4c}" = latest "twitch-live-channels";
        "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = latest "vimium-ff";
        "uBlock0@raymondhill.net" = latest "ublock-origin";
      };
      SupportMenu = {
        Title = "Fix it yourself jackass";
        URL = "${../..}";
      };
    };
    profiles = {
      Default = {
        id = 0;
        isDefault = true;
      };
      I2P = {
        id = 1;
        isDefault = false;
      };
    };
  };
}
