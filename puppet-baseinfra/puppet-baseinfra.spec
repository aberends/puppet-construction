Name:         puppet-baseinfra
Version:      0.1.1
Release:      4
Summary:      Linux basic infrastructure
Group:        Applications/System
License:      GPL
Vendor:       MSAT
Source:       %{name}.tar.gz
BuildRoot:    %{_tmppath}/%{name}-root
Requires:     puppet-structure
Requires:     puppet-stdlib

%description

%prep
%setup -q -n %{name}

%build
# Empty.

%install
rm -rf $RPM_BUILD_ROOT
mkdir $RPM_BUILD_ROOT
cp -R etc usr $RPM_BUILD_ROOT

%clean
rm -rf $RPM_BUILD_ROOT

%pre
# Empty.

%post
# Empty.

%preun
# Empty.

%postun
# Empty.

%files
%defattr(0644,root,root)
/etc/puppet/modules/abutil
/etc/puppet/modules/dev
/etc/puppet/modules/dns
/etc/puppet/modules/iptables
/etc/puppet/modules/ldap
/etc/puppet/modules/lvs
/etc/puppet/modules/ntp
/etc/puppet/modules/profiles
/etc/puppet/modules/prov
/etc/puppet/modules/rhn_channel
/etc/puppet/modules/roles
/etc/puppet/modules/support6
/etc/puppet/modules/test
%doc /usr/share/doc/%{name}

%changelog
* Sat Aug 2 2014 Allard Berends <allard.berends@example.com> - 0.1.1-4.el5
- Added the prov::proxy Puppet module
* Mon Jul 14 2014 Allard Berends <allard.berends@example.com> - 0.1.1-3.el5
- Added the support Puppet module
* Sun Jun 22 2014 Allard Berends <allard.berends@example.com> - 0.1.1-2.el5
- Added the support Puppet module
* Sat Jun 21 2014 Allard Berends <allard.berends@example.com> - 0.1.1-1.el5
- Initial creation of the RPM
