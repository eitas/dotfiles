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

# Setting up a new machine

I have moved to Ubuntu.  In order to get going on a new machine you need to clone this repo.  This requires logging into github
and cloning the git repo, which requires the installation of git and the generation of an ssh key on the new machine

https://docs.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent

But first need a couple of apps:

* `sudo apt install xclip` which allows you to copy the public key to the clipboard and then add it to github
* `sudo apt install git` for obvious reasons you are going to need git

* `$ ssh-keygen -t ed25519 -C "your_email@example.com"`
* `$ eval "$(ssh-agent -s)"`
* `$ cat ~/.ssh/id_ed25519.pub | xclip -selection clipboard`

The new key is in the clipboard, just add an SSH key into the github account.

With that done, clone this repo into a ~/github folder:

* `$ cd ~ && mkdir github && cd github`
* `$ git clone --recursive git@github.com:eitas/dotfiles.git`

Now with the repo locally you can install all the tools needed and symlink
to the dotfiles:

* `cd dotfiles`
* `$ ./bootstrap.sh`

Once you have bootstrapped the system you should setup Neovim
* `$ ./neovim_bootstrap.sh`

At present you need to open vim, ignore the errors and issue :PlugInstall
to get the plugins and then restart vim (neovim).  This is annoying and 
there must be a better way, need to research


if you are using Linux Mint (21 at time of writing) then update the Ctrl-Alt-Del
if you wish by searching "Keyboard" from Cinnamon's menu, then goto the 
shortcuts tab > System > Lock screen and update the key binding there.

TODO: Getting aws sso login working.


# Fonts

So setting up fonts is fun, but actually took me an hour or so to figure out!

Create a fonts directory:
```bash
mkdir ~/.fonts
```

Go to [Nerd fonts](https://github.com/ryanoasis/nerd-fonts)
Within that repo go to patched-fonts, you'll see a whole bunch of fonts
In each of those directories will be folders for Regular, Italic, Bold etc...
Inside those directories will be a complete directory.  and phew, finally in
there will be an otf or ttf file which you can download and copy to the ~/.fonts directory

In Mint you can then go to system settings font selection and choose your regular font.
Seems Vim just picked this up for me and symbols appeared in NERDTree

You can check out the fonts and see samples here:
https://www.programmingfonts.org/

Also visit [Nerdfonts.com](https://www.nerdfonts.com/font-downloads) to get
a view of fonts and download them directly there.
