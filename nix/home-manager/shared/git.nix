{ ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "mattermr";
        email = "greymatter432@icloud.com";
      };
      init.defaultBranch = "main";
      pull.rebase = false;
      core.editor = "nvim";
      merge.tool = "nvimdiff";
    };
  };
}
