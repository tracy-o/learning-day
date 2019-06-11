Name: ingress
Version: %{cosmosversion}
Release: 1%{?dist}
License: MPL-2.0
Group: Development/Frameworks
URL: https://github.com/bbc/ingress
Summary: Entry point for the Belfrage smart proxy service
Packager: BBC News Frameworks and Tools

Source0: ingress.tar.gz
Source1: ingress.service
Source2: bake-scripts.tar.gz
Source3: ingress-status-cfn-signal.sh
Source4: cloudformation-signal.service
Source5: nofile.conf

BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root
BuildArch: x86_64

Requires: cosmos-ca-chains cosmos-ca-tools
Requires: bbc-statsd-cloudwatch
Requires: amazon-cloudwatch-agent
Requires: cfn-signal
Requires: component-logger

%description
Ingress is a proxy pass translating incoming web requests
from browsers to the lambda web renderers of web-core

%pre
/usr/bin/getent group component >/dev/null || groupadd -r component
/usr/bin/getent passwd component >/dev/null || useradd -r -g component -G component -s /sbin/nologin -c 'component service' component
/usr/bin/chsh -s /bin/bash component

%install
mkdir -p %{buildroot}/home/component
mkdir -p %{buildroot}/home/component/ingress
mkdir -p %{buildroot}/etc/security/limits.d
tar -C %{buildroot}/home/component/ingress -xzf %{SOURCE0}
mkdir -p %{buildroot}/usr/lib/systemd/system
cp %{SOURCE1} %{buildroot}/usr/lib/systemd/system/ingress.service
mkdir -p %{buildroot}%{_sysconfdir}/systemd/system/ingress.service.d
touch %{buildroot}%{_sysconfdir}/systemd/system/ingress.service.d/env.conf
mkdir -p %{buildroot}%{_sysconfdir}/bake-scripts/%{name}
tar -C %{buildroot}%{_sysconfdir}/bake-scripts/%{name} -xzf %{SOURCE2} --strip 1
cp %{SOURCE3} %{buildroot}/home/component/ingress-status-cfn-signal.sh
cp %{SOURCE4} %{buildroot}/usr/lib/systemd/system/cloudformation-signal.service
mkdir -p %{buildroot}/var/log/component
touch %{buildroot}/var/log/component/app.log
cp %{SOURCE5} %{buildroot}/etc/security/limits.d/nofile.conf

%post
systemctl enable ingress
systemctl enable cloudformation-signal
/bin/chown -R component:component /home/component
/bin/chown -R component:component /var/log/component

%files
%attr(0755, component, component) /etc/bake-scripts/%{name}/*
%attr(0755, component, component) /home/component/ingress-status-cfn-signal.sh
/home/component
/usr/lib/systemd/system/ingress.service
/usr/lib/systemd/system/cloudformation-signal.service
/etc/bake-scripts/%{name}
/etc/systemd/system/ingress.service.d/env.conf
/var/log/component/app.log
/etc/security/limits.d/nofile.conf