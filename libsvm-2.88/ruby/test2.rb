#!/usr/bin/ruby1.8
require 'rubygems'
require 'svm'
#Svmc::info_on = 0
puts "info_on = #{Svmc::info_on}"
puts "TEST of the Ruby libsvm bindings"
puts "------------------------------------"
pa = Parameter.new
pa.C = 100
pa.svm_type = NU_SVC
pa.degree = 1
pa.coef0 = 0
pa.eps= 0.001
#s = Marshal.dump(pa)
#lpa = Marshal.load(s)
labels = [0, 1, 1, 2]
samples = [[0,0], [0,1], [1,0], [1,1]]
#labels.each_index { |i| sp.addExample(labels[i], samples[i]) }
sp = Problem.new(labels,samples)
kernels = [ LINEAR, POLY, RBF, SIGMOID ]
knames = [ 'LINEAR ', 'POLY   ', 'RBF    ', 'SIGMOID' ]
kernels.each_index { |j|
  pa.kernel_type = kernels[j]
  m = Model.new(sp, pa)
  ec = 0
  labels.each_index { |i|
    pred, probs = m.predict_probability(samples[i])
    puts "Got #{pred} and #{probs.inspect} for sample: [#{samples[i].join(',')}]  Label: #{labels[i]}  Pred: #{pred} Kernel: #{knames[j]}"
    ec += 1 if labels[i] != pred
  }
  puts "Kernel #{knames[j]} made #{ec} errors"
}
