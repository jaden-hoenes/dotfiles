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
        #"github.com" = { publicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCj7ndNxQowgcQnjshcLrqPEiiphnt+VTTvDP6mHBL9j1aNUkY4Ue1gvwnGLVlOhGeYrnZaMgRK6+PKCUXaDbC7qtbW8gIkhL7aGCsOr/C56SJMy/BCZfxd1nWzAOxSDPgVsmerOBYfNqltV9/hWCqBywINIR+5dIg6JTJ72pcEpEjcYgXkE2YEFXV1JHnsKgbLWNlhScqb2UmyRkQyytRLtL+38TGxkxCflmO+5Z8CSSNY7GidjMIZ7Q4zMjA2n1nGrlTDkzwDCsw+wqFPGQA179cnfGWOWRVruj16z6XyvxvjJwbz0wQZ75XK5tKSb7FNyeIEs4TT4jk+S4dhPeAUC5y+bDYirYgM4GC7uEnztnZyaVWQ7B381AK4Qdrwt51ZqExKbQpTUNn+EjqoTwvqNj4kqx5QUCI0ThS/YkOxJCXmPUWZbhjpCg56i+2aB6CmK2JGhn57K5mj0MNdBXA4/WnwH6XoPWJzK5Nyu2zB3nAZp+S5hpQs+p1vN1/wsjk="; };
        #"github.com" = { publicKey = "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEmKSENjQEezOmxkZMy7opKgwFB9nkt5YRrYMjNuG5N87uRgg6CLrbo5wAdT/y6v0mKV0U2w0WZ2YB/++Tpockg="; };
      };
    };
  };
}
