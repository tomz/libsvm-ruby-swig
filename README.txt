= libsvm-ruby-swig

* Ruby interface to LIBSVM (using SWIG)
* http://www.tomzconsulting.com

== DESCRIPTION:

This is the Ruby port of the LIBSVM Python SWIG (Simplified Wrapper and 
Interface Generator) interface.

A modified version of LIBSVM 2.88 is included, it contains changes merged from:
  git://github.com/npinto/libsvm-2.88_objs-np.git
  git://github.com/alanfalloon/libsvm-2.88_output_model_params.git
to expose additional data/parameters in the model object. You don't need your
own copy of SWIG to use this library - all needed files are generated using
SWIG already.

Look for the README file in the ruby subdirectory for instructions.
The binaries included were built under Ubuntu Linux 2.6.24-23-generic,
you should run make under the libsvm-2.88 and libsvm-2.88/ruby 
directories to regenerate the executables for your environment.

== INSTALL:
Currently the gem is available on linux only(tested on Ubuntu 8 and Fedora 9/10,
and on OS X by danielsdeleo), and you will need g++ installed to compile the 
native code. 

  sudo gem sources -a http://gems.github.com   (you only have to do this once)
  sudo gem install tomz-libsvm-ruby-swig

== SYNOPSIS:

Quick Interactive Tutorial using irb (adopted from the python code from Toby
Segaran's "Programming Collective Intelligence" book):

  irb(main):001:0> require 'svm'
  => true
  irb(main):002:0> prob = Problem.new([1,-1],[[1,0,1],[-1,0,-1]])
  irb(main):003:0> param = Parameter.new(:kernel_type => LINEAR, :C => 10)
  irb(main):004:0> m = Model.new(prob,param)
  irb(main):005:0> m.predict([1,1,1])
  => 1.0
  irb(main):006:0> m.predict([0,0,1])
  => 1.0
  irb(main):007:0> m.predict([0,0,-1])
  => -1.0
  irb(main):008:0> m.save("test.model")
  irb(main):009:0> m2 = Model.new("test.model")
  irb(main):010:0> m2.predict([0,0,-1])
  => -1.0

== AUTHOR:

Tom Zeng
http://www.tomzconsulting.com
http://www.linkedin.com/in/tomzeng
tom.z.zeng _at_ gmail _dot_ com

