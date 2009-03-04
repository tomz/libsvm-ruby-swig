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

== LICENSE:

(The MIT License)

Copyright (c) 2009 Tom Zeng

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
