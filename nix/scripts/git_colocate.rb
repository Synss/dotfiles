# frozen_string_literal: true

require 'fileutils'
require 'open3'

def capture(*)
  out, status = Open3.capture2(*)
  exit 1 unless status.success?

  out
end

def colocated? = Dir.exist?('.jj')

def ensure_line(name, line)
  if File.exist?(name) && File.readlines(name, chomp: true).include?(line)
    return
  end

  File.write(name, "#{line}\n", mode: 'a')
end

def move_new(src, dst)
  abort "refusing to overwrite existing #{dst}" if File.exist?(dst)

  FileUtils.mkdir_p(File.dirname(dst))
  FileUtils.mv(src, dst)
end

def move_into(files, dir)
  files.each do |relpath|
    move_new(relpath, File.join(dir, relpath))
    puts "moved #{relpath}"
  end
end

def main
  Dir.chdir capture('git', 'rev-parse', '--show-toplevel').chomp
  abort 'already colocated' if colocated?

  untracked_dir = '_untracked'
  FileUtils.mkdir_p untracked_dir
  ensure_line(File.join('.git', 'info', 'exclude'), untracked_dir)
  move_into(
    capture('git', 'ls-files', '-z', '--others', '--exclude-standard')
           .split("\0"),
    untracked_dir
  )
  system('jj', 'git', 'init', '--colocate') or exit 1
end

main if $PROGRAM_NAME == __FILE__
