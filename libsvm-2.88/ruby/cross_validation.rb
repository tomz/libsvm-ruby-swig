#!/usr/bin/env ruby

require 'svm'

def do_cross_validation(prob_x, prob_y, param, nr_fold)
  puts "Do cross validation for a given SVM problem."
  prob_l = prob_y.size
  total_correct = 0
  total_error = sumv = sumy = sumvv = sumyy = sumvy = 0.0
  prob = Problem.new(prob_y, prob_x)
  target = cross_validation(prob, param, nr_fold)
  for i in (0..prob_l-1)
    if param.svm_type == EPSILON_SVR or param.svm_type == NU_SVR
      v = target[i]
      y = prob_y[i]
      sumv = sumv + v
      sumy = sumy + y
      sumvv = sumvv + v * v
      sumyy = sumyy + y * y
      sumvy = sumvy + v * y
      total_error = total_error + (v-y) * (v-y)
    else
      v = target[i]
      if v == prob_y[i]
        total_correct = total_correct + 1 
      end
    end
  end

  if param.svm_type == EPSILON_SVR or param.svm_type == NU_SVR
    puts "Cross Validation Mean squared error = #{total_error / prob_l}"
    puts "Cross Validation Squared correlation coefficient = #{((prob_l * sumvy - sumv * sumy) * (prob_l * sumvy - sumv * sumy)) / ((prob_l * sumvv - sumv * sumv) * (prob_l * sumyy - sumy * sumy))}"
  else
    puts "Cross Validation Accuracy = #{100.0 * total_correct / prob_l}%"
  end
end
