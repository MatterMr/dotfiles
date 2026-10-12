{
  config,
  pkgs,
  lib,
  ...
}:
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
    "sidebar.verticalTabs" = false;
    "sidebar.revamp" = true;
    "sidebar.visibility" = "hide-launcher";
    "browser.uiCustomization.state" = builtins.toJSON {
      currentVersion = 26;
      placements = {
        widget-overflow-fixed-list = [ ];
        unified-extensions-area = [
          "ublock0_raymondhill_net-browser-action"
          "_d7742d87-e61d-4b78-b8a1-b469842139fa_-browser-action"
        ];
        nav-bar = [
          "sidebar-button"
          "back-button"
          "forward-button"
          "stop-reload-button"
          "customizableui-special-spring1"
          "vertical-spacer"
          "urlbar-container"
          "customizableui-special-spring2"
          "downloads-button"
          "fxa-toolbar-menu-button"
          "reset-pbm-toolbar-button"
          "treestyletab_piro_sakura_ne_jp-browser-action"
          "_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action"
          "unified-extensions-button"
        ];
        TabsToolbar = [
          "tabbrowser-tabs"
          "new-tab-button"
          "customizableui-special-spring3"
          "alltabs-button"
          "smartwindow-group-tabs-button"
          "ai-window-toggle"
        ];
        vertical-tabs = [ ];
        PersonalToolbar = [
          "import-button"
          "personal-bookmarks"
        ];
      };
      seen = [
        "reset-pbm-toolbar-button"
        "treestyletab_piro_sakura_ne_jp-browser-action"
        "smartwindow-group-tabs-button"
        "ai-window-toggle"
        "developer-button"
        "ublock0_raymondhill_net-browser-action"
        "_d7742d87-e61d-4b78-b8a1-b469842139fa_-browser-action"
        "_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action"
      ];
      dirtyAreaCache = [
        "nav-bar"
        "TabsToolbar"
        "vertical-tabs"
        "unified-extensions-area"
        "PersonalToolbar"
      ];
      newElementCount = 4;
    };
  };
  vimiumId = "{d7742d87-e61d-4b78-b8a1-b469842139fa}";
  treeStyleTabId = "treestyletab@piro.sakura.ne.jp";

  vimiumKeyMappings = ''
    unmap J
    unmap K
    map J nextTab
    map K previousTab
  '';

  sqlString = s: "'" + lib.replaceStrings [ "'" ] [ "''" ] s + "'";

  # Vimium reads its settings from storage.sync, which Firefox keeps in
  # storage-sync-v2.sqlite (not in the storage.js that extensions.settings
  # writes), so keyMappings is written into that database on activation.
  vimiumSql = ''
    UPDATE storage_sync_data
    SET data = json_set(data, '$.keyMappings', json(${sqlString (builtins.toJSON vimiumKeyMappings)})),
        sync_change_counter = sync_change_counter + 1
    WHERE ext_id = ${sqlString vimiumId}
      AND json_extract(data, '$.keyMappings') IS NOT ${sqlString vimiumKeyMappings};
  '';

  sharedExtensionSettings = {
    ${treeStyleTabId} = {
      force = true;
      settings = {
        style = "proton";
      };
    };
  };
in
{
  # Only touches the database while Firefox is closed, since Firefox holds the
  # settings in memory and would write its own copy back.
  home.activation.vimiumKeyMappings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if /usr/bin/pgrep -f 'Firefox.app/Contents/MacOS' >/dev/null; then
      echo "Firefox is running; skipping Vimium keyMappings (quit Firefox and switch again)"
    else
      for profile in ${
        lib.concatMapStringsSep " " (p: lib.escapeShellArg p.path) (
          lib.attrValues config.programs.firefox.profiles
        )
      }; do
        db="$HOME/${config.programs.firefox.profilesPath}/$profile/storage-sync-v2.sqlite"
        if [ -f "$db" ]; then
          run ${pkgs.sqlite}/bin/sqlite3 "$db" ${lib.escapeShellArg vimiumSql}
        fi
      done
    fi
  '';

  programs.firefox = {
    enable = true;

    # macOS 27+ denies wrapped apps access to ~/Library/Application Support/Firefox
    configPath = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin ".mozilla/firefox";

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
          # Ublock-Origin
          "uBlock0@raymondhill.net" = {
            install_url = moz "ublock-origin";
            installation_mode = "force_installed";
          };
          # Vimium-ff
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
