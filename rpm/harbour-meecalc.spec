Name:       harbour-meecalc
Summary:    Calculator
Version:    1.0.10
Release:    1
Group:      Applications/Productivity
License:    BSD
Vendor:     meego
URL:        https://github.com/monich/harbour-meecalc
Source0:    %{name}-%{version}.tar.bz2

Requires:      sailfishsilica-qt5 >= 0.10.9
Requires:      qt5-qtsvg-plugin-imageformat-svg
BuildRequires: qt5-qttools-linguist
BuildRequires: pkgconfig(sailfishapp) >= 1.0.2
BuildRequires: pkgconfig(Qt5Core)
BuildRequires: pkgconfig(Qt5Qml)
BuildRequires: pkgconfig(Qt5Quick)
BuildRequires: desktop-file-utils

%{!?qtc_qmake:%define qtc_qmake %qmake}
%{!?qtc_qmake5:%define qtc_qmake5 %qmake5}
%{!?qtc_make:%define qtc_make make}
%{?qtc_builddir:%define _builddir %qtc_builddir}

%description
N9 style calculator

%if "%{?vendor}" == "chum"
Categories:
 - Office
Icon: https://raw.githubusercontent.com/monich/harbour-meecalc/master/icons/harbour-meecalc.svg
Screenshots:
- https://home.monich.net/chum/harbour-meecalc/screenshots/screenshot-001.png
%endif

%prep
%setup -q -n %{name}-%{version}

%build
%qtc_qmake5
%qtc_make %{?_smp_mflags}

%install
rm -rf %{buildroot}
%qmake5_install

desktop-file-install --delete-original \
  --dir %{buildroot}%{_datadir}/applications \
   %{buildroot}%{_datadir}/applications/*.desktop

%files
%defattr(-,root,root,-)
%{_bindir}/%{name}
%{_datadir}/%{name}
%{_datadir}/applications/%{name}.desktop
%{_datadir}/icons/hicolor/*/apps/%{name}.png
