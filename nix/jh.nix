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
    #git = {
    #  enable = true;
    #  userName = "Jaden Hoenes";
    #  userEmail = "jaden.hoenes@gmail.com";
    #  ignores = [ ".DS_Store" ];
    #  extraConfig = {
    #    init.defaultBranch = "main";
    #    push.autoSetupRemote = true;
    #  };
    #};
  };
}
