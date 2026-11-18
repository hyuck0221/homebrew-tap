class Subscale < Formula
  desc "Named secondary Tailscale connections"
  homepage "https://github.com/hyuck0221/subscale"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/hyuck0221/subscale/releases/download/v0.1.5/subscale_darwin_arm64.tar.gz"
      sha256 "d8e2ee21177d5e879105ad7661c9a03daa7fabcfca38daf386c3392623e9c6e1"
    end
    on_intel do
      url "https://github.com/hyuck0221/subscale/releases/download/v0.1.5/subscale_darwin_amd64.tar.gz"
      sha256 "bb1c1e45a592eba5352b8d9302958085ef64aa994a18478087e94429a938ccf3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/hyuck0221/subscale/releases/download/v0.1.5/subscale_linux_arm64.tar.gz"
      sha256 "7d3ff5065189fb41b2af91c0890835c2db392ab34d708a1e861f06c7be79de5e"
    end
    on_intel do
      url "https://github.com/hyuck0221/subscale/releases/download/v0.1.5/subscale_linux_amd64.tar.gz"
      sha256 "7a23f168f6b73aeade8f240d04930f4557d641f4882a038c2278a36f5d75c1ff"
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
