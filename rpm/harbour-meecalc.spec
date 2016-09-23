Name:       harbour-meecalc
Summary:    Calculator
Version:    1.0.6
Release:    1
Group:      Qt/Qt
License:    BSD
Vendor:     meego
URL:        http://github.com/monich/harbour-meecalc
Source0:    %{name}-%{version}.tar.bz2

Requires:      sailfishsilica-qt5 >= 0.10.9
Requires:      qt5-qtsvg-plugin-imageformat-svg
BuildRequires: qt5-qttools-linguist
BuildRequires: pkgconfig(sailfishapp) >= 1.0.2
BuildRequires: pkgconfig(Qt5Core)
BuildRequires: pkgconfig(Qt5Qml)
BuildRequires: pkgconfig(Qt5Quick)
BuildRequires: pkgconfig(Qt5Svg)
BuildRequires: desktop-file-utils

%{!?qtc_qmake:%define qtc_qmake %qmake}
%{!?qtc_qmake5:%define qtc_qmake5 %qmake5}
%{!?qtc_make:%define qtc_make make}
%{?qtc_builddir:%define _builddir %qtc_builddir}

%description
N9 style calculator

%prep
%setup -q -n %{name}-%{version}

%build
touch harbour-meecalc.pro # Protection against time skew in obs
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

%changelog
* Sat Jul 5 2014 Slava Monich <slava.monich@jolla.com> 1.0.0
- Initial version
