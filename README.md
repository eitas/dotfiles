# dotfiles introduction

previously I had used a method to have a raw repo of my dotfiles stored within a bare repository which was then held in
my $HOME directory.  Similar to this:
https://harfangk.github.io/2016/09/18/manage-dotfiles-with-a-git-bare-repository.html

This was pretty neat and kept my files up to date directly in my $HOME location.  However, there are lots of other files
in there, you also need to update your .gitignore to ignore those files and the $HOME location may not be consistent
between machines (for home and work for example).  

So I moved to another solution which was to symlink the important dotfiles in my $HOME location to an explicit directory
on my machine where this repo is stored.  
This was inspired from this article: https://www.freecodecamp.org/news/dive-into-dotfiles-part-2-6321b4a73608/

Within here I have my key dotfiles, a shell script to bootstrap my system (i.e. install key software such as git, aws
cli etc...) and symlink to the dotfiles.  In addition I have separate boostraps, currently only vim, that setup key
environments (such as plugins etc...)

# Git Submodules for Vim Plugins

Note that the plugins are git submodules.  So you need to add and update them separately to this repo.  A good
stackoverflow answer to this is here:

https://www.vogella.com/tutorials/GitSubmodules/article.html
Also https://stackoverflow.com/questions/5828324/update-git-submodule-to-latest-commit-on-origin

So to get the submodules into the repo you either need to clone this repo with:
`$ git clone --recursive <this url>i`
or if you already have the repo cloned you can get the submodules with
`$ git submodule update --init --recursive`

Doing this and then running ./vim_bootstrap.sh will copy the plugins to the vim 8 plugin manager location, in my case
$HOME/.vim/pack/eitas/start/

# Adding git submodules for Vim

If you want to add a git submodule you need to do so by moving into the vimplugins directory.  Then issue:
`$ git submodule add https:\\<path to plugin>`
Make sure to use the https path to the github repo, otherwise you will be using ssh keys and then will need your ssh key to authenticate with github (which in my case, at work, we do not use).

Then update the vim_bootstrap.sh to add the deployment (i.e. the copy to the .vim plugin location) to the script and run:
`$ sudo ./vim_bootstrap.sh`
in order to deploy the plugin.

if you accidentally use the ssh and do not want to add an ssh key then in order to change the URL to use HTTPS over SSH:
* change the url entry under the submodule in the `.gitmodules` file.
* change the url entry under the submodule in the `.git/config` file.
* change the url in the configuration of the submodule itself.  So under `.git/modules/<submodule name>/config`, or `cd .git/modules/<submodule name>/` `git config remote.origin.url <new url>`

# Removing git submodules

If you had added a git submodule that you no longer require then you need to remove it.  A link here:
https://gist.github.com/myusuf3/7f645819ded92bda6677
has a good step by step process, repeated here for completeness

* delete the relevant section from the .gitmodules file
* Stage the .gitmodules changes (git add .gitmodules)
* delete the relevant section from .git/config
* Run `git rm --cached <path to submodule>` (no trailing slash)
* Run `rm -rf .git/modules/<path to submodule>` (no trailing slash)
* Commit git: `git commit -m "removed submodule"`
* Delete the now untracked submodule file(s): `rm -rf <path to submodule>`

# Plugin help installs

By default the plugins do not have the documentation installed which I really need to help me understand the plugins
issuing

`:helptags ALL` 

was not working for me as I was getting a 

`E152 Cannot open <plugin doc location>/tags for writing`

This was because I needed to run helptags ALL as root, so 

`$ sudo vim`

And then

`:helptags ALL`

installed the documentation
