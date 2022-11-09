{ pkgs, ...}: {
  programs.neovim = {
    plugins = [
      {
        plugin = "nvim-colorizer-lua";
        config = ''
          packadd! nvim-colorizer.lua
          lua require 'colorizer'.setup()
        '';
      }
    ];
    #plugins = with pkgs.vimPlugins; [ elm-vim ];
  };
}
