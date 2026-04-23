# dotfiles: collection of my personal dotfiles
# Copyright (C) 2012-2019 Aleksa Sarai <cyphar@cyphar.com>
# Copyright (C) 2021 Chris Carter <chris@gibsonsec.org>
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

function prox -d "Make setting proxies simpler."
	read -lP "username: " user
	read -lsP "password: " pass

	set -l server "$argv[1]"
	set -l protocol "$argv[2]"
	if test -z "$server"; read -P "server: " server; end
	if test -z "$protocol"; read -P "protocol: " protocol; end

	set -l proxy "$protocol://$user:$pass@$server"

	set -xg HTTP_PROXY "$proxy"
	set -xg HTTPS_PROXY "$proxy"
	set -xg SOCKS_PROXY "$proxy"
	set -xg FTP_PROXY "$proxy"
	set -xg ALL_PROXY "$proxy"

	set -xg http_proxy "$proxy"
	set -xg https_proxy "$proxy"
	set -xg socks_proxy "$proxy"
	set -xg ftp_proxy "$proxy"
	set -xg all_proxy "$proxy"
end

function unprox -d "Make deactivating proxies simpler."
	set -e HTTP_PROXY HTTPS_PROXY SOCKS_PROXY FTP_PROXY ALL_PROXY
	set -e http_proxy https_proxy socks_proxy ftp_proxy all_proxy
end

