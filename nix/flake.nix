{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #ghostty = {
    #  url = "github:ghostty-org/ghostty";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};
    mac-app-util.url = "github:hraban/mac-app-util";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew, home-manager, mac-app-util, /* ghostty */}:
  let
    configuration = { pkgs, ... }: {
      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
      # nixpkgs.config.allowUnfree = true;

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ 
          pkgs.neovim
	  pkgs.tmux
	  pkgs.fzf
	  pkgs.zoxide
	  pkgs.oh-my-posh
	  #pkgs.alacritty
	  #ghostty.packages.aarch64-darwin.default
        ];

      homebrew = {
        enable = true;
	brews = [
	  # "mas"
	];
	casks = [
	  "firefox"
	  "ghostty"
	];
	masApps = {
	  # "Yoink" = 123;
	};
	onActivation.cleanup = "zap";
	onActivation.autoUpdate = true;
	onActivation.upgrade = true;
      };

      fonts.packages =
        [
	  pkgs.nerd-fonts.jetbrains-mono
	];

      system.startup.chime = false;
      security.pam.enableSudoTouchIdAuth = true;

      system.defaults = {
        NSGlobalDomain = {
          AppleICUForce24HourTime = true;

          AppleInterfaceStyle = "Dark";

          KeyRepeat = 2;
	  NSAutomaticDashSubstitutionEnabled = false;
	  NSAutomaticPeriodSubstitutionEnabled = false;
	  NSAutomaticQuoteSubstitutionEnabled = false;
	  NSAutomaticCapitalizationEnabled = false;

	  "com.apple.swipescrolldirection" = false; # Disable "natural" scrolling

          AppleShowAllExtensions = true;
          AppleShowAllFiles = true;
	  # _HIHideMenuBar = true;
	};

	controlcenter.BatteryShowPercentage = true;

	loginwindow.GuestEnabled = false;

        dock = {
	  autohide = true;
	  persistent-apps = [
	    "${pkgs.alacritty}/Applications/Alacritty.app"
	    "/Applications/Firefox.app"
	    "/System/Applications/Messages.app"
	    "/System/Applications/iPhone\ Mirroring.app"
	  ];
          show-recents = false;
	  show-process-indicators = false;
	};

	finder = {
	  AppleShowAllExtensions = true;
	  AppleShowAllFiles = true;

	  ShowPathbar = true;
	  ShowStatusBar = true;

	  FXEnableExtensionChangeWarning = true;
	  FXPreferredViewStyle = "clmv";
	};

	CustomSystemPreferences = {
	  NSGlobalDomain = {
	    AppleScrollerPagingBehavior = true;
	    AppleWindowTabbingMode = "always";
	  };

	  "com.apple.finder" = {
	    ShowHardDrivesOnDesktop = false;
	    ShowRemoveableMediaOnDesktop = false;
	    ShowExternalHardDrivesOnDesktop = false;
	    ShowMountedServersOnDesktop = false;

	    _FXSortFoldersFirst = true;
	    _FXShowPosixPathInTitle = true;

	    NewWindowTarget = "PfHm";
	    NewWindowTargetPath = "file://$HOME/";

	    QLEnableTextSelection = true;
	  };

	  "com.apple.desktopservices" = {
	    DSDontWriteUSBStores = true;
	    DSDontWriteNetworkStores = true;
	  };

	  "com.apple.commerce".AutoUpdate = false;

	  "com.apple.SoftwareUpdate" = {
	    AutomaticCheckEnabled = true;
	    ScheduleFrequency = 1;
	    AutomaticDownload = 1;
	    CriticalUpdateInstall = 1;
	  };

	  "com.apple.print.PrintingPrefs"."Quit When Finished" = true;

	  "com.apple.CrashReporter".DialogType = "none";

	  "com.apple.AdLib" = {
	    forceLimitAdTracking = true;
	    allowApplePersonalizedAdvertising = false;
	    allowIdentifierForAdvertising = false;
	  };

	  "com.apple.Safari" = {
	    UniversalSearchEnabled = false;
	    SuppressSearchSuggestions = true;
	    SendDoNotTrackHTTPHeader = true;

	    AutoOpenSafeDownloads = false;

	    IncludeDevelopMenu = true;
	    IncludeInternalDebugMenu = true;
	    WebKitDeveloperExtras = true;
	    WebKitDeveloperExtrasEnabledPreferenceKey = true;
	    "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" = true;
	};
      };
    };

      users.users.jh = {
        name = "jh";
	home = "/Users/jh";
      };
    };
    homeconfig = {pkgs, config, ...}: {
      home.stateVersion = "23.05";

      programs.home-manager.enable = true;
      programs.git = {
        enable = true;
	delta.enable = true;

	userName = "Jaden Hoenes";
	userEmail = "jaden.hoenes@gmail.com";
	signing = {
	  key = "~/.ssh/id_ed25519";
	  signByDefault = true;
	};

	ignores = [ ".DS_Store" ];
	extraConfig = {
	  init.defaultBranch = "main";
	  push.autoSetupRemote = true;
	  gpg.format = "ssh";
	};
      };
      programs.zsh.enable = true;

      home.file.".zshrc".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/zsh/.zshrc";
      home.file.".config/ohmyposh".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/ohmyposh";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#Jadens-MacBook-Air
    darwinConfigurations.air = nix-darwin.lib.darwinSystem {
      modules =
        [ 
	  configuration 
	  nix-homebrew.darwinModules.nix-homebrew
	  {
	    nix-homebrew = {
	      enable = true;
	      enableRosetta = true;
	      user = "jh";
	    };
	  }
	  home-manager.darwinModules.home-manager {
	    home-manager.useGlobalPkgs = true;
	    home-manager.useUserPackages = true;
	    home-manager.verbose = true;
	    home-manager.users.jh = homeconfig;
	  }
	  mac-app-util.darwinModules.default
	];
    };
  };
}
