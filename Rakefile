require 'rubygems'
gem 'hoe', '>=1.8.3','<= 1.12.2'
require 'hoe'

task :default => ["sync_files","make_gem"] 

EXT = "ext/svm?.#{Hoe::DLEXT}"

Hoe.new('libsvm-ruby-swig', '0.3.3') do |p|
  p.author = 'Tom Zeng'
  p.email = 'tom.z.zeng@gmail.com'
  p.url = 'http://www.tomzconsulting.com'
  p.summary = 'Ruby wrapper of LIBSVM using SWIG'
  p.description = 'Ruby wrapper of LIBSVM using SWIG'
  
  p.spec_extras[:extensions] = "ext/extconf.rb"
  p.clean_globs << EXT << "ext/*.o" << "ext/Makefile"
end

task :make_gem => EXT

file EXT => ["ext/extconf.rb", "ext/libsvm_wrap.cxx", "ext/svm.cpp", "ext/svm.h"] do
  Dir.chdir "ext" do
    ruby "extconf.rb"
    sh "make"
  end
end

task :sync_files do
  cp "libsvm-2.89/svm.h","ext/"
  cp "libsvm-2.89/svm.cpp","ext/"
  cp "libsvm-2.89/ruby/libsvm_wrap.cxx","ext/"
  cp "libsvm-2.89/ruby/svm.rb","lib/"
end

task :test do
  puts "done"
end
