#!/usr/bin/env ruby

require 'svm'

Svmc::info_on = 1 # turn on the built-in loggin, default to 0 (off)
# a three-class problem
labels = [0, 1, 1, 2]
samples = [[0, 0], [0, 1], [1, 0], [1, 1]]
problem = Problem.new(labels, samples)
size = samples.size

kernels = [LINEAR, POLY, RBF, SIGMOID]
kname = {LINEAR=>'linear',POLY=>'polynomial',RBF=>'rbf',SIGMOID=>'sigmoid'}

param = Parameter.new(:C => 10, :nr_weight => 2, :weight_label => [1,0], :weight => [10,1])
# or:
#param = Parameter.new
#param.C = 10
#param.nr_weight = 2
#param.weight_label = [1,0]
#param.weight = [10,1]
for k in kernels
  param.kernel_type = k
  model = Model.new(problem,param)
  #model.save(kname[k]+".model")
  errors = 0
  for i in (0..size-1)
    prediction = model.predict(samples[i])
    probability = model.predict_probability(samples[i])
    if (labels[i] != prediction)
      errors = errors + 1
    end
  end
  puts "##########################################"
  puts " kernel #{kname[k]}: error rate = #{errors} / #{size}"
  puts "##########################################"
end

param = Parameter.new('kernel_type' => RBF, 'C'=>10)
#param = Parameter.new
#param.kernel_type = RBF
#param.C = 10
model = Model.new(problem, param)
puts "objs:#{model.objs.inspect}"
puts "##########################################"
puts " Decision values of predicting #{samples[0].inspect}"
puts "##########################################"

puts "Numer of Classes:" + model.get_nr_class().to_s
d = model.predict_values(samples[0])
#puts d.inspect
for i in model.get_labels
  for j in model.get_labels
    if j>i
      puts "{#{i}, #{j}} = #{d[i][j]}"
    end
  end
end

param = Parameter.new('kernel_type' => RBF, 'C'=>10, 'probability' => 1)
#param = Parameter.new
#param.kernel_type = RBF
#param.C = 10
#param.probability = 1
model = Model.new(problem, param)
puts "objs:#{model.objs.inspect}"
pred_label, pred_probability = model.predict_probability(samples[1])
puts "##########################################"
puts " Probability estimate of predicting #{samples[1].inspect}"
puts "##########################################"
puts "predicted class: #{pred_label}"
for i in model.get_labels
  puts "prob(label=#{i}) = #{pred_probability[i]}"
end

puts "##########################################"
puts " Precomputed kernels"
puts "##########################################"
samples = [[1, 0, 0, 0, 0], [2, 0, 1, 0, 1], [3, 0, 0, 1, 1], [4, 0, 1, 1, 2]]
problem = Problem.new(labels, samples)
param = Parameter.new('kernel_type'=>PRECOMPUTED,'C' => 10,'nr_weight' => 2,'weight_label' =>[1,0],'weight' => [10,1])
#param = Parameter.new
#param.kernel_type = PRECOMPUTED
#param.C = 10
#param.nr_weight = 2
#param.weight_label = [1,0]
#param.weight = [10,1]
model = Model.new(problem, param)
puts "objs:#{model.objs.inspect}"
pred_label = model.predict(samples[0])
