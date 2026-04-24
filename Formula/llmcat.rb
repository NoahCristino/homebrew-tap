class Llmcat < Formula
  desc "A simple CLI that transforms your code into clean, structured text for feeding into LLMs."
  homepage "https://github.com/NoahCristino/llmcat"
  version "1.3.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/NoahCristino/llmcat/releases/download/v1.3.1/llmcat-aarch64-apple-darwin.tar.xz"
      sha256 "2117a81bfea796edc2a30b441cc54c5affd250d72e01caf1e47781b3f270a00f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/NoahCristino/llmcat/releases/download/v1.3.1/llmcat-x86_64-apple-darwin.tar.xz"
      sha256 "3f0a3f8b14e4827f9dc1ba4d5db0731a4c531a81b78c87405197a02734830208"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/NoahCristino/llmcat/releases/download/v1.3.1/llmcat-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d8a1fc9da3ac2a8e8ca11188c5cf96b75d069a46c7e35ffaeb0e58f7d40b56a8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/NoahCristino/llmcat/releases/download/v1.3.1/llmcat-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "89275977f6b3dfed1ae3c55a33e7ea21af5491b4a014eb4ab0e78249eb2228b1"
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
