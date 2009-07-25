require 'rake'
require 'rake/clean'
require 'rake/gempackagetask'
require 'rake/rdoctask'

NAME      = 'Eleanor'
UNIX_NAME = NAME.downcase
VER       = '1.0.0'

NONLIB_RDOC_FILES = %w[CHANGELOG INSTALL LICENSE README src/ragel/parser.rl]

RDOC_FILES        = NONLIB_RDOC_FILES +
                    %w[lib/eleanor.rb
                       lib/eleanor/hpdfpaper.rb
                       lib/eleanor/length.rb]

RDOC_OPTS         = ['--inline-source',
                     '--extension', 'rl=rb',
                     '--exclude', 'lib/eleanor/parser.rb',
                     '--title', "#{NAME} #{VER} Reference",
                     '--main', 'README']


PKG_FILES = FileList['CHANGELOG', 'INSTALL', 'LICENSE', 'README',
                     'Rakefile', 'setup.rb',
                     'bin/*', 'data/**/*', 'examples/*.txt',
                     'lib/*', 'lib/**/*', 'src/**/*']

CLEAN.include %w[.config InstalledFiles doc examples/*.pdf pkg]

GEMSPEC=
  Gem::Specification.new do |s|
    s.name= UNIX_NAME
    s.version= VER
    s.has_rdoc= true
    s.rdoc_options += RDOC_OPTS
    s.extra_rdoc_files= NONLIB_RDOC_FILES
    s.summary= 'Formats speculative screenplays'
    s.description= <<-EOF
      Eleanor is a Ruby script and accompanying library for formatting
      speculative screenplays.  It parses plain text written in a simple format
      and outputs pretty PDF that conforms to standard rules of screenplay
      layout.  Eleanor's primary goal is to create PDF that is indistinguishable
      from PDF produced by professional screenwriting software such as Final
      Draft.
    EOF
    s.author= 'chiisaitsu'
    s.email= 'chiisaitsu@gmail.com'
    s.homepage= 'http://rubyforge.org/projects/eleanor'
    s.files= PKG_FILES
    s.executables= ['eleanor']
    s.requirements << 'libHaru Free PDF Library: http://libharu.org'    
    s.rubyforge_project= 'eleanor'
  end

desc 'rake build'
task :default => [:build]

desc 'Build the parser with Ragel'
task :build do
  sh "ragel -R -o lib/eleanor/parser.rb src/ragel/parser.rl"
end

desc 'Build the examples'
task :examples do
  Dir.glob('examples/*.txt') do |fname|
    sh "ruby -I./lib bin/eleanor -c data/eleanor/eleanor.yaml #{fname}"
  end
end

desc 'Install to site_ruby'
task :install do
  sh "ruby setup.rb"
end

task :package => [:clean]

Rake::GemPackageTask.new(GEMSPEC) do |t|
  t.need_tar_gz= true
  t.need_zip= true
  t.gem_spec= GEMSPEC
end

Rake::RDocTask.new do |t|
  t.options= RDOC_OPTS
  t.rdoc_dir= 'doc/rdoc'
  t.rdoc_files= RDOC_FILES
end
