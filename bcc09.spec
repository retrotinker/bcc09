Name:           bcc09
Version:        0.10.0
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
# for %%check
BuildRequires:  python3
BuildRequires:  groff-base

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
%doc README README.libc README.libm BUGS TODO doc/manual.pdf
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

%changelog
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
