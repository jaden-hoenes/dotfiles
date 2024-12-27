{ config, lib, pkgs, ... }: {
  home = {
    stateVersion = "23.05";

    packages = [
      pkgs.neovim
      pkgs.tmux
      pkgs.alacritty
    ];

    #file = {
    #  ".zshenv".text = ''
    #    source ${config.system.build.setEnvironment}
    #    source $HOME/.config/zsh/.zshenv
    #  '';
    #  ".zshrc".source = config.lib.file.mkOutOfStoreSymlink "$HOME/.dotfiles/zsh/.zshrc";
    #};
  };

  programs = {
    home-manager.enable = true;
    
    #firefox.enable = true;
    git = {
      enable = true;

      userName = "Jaden Hoenes";
      userEmail = "jaden.hoenes@gmail.com";
      signing = {
        signByDefault = true;
	key = "~/.ssh/id_ed25519";
      };

      ignores = [ ".DS_Store" ];
      extraConfig = {
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
	gpg.format = "ssh";
      };

      delta.enable = true;
    };

    ssh = {
      enable = true;
      knownHosts = {
        "github.com" = { publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl"; };
      };
    };
  };
}
