class Subscale < Formula
  desc "Named secondary Tailscale connections"
  homepage "https://github.com/hyuck0221/subscale"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/hyuck0221/subscale/releases/download/v0.1.4/subscale_darwin_arm64.tar.gz"
      sha256 "ad48296c8c4fee242425722be1fffbd4609b4d3e4b0df6d931a144840ca697ca"
    end
    on_intel do
      url "https://github.com/hyuck0221/subscale/releases/download/v0.1.4/subscale_darwin_amd64.tar.gz"
      sha256 "15ffbfa4e8514a59b5ec4cb79f89a2277291d7b510222749cde320505f014165"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/hyuck0221/subscale/releases/download/v0.1.4/subscale_linux_arm64.tar.gz"
      sha256 "acc0ace6809529c40d47cb2b27051bf20fa3b83c5263b8af5d4e73c17067202b"
    end
    on_intel do
      url "https://github.com/hyuck0221/subscale/releases/download/v0.1.4/subscale_linux_amd64.tar.gz"
      sha256 "950e97add6442a63f0efe549411874722b26d43a1eb804c89a7609e1a1c365ee"
    end
  end

  def install
    libexec.install "subscale"
    (bin/"subscale").write <<~SH
      #!/bin/bash
      case "${1:-}" in
        update|upgrade)
          echo "Use: brew upgrade hyuck0221/tap/subscale" >&2
          exit 1
          ;;
        service)
          case "${2:-}" in
            install|uninstall)
              echo "Use: brew services start|stop hyuck0221/tap/subscale" >&2
              exit 1
              ;;
          esac
          ;;
      esac
      exec "#{opt_libexec}/subscale" "$@"
    SH
  end

  def caveats
    <<~EOS
      Update with: brew upgrade hyuck0221/tap/subscale
      If migrating from the script installer, stop its daemon and remove its
      login service before starting the Homebrew service. Existing accounts,
      routing rules and TCP forwards use the same configuration directory.
      Check `which -a subscale` for an older binary earlier in PATH.
    EOS
  end

  service do
    run [opt_libexec/"subscale", "daemon"]
    keep_alive successful_exit: false
    log_path var/"log/subscale.log"
    error_log_path var/"log/subscale.log"
  end

  test do
    assert_equal "subscale v#{version}", shell_output("#{bin}/subscale version").strip
    assert_match "forward add", shell_output("#{bin}/subscale --help")
    assert_match "brew upgrade", shell_output("#{bin}/subscale update 2>&1", 1)
    assert_match "brew upgrade", shell_output("#{bin}/subscale upgrade 2>&1", 1)
    assert_match "brew services", shell_output("#{bin}/subscale service install 2>&1", 1)
  end
end
