# update dbus environment variables
dbus-update-activation-environment --all

# source ~/.xprofile
[ -r ~/.xprofile ] && . ~/.xprofile

# start desired window manager
exec dk
