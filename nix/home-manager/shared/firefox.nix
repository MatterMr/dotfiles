{ ... }:
let
  custom_css = ''
      /* Hide all tabs and tab bar buttons */
    	#main-window:not([extradragspace="true"]) #TabsToolbar > .toolbar-items {
    		opacity: 0;
    		pointer-events: none;
    	}

    	/* This makes the bar shorter vertically but removes the 3 window buttons */
    	#main-window #TabsToolbar {
    		visibility: collapse !important;
    	}

    	/* For full screen mode */
    	#TabsToolbar[inFullscreen]{
    		display: none !important;
    	}
  '';
  sharedProfileSettings = {
    "browser.startup.homepage" = "vimium.github.io/new-tab/";
    "browser.startup.page" = 3;
  };
  vimiumId = "{d7742d87-e61d-4b78-b8a1-b469842139fa}";
  treeStyleTabId = "treestyletab@piro.sakura.ne.jp";

  sharedExtensionSettings = {
    ${vimiumId} = {
      force = true;
      settings.keyMappings = ''
                unmap J
        				unmap K 
        				map J nextTab 
        				map K previousTab
      '';
    };
    ${treeStyleTabId} = {
      force = true;
      settings = {
        style = "proton";
      };
    };
  };
in
{
  programs.firefox = {
    enable = true;

    languagePacks = [ "en-US" ];

    policies = {
      # Updates & Background Services
      AppAutoUpdate = false;
      BackgroundAppUpdate = false;

      # Feature Disabling
      DisableBuiltinPDFViewer = false;
      DisableFirefoxStudies = true;
      DisableFirefoxAccounts = true;
      DisableFirefoxScreenshots = true;
      DisableForgetButton = true;
      DisableMasterPasswordCreation = true;
      DisableProfileImport = false;
      DisableProfileRefresh = false;
      DisableSetDesktopBackground = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DisableFormHistory = true;
      DisablePasswordReveal = true;

      # Access Restrictions
      BlockAboutConfig = false;
      BlockAboutProfiles = false;
      BlockAboutSupport = false;

      # UI and Behavior
      DisplayMenuBar = "never";
      DisplayBookmarksToolbar = "never";
      DontCheckDefaultBrowser = true;
      HardwareAcceleration = true;
      OfferToSaveLogins = false;
      # DefaultDownloadDirectory = "${home}/Downloads";

      SearchEngines = {
        Default = "DuckDuckGo";
      };

      # Extensions
      ExtensionSettings =
        let
          moz = short: "https://addons.mozilla.org/firefox/downloads/latest/${short}/latest.xpi";
        in
        {
          "*".installation_mode = "blocked";

          "uBlock0@raymondhill.net" = {
            install_url = moz "ublock-origin";
            installation_mode = "force_installed";
          };
          "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = {
            install_url = moz "vimium-ff";
            installation_mode = "force_installed";
          };
          # Tree Style Tabs
          "treestyletab@piro.sakura.ne.jp" = {
            install_url = moz "tree-style-tab";
            installation_mode = "force_installed";
          };
          # Bitwarden
          "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
            install_url = moz "bitwarden-password-manager";
            installation_mode = "force_installed";
          };
        };
    };
    profiles = {
      Home = {
        id = 0;
        isDefault = true;
        name = "Home";
        userChrome = custom_css;
        extensions.settings = sharedExtensionSettings;
        settings = sharedProfileSettings;
      };
      Work = {
        id = 1;
        isDefault = false;
        name = "Work";
        userChrome = custom_css;
        extensions.settings = sharedExtensionSettings;
        settings = sharedProfileSettings;
      };
    };
  };
}
