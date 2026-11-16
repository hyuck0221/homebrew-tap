class Subscale < Formula
  desc "Named secondary Tailscale connections"
  homepage "https://github.com/hyuck0221/subscale"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/hyuck0221/subscale/releases/download/v0.1.3/subscale_darwin_arm64.tar.gz"
      sha256 "62df3f2c6583c6b8cb0ed0f9c03a0051b3e5161a02736a1865505afd2bcbf211"
    end
    on_intel do
      url "https://github.com/hyuck0221/subscale/releases/download/v0.1.3/subscale_darwin_amd64.tar.gz"
      sha256 "d16572474e53a3ae7c0126abf78e963c890aae7e0172da2f9babd812a07e1b68"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/hyuck0221/subscale/releases/download/v0.1.3/subscale_linux_arm64.tar.gz"
      sha256 "6d23f26cfed3f2011f338bd9adc15d9c858043df1a765da24df37665bdca3549"
    end
    on_intel do
      url "https://github.com/hyuck0221/subscale/releases/download/v0.1.3/subscale_linux_amd64.tar.gz"
      sha256 "1e9cd0c82c4019fda1d9d87ac96591275fe24c4196450981529b476283b01cd4"
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
