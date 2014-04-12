class people::woowee {

  ## Puppet module
  include iterm2::stable
  include zsh
  include tmux

  include python
  include python::virtualenvwrapper #for mutogen, and so i just want to use mid3v2
  #include go
  go::version { '1.1.2': }
  include processing

  include gimp
  include inkscape
  include vlc
  include handbrake #need libdvdcss(homebrew)

  include evernote
  include dropbox

  include appcleaner
  include better_touch_tools
  include shiftit

  ## directories
  $home = "/Users/${::luser}"
  $src  = "${home}/src"

  ## homebrew
  #dupes to use rsync 3
  homebrew::tap { 'homebrew/dupes': }
  package { 'homebrew/dupes/rsync':
    require => Homebrew::Tap["homebrew/dupes"]
  }
  #ricty font
  homebrew::tap { 'sanemat/font': }
  package { 'sanemat/font/ricty':
    require => Homebrew::Tap["sanemat/font"]
  }
  exec { 'set ricty':
    command => "cp -f ${homebrew::config::installdir}/share/fonts/Ricty*.ttf ~/Library/Fonts/ && fc-cache -vf",
    require => Package["sanemat/font/ricty"]
  }

  #any
  package {
    [
      #radiko recording
      'rtmpdump',
      'ffmpeg',
      'wget',
      'base64',
      'swftools',

      'eyeD3',

      #handbrake
      'libdvdcss',
    ]:
  }


  ## python
  python::pip { 'mutagen':
    virtualenv => $python::config::global_venv
  }


  ## packages
  package {
    'Gimp':
      source   => "http://sourceforge.net/projects/gimponosx/files/GIMP Mountain Lion/Gimp-2.8.6p1-MountainLion.dmg",
      provider => appdmg;
    'myTracks':
      source   => "http://www.mytracks4mac.info/download/myTracks2.dmg",
      provider => appdmg;
    #'LibreOffice':
    #  source   => "http://download.documentfoundation.org/libreoffice/stable/4.1.3/mac/x86/LibreOffice_4.1.3_MacOS_x86.dm",
    #  provider => appdmg;
    #'LibreOffice LangPack Ja':
    #  source   => "http://download.documentfoundation.org/libreoffice/stable/4.1.3/mac/x86/LibreOffice_4.1.3_MacOS_x86_langpack_ja.dmg",
    #  provider => appdmg;
  }


  ## dotfiles
  $dotfiles = "${home}/dots"

  # git clone 'dotfiles'
  repository { $dotfiles:
    source  => "woowee/dots",
  }

  # symlinks
  file { "${home}/.zshrc":
    ensure  => link,
    mode    => '0644',
    target  => "${dotfiles}/.zshrc",
    require => Repository[$dotfiles],
  }
  file { "${home}/.vimrc":
    ensure => link,
    mode   => '0644',
    target => "${dotfiles}/.vimrc",
    require => Repository[$dotfiles],
  }
  file { "${home}/.gvimrc":
    ensure => link,
    mode   => '0644',
    target => "${dotfiles}/.gvimrc",
    require => Repository[$dotfiles],
  }


  ## osx settings
  exec { 'osx-settings':
    cwd => $dotfiles,
    command => "sh ${dotfiles}/osx -s",
    require => Repository[$dotfiles],
  }

}
