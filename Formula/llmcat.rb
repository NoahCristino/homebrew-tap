class Llmcat < Formula
  desc "A simple CLI that transforms your code into clean, structured text for feeding into LLMs."
  homepage "https://github.com/NoahCristino/llmcat"
  version "1.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/NoahCristino/llmcat/releases/download/v1.2.0/llmcat-aarch64-apple-darwin.tar.xz"
      sha256 "6d639f62d84fe6cdad05d3d02b50e1bfa712f04a44a0c1dfe20fdbe5312be8d2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/NoahCristino/llmcat/releases/download/v1.2.0/llmcat-x86_64-apple-darwin.tar.xz"
      sha256 "f030386d38bebcdde14d50ac578f1856649b933ddbcdf66313f4c36ffedea4b8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/NoahCristino/llmcat/releases/download/v1.2.0/llmcat-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5dfafedf60e14dbc68ab7c38ab7bbff87c5176c306423aa4fb7d9f90281f4711"
    end
    if Hardware::CPU.intel?
      url "https://github.com/NoahCristino/llmcat/releases/download/v1.2.0/llmcat-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c402ba76951dcb383c42ef19728b8624f18b28a647855853770b8b5c9c0f2898"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
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
    bin.install "llmcat" if OS.mac? && Hardware::CPU.arm?
    bin.install "llmcat" if OS.mac? && Hardware::CPU.intel?
    bin.install "llmcat" if OS.linux? && Hardware::CPU.arm?
    bin.install "llmcat" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
