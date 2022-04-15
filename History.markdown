## 0.8.0 / 2022-04-15

### Minor Enhancements

  * Use `Kernel#format` to render `<img />` HTML tag (#46)
  * Check if username and size matches a pattern once (#48)

### Bug Fixes

  * Reduce allocations from computing username (#44)
  * Stringify keys of `:attributes` hash (#42)
  * Parse tag markup once per instance (#40)
  * Compute `:srcset` with an array of integer strings (#43)
  * Assign string values for attributes (#47)
  * Parse only custom-host provided through ENV (#45)

### Development Fixes

  * Profile memory usage from rendering avatars (#41)
  * Bundle only relevant files in the gem (#50)
  * Upgrade to GitHub-native Dependabot (#52)
  * Remove redundant specifications (#56)
  * Improve context in workflow job names (#57)
  * Remove `@benbalter`-specific community health files (#58)
  * Update gem specification (#60)
  * Add workflow to release gem via GH Actions (#63)

### Documentation

  * Fix typo in README.md (#62)

## 0.7.0 / 2019-08-12

Refer [`v0.7.0` Release Note](https://github.com/jekyll/jekyll-avatar/releases/tag/v0.7.0) to see
what changed since previous release.
