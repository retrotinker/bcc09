Name:           bcc09
Version:        0.13.0
Release:        1%{?dist}
Summary:        C compiler, assembler, linker and C library for the Motorola 6809

# The tools are dev86's (GPL-2.0-or-later; ar09 GPL-1.0-or-later); libc is
# dev86's (LGPL-2.0-or-later) with bcc09's own files (LGPL-2.0-only), and
# its math functions are Sun's fdlibm (SunPro)
License:        GPL-2.0-or-later AND GPL-1.0-or-later AND LGPL-2.0-or-later AND LGPL-2.0-only AND SunPro
URL:            https://github.com/retrotinker/bcc09
Source0:        %{url}/archive/v%{version}/%{name}-%{version}.tar.gz
Source1:        %{name}.rpmlintrc

BuildRequires:  gcc
BuildRequires:  make
# for %%check: the simulator the tests run their programs on
# (https://github.com/retrotinker/sim6809)
BuildRequires:  sim6809 >= 1.2.0
BuildRequires:  python3
BuildRequires:  groff-base
# the PDF manuals (installed with it unless left out)
Recommends:     %{name}-doc = %{version}-%{release}

%description
bcc09 is a C compiler for the Motorola MC6809, with its preprocessor,
peephole optimizer, assembler (as09), linker (ld09), librarian (ar09)
and binary utilities (objdump09, nm09, size09, and objcopy09, which
writes binary, S-record, Intel hex, cassette, Disk BASIC, DragonDOS,
OS-9 module and FLEX files). It is derived from the 6809 configuration
of Bruce Evans' C compiler, as dev86 has it.

It includes a C library (standard I/O, strings, memory allocation, the
math functions with IEEE floating point, and fixed-width integer and
boolean types), and start-up code and system functions for the Tandy
Color Computer and Dragon (Color BASIC and Disk BASIC), OS-9 and
NitrOS-9, and FLEX.

%package doc
Summary:        Manuals for bcc09: the user's manual and bcc09 for BASIC Programmers
BuildArch:      noarch

%description doc
The PDF manuals for bcc09, the C compiler and tools for the Motorola 6809:
the user's manual (building and installing, the C it compiles, each target,
the C library, the calling conventions, the tools and the tests, with the
manual pages as an appendix), and bcc09 for BASIC Programmers, a guide to C
for those who know the Color Computer's and Dragon's Color BASIC.

%prep
%autosetup
# three READMEs: libc's two are packaged under their own names
cp -p libc/README README.libc
cp -p libc/math/README README.libm

%build
%set_build_flags
%make_build PREFIX=%{_prefix}

%install
%make_install PREFIX=%{_prefix} MANDIR=%{_mandir}

%check
%make_build PREFIX=%{_prefix} check

%files
%license COPYING libc/COPYING.LIB
%doc README README.libc README.libm BUGS TODO
%{_bindir}/bcc09
%{_bindir}/as09
%{_bindir}/ld09
%{_bindir}/ar09
%{_bindir}/objdump09
%{_bindir}/nm09
%{_bindir}/size09
%{_bindir}/objcopy09
%{_libexecdir}/%{name}/
%{_datadir}/%{name}/
%{_mandir}/man1/bcc09.1*
%{_mandir}/man1/bcc09-*.1*
%{_mandir}/man1/as09.1*
%{_mandir}/man1/ld09.1*
%{_mandir}/man1/ar09.1*
%{_mandir}/man1/objdump09.1*
%{_mandir}/man1/nm09.1*
%{_mandir}/man1/size09.1*
%{_mandir}/man1/objcopy09.1*

%files doc
%license COPYING libc/COPYING.LIB
%doc doc/manual.pdf doc/basic.pdf

%changelog
* Wed Nov 11 2026 John W. Linville <linville@tuxdriver.com> - 0.13.0-1
- Direct-page variables: cc1's __direct puts a global or static variable
  in the 6809's direct page (a byte smaller and a cycle faster to reach);
  the start-up code sets DP to its page, and libc's calls into Color
  BASIC's ROM, FLEX, the Vectrex BIOS and OS-9 keep it; ld09 refuses
  modules that disagree on a variable being __direct
- as09: OS9, an OS-9 system call, and $ in symbols (I$WritLn)
- cc1: -c- and -f- are errors (they were silently ignored)
- make install puts bcc09 in /usr/local by default

* Tue Nov 10 2026 John W. Linville <linville@tuxdriver.com> - 0.12.0-1
- libc: %%a and %%A in printf, as glibc prints them
- libc: faster floating point (float arithmetic 2 to 2.5 times as fast,
  double division 1.8 times), every result the same
- ld09: a common block is no reason to load another module (FLEX
  programs with files 10K smaller, programs with math.h 7K)

* Tue Nov 10 2026 John W. Linville <linville@tuxdriver.com> - 0.11.2-3
- bcc09 recommends bcc09-doc, the PDF manuals

* Tue Nov 10 2026 John W. Linville <linville@tuxdriver.com> - 0.11.2-2
- The PDF manuals (the user's manual and bcc09 for BASIC Programmers) are
  in a noarch subpackage, bcc09-doc

* Tue Nov 10 2026 John W. Linville <linville@tuxdriver.com> - 0.11.2-1
- libc: rmdir() and getcwd() for OS-9 (-Mo), which has no calls for them
- The tests need sim6809 1.2.0 (BuildRequires sim6809 >= 1.2.0)

* Tue Nov 10 2026 John W. Linville <linville@tuxdriver.com> - 0.11.1-1
- coco.h: sound(tone, duration), as BASIC's SOUND, with its pitches
- The tests run on sim6809 from its own project (BuildRequires sim6809),
  which times sound()'s periods to the cycle
- BUGS: the direct-page entry described nothing cc1 does

* Tue Nov 10 2026 John W. Linville <linville@tuxdriver.com> - 0.11.0-1
- coco.h: inkey, cls, locate and joystk for Color BASIC programs and
  cartridges; stdio flushes stdout at the end of a '\r' line
- doc/basic.pdf: bcc09 for BASIC Programmers, a guide to C from Color
  BASIC, packaged as documentation
- copt: five more rules (libc 499 bytes smaller)

* Mon Nov 09 2026 John W. Linville <linville@tuxdriver.com> - 0.10.0-1
- bcc09 -Mv: Vectrex cartridges, with the BIOS's routines in vectrex.h
- ld09: a symbol defined again is warned about only if both modules are
  linked

* Mon Nov 09 2026 John W. Linville <linville@tuxdriver.com> - 0.9.0-1
- ld09: linker scripts (-S, -A, -P, -Z), from ld01 in mc6801-tools; the
  default script gives the same layout as before
- bcc09 -Mr: Color BASIC ROM cartridges for the CoCo and the Dragon
- libc: exit() flushes stdio after the atexit() functions
- bcc09, as09 and ld09 print their version with -v

* Mon Nov 09 2026 John W. Linville <linville@tuxdriver.com> - 0.8.0-1
- First package
