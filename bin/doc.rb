#!/usr/bin/env ruby
# frozen_string_literal: true

# List, search, and show the markdown references under docs/.
#
# Invoked by the doc() launcher in zsh/conf.d/35-doc.zsh, which passes
# the docs directory as the first argument and GLOW_STYLE as an
# environment variable.

require 'optparse'
require 'pathname'

DocError = Class.new(StandardError)

module Mode
  List = Data.define
  Name = Data.define(:name)
  Search = Data.define(:pattern)
end

# Parse doc.rb arguments into Mode
module CLI
  module_function

  def parse!(argv = ARGV)
    options = {}
    options.extend(Module.new do
      def to_mode
        case compact
        in {} | { list: true, **nil } then Mode::List[]
        in { search:, **nil } then Mode::Search[search]
        in { name:, **nil } then Mode::Name[name]
        else raise OptionParser::InvalidArgument,
                   '-l, -k and NAME are mutually exclusive'
        end
      end
    end)
    build_parser.parse!(argv, into: options)
    dir = handle_positional!(argv, into: options)
    [dir, options.to_mode]
  rescue OptionParser::ParseError => e
    warn "Error: #{e.message}"
    warn help
    exit 2
  end

  def help = build_parser.help

  class << self
    private

    def build_parser
      OptionParser.new do |opts|
        opts.banner = 'Usage: doc [options] [NAME]'
        opts.on('-l', '--list', 'List available docs')
        opts.on('-kPATTERN', '--search=PATTERN', 'Search docs for PATTERN')
        opts.on('-h', '--help', 'Print this help') do
          puts opts
          exit 0
        end
      end
    end

    def handle_positional!(argv, into:)
      dir, name, *extra = argv
      raise OptionParser::MissingArgument, 'BASE_DIR' unless dir
      raise Errno::ENOENT, dir unless Dir.exist?(dir)
      raise OptionParser::NeedlessArgument, extra.join(' ') unless extra.empty?

      into[:name] = name
      dir
    end
  end
end

# A markdown document
class Doc
  attr_reader :path

  def initialize(path, dir:)
    @path = path
    @dir = dir
  end

  def name
    Pathname(@path).relative_path_from(@dir).sub_ext('').to_s
  end

  def structure
    structure = []
    File.foreach(@path, chomp: true) do |line|
      if structure.empty?
        structure << line[2..] if line.start_with?('# ')
      elsif line.start_with?('## ') && line[3..] != 'See Also'
        structure << line[3..]
      end
    end
    structure
  end

  def <=>(other)
    @path <=> other
  end

  def to_s = @path.to_s
end

def find_markdown_files(dir)
  Dir.glob(File.join(dir, '**', '*'))
     .select { File.file?(it) && File.extname(it).casecmp?('.md') }
     .map { Doc.new(it, dir:) }
end

def find_by_basename(dir, basename)
  find_markdown_files(dir).select { File.basename(it.path, '.*') == basename }
end

def resolve_doc(dir, name)
  exact = "#{File.join(dir, name)}.md"
  return exact if File.exist?(exact)

  found = find_by_basename(dir, File.basename(name))
  case found.size
  when 0 then raise DocError, "no reference for '#{name}'"
  when 1 then found.first
  else
    names = found.map(&:name)
    raise DocError, "'#{name}' is ambiguous: #{names.join(' ')}"
  end
end

def list_docs(dir)
  files = find_markdown_files(dir).sort
  return if files.empty?

  headers = files.map(&:name)
  width = headers.map(&:length).max
  headers.zip(files).each do |header, f|
    puts "#{header.ljust(width)}  #{f.structure.join(' - ')}"
  end
end

def show_doc(dir, name, style:)
  style_args = style.nil? ? [] : ['--style', style]
  exec('glow', *style_args, '--pager', resolve_doc(dir, name).to_s)
end

def search_docs(dir, pattern)
  Dir.chdir(dir)
  exec('rg', '--smart-case', '--heading', '--line-number',
       '--iglob', '*.md', '--', pattern, '.')
end

def main(argv)
  dir, mode = CLI.parse!(argv)
  case mode
  in Mode::List then list_docs(dir)
  in Mode::Name(name) then show_doc(dir, name,
                                    style: ENV.fetch('GLOW_STYLE', nil))
  in Mode::Search(pattern) then search_docs(dir, pattern)
  end
rescue DocError, Errno::ENOENT => e
  warn "doc: #{e.message}"
  exit 1
end

main(ARGV) if $PROGRAM_NAME == __FILE__
