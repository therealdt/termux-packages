TERMUX_PKG_HOMEPAGE=https://ebusd.eu/
TERMUX_PKG_DESCRIPTION="ebusd is a daemon for eBUS device communication on a 2-wire bus"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.1"
TERMUX_PKG_SRCURL="https://github.com/john30/ebusd/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=45afe6f5978b0f4f82901af4eae0f7821845ddbe3188d7a67c06e0a60623d983
TERMUX_PKG_DEPENDS="binutils, libmosquitto"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	local _inc="$TERMUX_PKG_SRCDIR/_getsubopt/include"
	rm -rf "${_inc}"
	mkdir -p "${_inc}"
	cp "$TERMUX_PKG_BUILDER_DIR/getsubopt.h" "${_inc}"

	CPPFLAGS+=" -I${_inc}"

	local _lib="$TERMUX_PKG_BUILDDIR/_getsubopt/lib"
	rm -rf "${_lib}"
	mkdir -p "${_lib}"
	pushd "${_lib}"/..
	$CC $CFLAGS $CPPFLAGS "$TERMUX_PKG_BUILDER_DIR/getsubopt.c" \
		-fvisibility=hidden -c -o ./getsubopt.o
	$AR cru "${_lib}"/libgetsubopt.a ./getsubopt.o
	popd

	LDFLAGS+=" -L${_lib} -l:libgetsubopt.a"
	autoreconf -vfi
	./configure --host=$TERMUX_HOST_PLATFORM
}
