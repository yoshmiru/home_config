 {
  allowUnfree = true; #  allowBroken = true;
  packageOverrides = super:
    let self = super.pkgs;
        customRC = ''
            syntax enable
            set expandtab
            set shiftwidth=2
            set number
            set autoindent
            autocmd BufNewFile,BufRead *.tsx set shiftwidth=4
            autocmd BufNewFile,BufRead *.php set shiftwidth=4
    " Status Line {  
            set laststatus=2                             " always show statusbar  
            set statusline=  
            set statusline+=%-10.3n\                     " buffer number  
            set statusline+=%f\                          " filename   
            set statusline+=%h%m%r%w                     " status flags  
            set statusline+=\[%{strlen(&ft)?&ft:'none'}] " file type  
            set statusline+=%=                           " right align remainder  
            set statusline+=0x%-8B                       " character value  
            set statusline+=%-14(%l,%c%V%)               " line, character  
            set statusline+=%<%P                         " file position  

            let g:LanguageClient_serverCommands = {
              \ 'vue': ['vls'],
              \ }
    "} 
          '';
  in
  {
    
    vimEnv = self.vim_configurable.customize {
      name = "vim-with-plugins";
      vimrcConfig.plug.plugins = with self.vimPlugins; [ LanguageClient-neovim neosnippet neosnippet-snippets ale vim-vue ];
      vimrcConfig.customRC = customRC;
    };

    nvimEnv = self.neovim.override {
      configure = {
        customRC = customRC;
        packages.myVimPackage = with self.vimPlugins; {
          # see examples below how to use custom packages
          start = [ ];
          opt = [ LanguageClient-neovim neosnippet neosnippet-snippets ale vim-vue ];
        }; 
      };
    };

    phpEnv = self.php81.buildEnv {
      extensions = ({ enabled, all }: enabled ++ (with all; [
        pdo_mysql
      ]));
    };

    vsCode = (self.vscode-with-extensions.override {
      vscodeExtensions = with self.vscode-extensions; [
        #bbenoist.nix
        #ms-python.python
        #ms-azuretools.vscode-docker
        #ms-vscode-remote.remote-ssh
      ];# ++ self.vscode-utils.extensionsFromVscodeMarketplace [
      #  {
      #    name = "remote-ssh-edit";
      #    publisher = "ms-vscode-remote";
      #    version = "0.47.2";
      #    sha256 = "1hp6gjh4xp2m1xlm1jsdzxw9d8frkiidhph6nvl24d0h8z34w49g";
      #  }
      #];
    });
  };
}
