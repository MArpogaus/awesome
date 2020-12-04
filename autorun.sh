#!/usr/bin/env bash

## run (only once) processes which spawn with the same name
function run {
   if (command -v $1 && ! pgrep $1); then
     $@&
   fi
}

# This implements the XDG autostart specification
if (command -v dex && ! xrdb -query | grep -q "^awesome\.started:\strue$"); then
	xrdb -merge <<< "awesome.started:true"
	dex -e Awesome -a
fi;

if (command -v gnome-keyring-daemon && ! pgrep gnome-keyring-d); then
    gnome-keyring-daemon --daemonize --login &
fi

if (command -v /usr/lib/mate-polkit/polkit-mate-authentication-agent-1 && ! pgrep polkit-mate-aut) ; then
    /usr/lib/mate-polkit/polkit-mate-authentication-agent-1 &
fi

run thunar --daemon
run fusuma -d
run picom
run xfsettingsd --sm-client-disable --disable-wm-check 