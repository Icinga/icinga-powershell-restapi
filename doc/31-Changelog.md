# Icinga PowerShell REST-Api CHANGELOG

**The latest release announcements are available on [https://icinga.com/blog/](https://icinga.com/blog/).**

Please read the [upgrading](https://icinga.com/docs/windows/latest/restapi/doc/30-Upgrading-REST-Api)
documentation before upgrading to a new release.

Released closed milestones can be found on [GitHub](https://github.com/Icinga/icinga-powershell-restapi/milestones?state=closed).

## 1.2.0 (2021-09-07)

[Issue and PRs](https://github.com/Icinga/icinga-powershell-restapi/milestone/2?closed=1)

## 1.1.1 (2021-07-07)

[Issue and PRs](https://github.com/Icinga/icinga-powershell-restapi/milestone/3?closed=1)

## Bugfixes

* [#5](https://github.com/Icinga/icinga-powershell-restapi/pull/5) Fixes memory leak on REST-Api and now forces error and memory cleanup

## 1.1.0 (2021-03-02)

[Issue and PRs](https://github.com/Icinga/icinga-powershell-restapi/milestone/1?closed=1)

### Enhancements

* [#1](https://github.com/Icinga/icinga-powershell-restapi/pull/1) Improves REST-Api performance by using static background threads for new calls which are queued inside them, instead of creating new threads and terminating them afterwards for each request
* [#2](https://github.com/Icinga/icinga-powershell-restapi/pull/2) Adds support to blacklist or whitelist commands executed by Api endpoints


## 1.0.0 (2020-06-02)

### Notes

Initial release
