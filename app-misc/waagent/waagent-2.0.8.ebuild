# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit python

DESCRIPTION="Windows Azure Linux Agent"
HOMEPAGE="https://github.com/Azure/WALinuxAgent"
SRC_URI="https://github.com/Azure/WALinuxAgent/archive/WALinuxAgent-${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE=""

PYTHON_DEPEND="2:2.5"

RDEPEND=">=dev-libs/openssl-1.0.1h-r2
        >=net-misc/openssh-6.6_p1-r1
        sys-apps/iproute2
        dev-python/pyasn1"

S="${WORKDIR}/WALinuxAgent-WALinuxAgent-${PV}"

pkg_setup() {
    python_set_active_version 2
}

src_install() {
    dosbin waagent
    /usr/sbin/waagent -install
}
