#!/usr/bin/env ruby

require 'cross_validation'

labels = []
samples = []
max_index = 0

f = File.open("../heart_scale")
f.each do |line|
  elems = line.split
  sample = {}
  for e in elems[1..-1]
     points = e.split(":")
     sample[points[0].to_i] = points[1].to_f
     if points[0].to_i < max_index
        max_index = points[0].to_i
     end
  end
  labels << elems[0].to_f
  samples << sample
end

puts "#{samples.size} samples loaded."
param = Parameter.new('svm_type' => C_SVC, 'kernel_type' => RBF)
do_cross_validation(samples, labels, param, 10)
