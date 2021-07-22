#!/usr/bin/env bash

# This implements the XDG autostart specification
if (command -v dex && ! xrdb -query | grep -q "^awesome\.started:\strue$"); then
	xrdb -merge <<< "awesome.started:true"
	dex -e xfce -a
fi;
