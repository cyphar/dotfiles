#!/bin/bash
# dotfiles: collection of my personal dotfiles
# Copyright (C) 2012-2019 Aleksa Sarai <cyphar@cyphar.com>
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

# Disable auto-configuring DNS with netconfig and always use CloudFlare DNS
# plus the home DNS setup for dot.cyphar.com.
sudo sed -i 's|^NETCONFIG_DNS_POLICY=.*|NETCONFIG_DNS_POLICY="STATIC_FALLBACK"|g' /etc/sysconfig/network/config
sudo sed -i 's|^NETCONFIG_DNS_STATIC_SEARCHLIST=.*|NETCONFIG_DNS_STATIC_SEARCHLIST="dot.cyphar.com"|g' /etc/sysconfig/network/config
sudo sed -i 's|^NETCONFIG_DNS_STATIC_SERVERS=.*|NETCONFIG_DNS_STATIC_SERVERS="1.1.1.1 1.0.0.1 10.42.0.1"|g' /etc/sysconfig/network/config

sudo netconfig update -f
