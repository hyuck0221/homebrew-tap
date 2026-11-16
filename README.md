# Homebrew Tap

## Install

```sh
brew install hyuck0221/tap/subscale
```

If Homebrew requests trust for this tap:

```sh
brew tap hyuck0221/tap
brew trust --formula hyuck0221/tap/subscale
brew install hyuck0221/tap/subscale
```

## Run at login

```sh
brew services start hyuck0221/tap/subscale
```

## Update

```sh
brew update
brew upgrade hyuck0221/tap/subscale
brew services restart hyuck0221/tap/subscale
```

## Uninstall

```sh
brew services stop hyuck0221/tap/subscale
brew uninstall hyuck0221/tap/subscale
```

Accounts and configuration are retained.

## Migrate from the install script

Before starting the Homebrew service, remove the old login service if installed:

```sh
~/.local/bin/subscale service uninstall
```

If running without a login service, stop the old daemon:

```sh
~/.local/bin/subscale stop
```

Run `which -a subscale` and ensure the Homebrew executable comes first in PATH.
The existing accounts, routing rules and TCP forwards are reused automatically.

## Maintain

For each release, update all four download URLs and their SHA-256
values in `Formula/subscale.rb` using the release's `checksums.txt`.

```sh
brew style Formula/subscale.rb
brew audit --strict hyuck0221/tap/subscale
brew test hyuck0221/tap/subscale
```

[subscale usage](https://github.com/hyuck0221/subscale)
