Name: belfrage
Version: %{cosmosversion}
Release: 1%{?dist}
License: MPL-2.0
Group: Development/Frameworks
URL: https://github.com/bbc/belfrage
Summary: Entry point for the Belfrage smart proxy service
Packager: BBC News Frameworks and Tools

Source0: belfrage.tar.gz
Source1: belfrage.service
Source2: bake-scripts.tar.gz
Source3: belfrage-status-cfn-signal.sh
Source4: cloudformation-signal.service
Source5: cloudwatch
Source6: component-cron

BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root
BuildArch: x86_64

Requires: cosmos-ca-chains cosmos-ca-tools
Requires: bbc-statsd-cloudwatch
Requires: bbc-error-pages
Requires: amazon-cloudwatch-agent
Requires: cfn-signal
Requires: component-logger
Requires: belfrage-performance-tuning
Requires: dial-agent
Requires: xray

%description
Belfrage is a proxy pass translating incoming web requests
from browsers to the lambda web renderers of web-core

%pre
/usr/bin/getent group component >/dev/null || groupadd -r component
/usr/bin/getent passwd component >/dev/null || useradd -r -g component -G component -s /sbin/nologin -c 'component service' component
/usr/bin/chsh -s /bin/bash component

%install
mkdir -p %{buildroot}/home/component
mkdir -p %{buildroot}/home/component/belfrage
tar -C %{buildroot}/home/component/belfrage -xzf %{SOURCE0}
mkdir -p %{buildroot}/usr/lib/systemd/system
cp %{SOURCE1} %{buildroot}/usr/lib/systemd/system/belfrage.service
mkdir -p %{buildroot}%{_sysconfdir}/systemd/system/belfrage.service.d
touch %{buildroot}%{_sysconfdir}/systemd/system/belfrage.service.d/env.conf
mkdir -p %{buildroot}%{_sysconfdir}/bake-scripts/%{name}
tar -C %{buildroot}%{_sysconfdir}/bake-scripts/%{name} -xzf %{SOURCE2} --strip 1
cp %{SOURCE3} %{buildroot}/home/component/belfrage-status-cfn-signal.sh
cp %{SOURCE4} %{buildroot}/usr/lib/systemd/system/cloudformation-signal.service
mkdir -p %{buildroot}/var/log/component
touch %{buildroot}/var/log/component/app.log
touch %{buildroot}/var/log/component/cloudwatch.log
mkdir -p %{buildroot}/etc/logrotate.d
cp -p %{SOURCE5} %{buildroot}/etc/logrotate.d/cloudwatch
# cp -p %{SOURCE6} %{buildroot}/etc/cron.d/component-cron

%post
systemctl enable belfrage
systemctl enable cloudformation-signal
/bin/chown -R component:component /home/component
/bin/chown -R component:component /var/log/component
cp /etc/cron.daily/logrotate /etc/cron.hourly/logrotate

%files
%attr(0755, component, component) /etc/bake-scripts/%{name}/*
%attr(0755, component, component) /home/component/belfrage-status-cfn-signal.sh
%attr(0644, root, root) /etc/logrotate.d/cloudwatch
# %attr(0644, root, root) /etc/cron.d/component-cron
/home/component
/usr/lib/systemd/system/belfrage.service
/usr/lib/systemd/system/cloudformation-signal.service
/etc/bake-scripts/%{name}
/etc/systemd/system/belfrage.service.d/env.conf
/var/log/component/app.log
/var/log/component/cloudwatch.log
