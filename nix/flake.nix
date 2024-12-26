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
    mac-app-util.url = "github:hraban/mac-app-util";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew, home-manager, mac-app-util }:
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
	  pkgs.alacritty
          pkgs.xcode-select
        ];

      xcode.cli-tools = true;

      homebrew = {
        enable = true;
	brews = [
	  # "mas"
	];
	casks = [
	  "firefox"
	];
	masApps = {
	  # "Yoink" = 123;
	};
	onActivation.cleanup = "zap";
	onActivation.autoUpdate = true;
	onActivation.upgrade = true;
      };

      # Ensure Xcode CLI tools are installed
      system.activationScripts.xcode.text = ''
        # Check if Xcode CLI tools are installed
        if ! [ -f "/Library/Developer/CommandLineTools" ]; then
          echo "Installing Xcode Command Line Tools..."
          xcode-select --install || true
        fi
      '';

      fonts.packages =
        [
	  pkgs.nerd-fonts.jetbrains-mono
	];

      # Enable alternative shell support in nix-darwin.
      programs.zsh.enable = true;

      system.defaults = {
	NSGlobalDomain.AppleICUForce24HourTime = true;
	NSGlobalDomain.AppleInterfaceStyle = "Dark";
	NSGlobalDomain.KeyRepeat = 2;
	NSGlobalDomain.AppleShowAllExtensions = true;
	NSGlobalDomain.AppleShowAllFiles = true;
	controlcenter.BatteryShowPercentage = true;
        dock.autohide = true;
	dock.persistent-apps =
	  [
	    "${pkgs.alacritty}/Applications/Alacritty.app"
	    "/Applications/Firefox.app"
	    "/System/Applications/Messages.app"
	    "/System/Applications/iPhone\ Mirroring.app"
	  ];
	dock.show-recents = false;
	finder.AppleShowAllExtensions = true;
	finder.AppleShowAllFiles = true;
	finder.FXPreferredViewStyle = "clmv";
	finder.ShowPathbar = true;
	finder.ShowStatusBar = true;
	loginwindow.GuestEnabled = false;
      };
      system.startup.chime = false;
      security.pam.enableSudoTouchIdAuth = true;

      users.users.jh = {
        name = "jh";
	home = "/Users/jh";
      };
    };
    homeconfig = {pkgs, ...}: {
      home.stateVersion = "23.05";

      programs.home-manager.enable = true;
      programs.git = {
        enable = true;
	userName = "Jaden Hoenes";
	userEmail = "jaden.hoenes@gmail.com";
	ignores = [ ".DS_Store" ];
	extraConfig = {
	  init.defaultBranch = "main";
	  push.autoSetupRemote = true;
	};
      };

      home.packages = with pkgs; [];

      home.sessionVariables = {
        EDITOR = "vim";
      };

      # home.file.".vimrc".source = ./vimconfig;
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
