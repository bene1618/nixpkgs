{ stdenv, fetchurl, intltool, pkgconfig
, gnome3, ncurses, gobjectIntrospection, vala, libxml2, gnutls
, gperf, pcre2
}:

stdenv.mkDerivation rec {
  name = "vte-${version}";
  version = "0.54.0";

  src = fetchurl {
    url = "mirror://gnome/sources/vte/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "08x5vy25dx52bd7i56ijwmwr359n1fzcwzhcvsl6239h0rq6j2df";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "vte"; attrPath = "gnome3.vte"; };
  };

  nativeBuildInputs = [ gobjectIntrospection intltool pkgconfig vala gperf libxml2 ];
  buildInputs = [ gnome3.glib gnome3.gtk3 ncurses ];

  propagatedBuildInputs = [
    # Required by vte-2.91.pc.
    gnome3.gtk3
    gnutls
    pcre2
  ];

  preConfigure = "patchShebangs .";

  configureFlags = [ "--enable-introspection" "--disable-Bsymbolic" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://www.gnome.org/;
    description = "A library implementing a terminal emulator widget for GTK+";
    longDescription = ''
      VTE is a library (libvte) implementing a terminal emulator widget for
      GTK+, and a minimal sample application (vte) using that.  Vte is
      mainly used in gnome-terminal, but can also be used to embed a
      console/terminal in games, editors, IDEs, etc. VTE supports Unicode and
      character set conversion, as well as emulating any terminal known to
      the system's terminfo database.
    '';
    license = licenses.lgpl2;
    maintainers = with maintainers; [ astsmtl antono lethalman ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}

