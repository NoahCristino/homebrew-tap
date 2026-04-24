class Llmcat < Formula
  desc "A simple CLI that transforms your code into clean, structured text for feeding into LLMs."
  homepage "https://github.com/NoahCristino/llmcat"
  version "1.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/NoahCristino/llmcat/releases/download/v1.3.0/llmcat-aarch64-apple-darwin.tar.xz"
      sha256 "d91cf3874678f658edbf0aa33116e1d10ac05f9592f14f28c9207d6d2dbab2b4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/NoahCristino/llmcat/releases/download/v1.3.0/llmcat-x86_64-apple-darwin.tar.xz"
      sha256 "6f1588b6ce1ca764385b90d1c7139203dae01bd104e66ddf2b04fa721c1ede77"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/NoahCristino/llmcat/releases/download/v1.3.0/llmcat-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ec22a9c98348f81620fafcf789607d5674bfb063a002c1be88c820e7c1f3b751"
    end
    if Hardware::CPU.intel?
      url "https://github.com/NoahCristino/llmcat/releases/download/v1.3.0/llmcat-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "02fcef43f1ee97c47dcef3db2ddce740ad3eda69e67a0b70285499e2e118dba3"
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
