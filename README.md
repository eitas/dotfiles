# dotfiles

previously I had used a method to have a raw repo of my dotfiles stored within a bare repository which was then held in
my $HOME directory.  Similar to this:
https://harfangk.github.io/2016/09/18/manage-dotfiles-with-a-git-bare-repository.html

This was pretty neat and kept my files up to date directly in my $HOME location.  However, there are lots of other files
in there, you also need to update your .gitignore to ignore those files and the $HOME location may not be consistent
between machines (for home and work for example).  

So I moved to another solution which was to symlink the important dotfiles in my $HOME location to an explicit directory
on my machine where this repo is stored.  

Within here I have my key dotfiles, a shell script to bootstrap my system (i.e. install key software such as git, aws
cli etc...) and symlink to the dotfiles.  In addition I have separate boostraps, currently only vim, that setup key
environments (such as plugins etc...)

Note that the plugins are git submodules.  So you need to add and update them separately to this repo.  A good
stackoverflow answer to this is here:

https://stackoverflow.com/questions/5828324/update-git-submodule-to-latest-commit-on-origin

