Build packages for:

* https://launchpad.net/~no1wantdthisname/+archive/ppa
* https://launchpad.net/~no1wantdthisname/+archive/openjdk-fontfix

# FAQ

## Can you support version X?

Probably.
Just open an issue.

It's usually easy to add a new version.
It'll just take a few days for me to do it.

## Why doesn't X work?

I have no idea.

Ha ha, seriously.

PRs are very welcome. Because:

* Debian packaging is incredibly complicated.
  * All I want to do is

    ```
    git clone git@github.com:someone/freetype6-patched
    cd freetype6-patched
    ./build
    ```

    Why does it have to require so many patches and special deb commands???
* There's a lot of applications with different configurations.
  * I don't use PyCharm, and thus I don't know why it doesn't work.
* There are way too many versions to support.
  * Why are you guys still on 12.04?!
  * Or the bleeding edge version, Herpy Derpy?
  * I generally stick to the last release, so I can't test these other versions.
