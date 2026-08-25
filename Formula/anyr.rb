class Anyr < Formula
  desc "CLI for Anytype - list, search, and perform CRUD operations on Anytype objects."
  homepage "https://github.com/stevelr/anytype"
  version "0.5.3"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/stevelr/anytype/releases/download/anyr-v0.5.3/anyr-aarch64-apple-darwin.tar.xz"
    sha256 "49780a05e8dc28b44887c6b3960459afdd91ab3b17ac14c703d996ba07bea792"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/stevelr/anytype/releases/download/anyr-v0.5.3/anyr-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "000811aaa3518ec501e91169a3af12b18d0b8848fcbc4ab538336a96ae71e7bd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevelr/anytype/releases/download/anyr-v0.5.3/anyr-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "558c959042ea25f962d37cab5deaf2334f8ceecbc305e5f8e278ce04df843fa1"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-pc-windows-gnu":    {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "anyr"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "anyr"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "anyr"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
