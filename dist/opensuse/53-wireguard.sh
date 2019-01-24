#!/bin/bash
# dotfiles: collection of my personal dotfiles [code]
# Copyright (C) 2018 Aleksa Sarai <cyphar@cyphar.com>
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

echo ">> set up wireguard [deku]"
echo "wireguard" | sudo tee /etc/modules-load.d/99-wireguard.conf >/dev/null

if ! [ -f /etc/wireguard/wg-deku.conf ]
then

PRIVATE_KEY="$(wg genkey)"
PUBLIC_KEY="$(wg pubkey <<<"$PRIVATE_KEY")"

cat > /etc/wireguard/wg-deku.conf <<EOF
[Interface]
PrivateKey = $PRIVATE_KEY

[Peer]
PublicKey = Sg0C5MLDoFN3h5peMOoK+W5zK5hXEVtH8BIPX9N7/1A=
AllowedIPs = 0.0.0.0/0
Endpoint = dot.cyphar.com:51820
EOF
echo ">> wireguard pubkey [register with deku]: $PUBLIC_KEY"

fi
