#!/usr/bin/env ruby

require 'cross_validation'

Libsvm::info_on = 1

labels,samples = read_file("../heart_scale")

param = Parameter.new('svm_type' => C_SVC, 'kernel_type' => RBF)
do_cross_validation(samples, labels, param, 10)
