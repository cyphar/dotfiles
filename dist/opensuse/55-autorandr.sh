#!/bin/bash
# dotfiles: collection of my personal dotfiles
# Copyright (C) 2012-2023 Aleksa Sarai <cyphar@cyphar.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

set -Eeuo pipefail

echo ">> pip install autorandr"
pip install autorandr

echo ">> install autorandr udev wrapper script"
cat >/usr/local/sbin/autorandr-udev.sh <<EOF
#!/bin/zsh
# Copyright (C) 2012-2023 Aleksa Sarai <cyphar@cyphar.com>
# License: GPL-3.0-or-later

set -Eeuo pipefail

# Get the current user.
logger -t autorandr-udev "username=."
username="\$(w -hs | awk '\$3 != "-" { print \$1; exit; }')"
display="\$(w -hs | awk -v username="\$username" '\$3 != "-" && \$1 == username { print \$3; exit; }')"
if [ -z "\$display" ]; then
	logger -t autorandr-udev "Nobody seems to be logged in."
	return 1
fi

output="\$(sudo -u "\$username" DISPLAY="\$display" autorandr -c 2>&1)"
if [ "\$?" -ne 0 ]
then
	logger -t autorandr-udev "autorandr: \$output"
	return 1
fi
EOF
chmod +x /usr/local/sbin/autorandr-udev.sh

echo ">> configure udev-rules for autorandr"
cat >/etc/udev/rules.d/95-autorandr.rules <<EOF
# Maybe we should have HOTPLUG=="1" here but it seems to not work...
SUBSYSTEM=="drm", ACTION=="change", RUN+="/usr/local/sbin/autorandr-udev.sh"

# Extra fallbacks if change stops working for some reason.
#SUBSYSTEM=="drm", ACTION=="add",    RUN+="/usr/local/sbin/autorandr-udev.sh"
#SUBSYSTEM=="drm", ACTION=="remove", RUN+="/usr/local/sbin/autorandr-udev.sh"
EOF
udevadm control --reload ||:
