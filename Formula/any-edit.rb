class AnyEdit < Formula
  desc "Edit Anytype documents in an external editor"
  homepage "https://github.com/stevelr/anytype"
  version "0.1.3"
  if OS.mac? && Hardware::CPU.arm?
      url "https://github.com/stevelr/anytype/releases/download/any-edit-v0.1.3/any-edit-aarch64-apple-darwin.tar.xz"
      sha256 "01d145420a609b03cb6b1db33d59b2f307a584256d63b50eec5214cb6fe05a7f"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/stevelr/anytype/releases/download/any-edit-v0.1.3/any-edit-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d1291d2210a27f7b8af882f28b248341ec487b25a139d4773a85835c4c18303c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/stevelr/anytype/releases/download/any-edit-v0.1.3/any-edit-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "961244f32a405b170d37af6fc0f2939125589d1afc8b6b876ea635e14901cc6a"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
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
    bin.install "any-edit" if OS.mac? && Hardware::CPU.arm?
    bin.install "any-edit" if OS.linux? && Hardware::CPU.arm?
    bin.install "any-edit" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
