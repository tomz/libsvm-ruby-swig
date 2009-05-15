require 'libsvm'
include Libsvm

def _int_array(seq)
  size = seq.size
  array = new_int(size)
  i = 0
  for item in seq
    int_setitem(array,i,item)
    i = i + 1
  end
  return array
end

def _double_array(seq)
  size = seq.size
  array = new_double(size)
  i = 0
  for item in seq
    double_setitem(array,i,item)
    i = i + 1
  end
  return array
end

def _free_int_array(x)
  if !x.nil? and !x.empty?
    delete_int(x)
  end
end

def _free_double_array(x)
  if !x.nil? and !x.empty?
    delete_double(x)
  end
end

def _int_array_to_list(x,n)
  list = []
   (0..n-1).each {|i| list << int_getitem(x,i) }
  return list
end

def _double_array_to_list(x,n)
  list = []
   (0..n-1).each {|i| list << double_getitem(x,i) }
  return list
end    

class Parameter
  attr_accessor :param
  
  def initialize(*args)
    @param = Svm_parameter.new
    @param.svm_type = C_SVC
    @param.kernel_type = RBF
    @param.degree = 3
    @param.gamma = 0    # 1/k
    @param.coef0 = 0
    @param.nu = 0.5
    @param.cache_size = 100
    @param.C = 1
    @param.eps = 1e-3
    @param.p = 0.1
    @param.shrinking = 1
    @param.nr_weight = 0
    #@param.weight_label = _int_array([])
    #@param.weight = _double_array([])
    @param.probability = 0
    
    args[0].each {|k,v| 
      self.send("#{k}=",v)
    } if !args[0].nil?
  end
  
  def method_missing(m, *args)
    if m.to_s == 'weight_label='
      @weight_label_len = args[0].size
      pargs = _int_array(args[0])
      _free_int_array(@param.weight_label)
    elsif m.to_s == 'weight='
      @weight_len = args[0].size
      pargs = _double_array(args[0])
      _free_double_array(@param.weight)
    else
      pargs = args[0]
    end
    
    if m.to_s.index('=')
      @param.send("#{m}",pargs)
    else
      @param.send("#{m}")
    end
    
  end
  
  def destroy
    _free_int_array(@param.weight_label)
    _free_double_array(@param.weight)
    #delete_svm_parameter(@param)
    @param = nil
  end
end

def _convert_to_svm_node_array(x)
  # convert a hash or array to an svm_node array
  
  # Find non zero elements
  iter_range = []
  if x.class == Hash
    x.each {|k, v|
      # all zeros kept due to the precomputed kernel; no good solution yet     
      iter_range << k  # if v != 0
    }
  elsif x.class == Array
    x.each_index {|j| 
      iter_range << j #if x[j] != 0
    }
  else
    raise TypeError,"data must be a hash or an array"
  end
  
  iter_range.sort!
  data = svm_node_array(iter_range.size+1)
  svm_node_array_set(data,iter_range.size,-1,0)
  
  j = 0
  for k in iter_range
    svm_node_array_set(data,j,k,x[k])
    j = j + 1
  end
  return data
end

class Problem
  attr_accessor :prob, :maxlen, :size
  
  def initialize(y,x)
    #assert y.size == x.size
    @prob = prob = Svm_problem.new 
    @size = size = y.size
    
    @y_array = y_array = new_double(size)
    for i in (0..size-1)
      double_setitem(@y_array,i,y[i])
    end
    
    @x_matrix = x_matrix = svm_node_matrix(size)
    @data = []
    @maxlen = 0
    for i in (0..size-1)
      data = _convert_to_svm_node_array(x[i])
      @data << data
      svm_node_matrix_set(x_matrix,i,data)
      if x[i].class == Hash
        if x[i].size > 0
          @maxlen = [@maxlen,x[i].keys.max].max
        end
      else
        @maxlen = [@maxlen,x[i].size].max
      end
    end
    
    prob.l = size
    prob.y = y_array
    prob.x = x_matrix
  end
  
  def inspect
    return "Problem: size = #{size}"
  end
  
  def destroy
    delete_svm_problem(@prob)
    delete_double(@y_array)
    for i in (0..size-1)
      svm_node_array_destroy(@data[i])
    end
    svm_node_matrix_destroy(@x_matrix)
  end
end

class Model
  attr_accessor :model,:objs
  
  def initialize(arg1,arg2=nil)
    if arg2 == nil
      # create model from file
      filename = arg1
      @model = svm_load_model(filename)
    else
      # create model from problem and parameter
      prob,param = arg1,arg2
      @prob = prob
      if param.gamma == 0
        param.gamma = 1.0/prob.maxlen
      end
      msg = svm_check_parameter(prob.prob,param.param)
      raise ::ArgumentError, msg if msg
      @model = svm_train(prob.prob,param.param)
    end
    
    #setup some classwide variables
    @nr_class = svm_get_nr_class(@model)
    @svm_type = svm_get_svm_type(@model)
    #create labels(classes)
    intarr = new_int(@nr_class)
    svm_get_labels(@model,intarr)
    @labels = _int_array_to_list(intarr, @nr_class)
    delete_int(intarr)
    #check if valid probability model
    @probability = svm_check_probability_model(@model)

    @objs = []
    for i in (0..@labels.size-1)
      @objs << svm_get_obj(@model, i)
    end if arg2 != nil
    
  end
  
  def predict(x)
    data = _convert_to_svm_node_array(x)
    ret = svm_predict(@model,data)
    svm_node_array_destroy(data)
    return ret
  end
  
  
  def get_nr_class
    return @nr_class
  end
  
  def get_labels
    if @svm_type == NU_SVR or @svm_type == EPSILON_SVR or @svm_type == ONE_CLASS
      raise TypeError, "Unable to get label from a SVR/ONE_CLASS model"
    end
    return @labels
  end
  
  def predict_values_raw(x)
    #convert x into svm_node, allocate a double array for return
    n = (@nr_class*(@nr_class-1)/2).floor
    data = _convert_to_svm_node_array(x)
    dblarr = new_double(n)
    svm_predict_values(@model, data, dblarr)
    ret = _double_array_to_list(dblarr, n)
    delete_double(dblarr)
    svm_node_array_destroy(data)
    return ret
  end
  
  def predict_values(x)
    v=predict_values_raw(x)
    #puts v.inspect
    if @svm_type == NU_SVR or @svm_type == EPSILON_SVR or @svm_type == ONE_CLASS
      return v[0]
    else #self.svm_type == C_SVC or self.svm_type == NU_SVC
      count = 0
      
      # create a width x height array
      width = @labels.size
      height = @labels.size
      d = Array.new(width)
      d.map! { Array.new(height) }
      
      for i in (0..@labels.size-1)
        for j in (i+1..@labels.size-1)
          d[@labels[i]][@labels[j]] = v[count]
          d[@labels[j]][@labels[i]] = -v[count]
          count += 1
        end
      end
      return d
    end
  end
  
  def predict_probability(x)
    #c code will do nothing on wrong type, so we have to check ourself
    if @svm_type == NU_SVR or @svm_type == EPSILON_SVR
      raise TypeError, "call get_svr_probability or get_svr_pdf for probability output of regression"
    elsif @svm_type == ONE_CLASS
      raise TypeError, "probability not supported yet for one-class problem"
    end
    #only C_SVC,NU_SVC goes in
    if not @probability
      raise TypeError, "model does not support probabiliy estimates"
    end
    
    #convert x into svm_node, alloc a double array to receive probabilities
    data = _convert_to_svm_node_array(x)
    dblarr = new_double(@nr_class)
    pred = svm_predict_probability(@model, data, dblarr)
    pv = _double_array_to_list(dblarr, @nr_class)
    delete_double(dblarr)
    svm_node_array_destroy(data)
    p = {}
    for i in (0..@labels.size-1)
      p[@labels[i]] = pv[i]
    end
    return pred, p
  end
  
  def get_svr_probability
    #leave the Error checking to svm.cpp code
    ret = svm_get_svr_probability(@model)
    if ret == 0
      raise TypeError, "not a regression model or probability information not available"
    end
    return ret
  end
  
  def get_svr_pdf
    #get_svr_probability will handle error checking
    sigma = get_svr_probability()
    return Proc.new{|z| exp(-z.abs/sigma)/(2*sigma)}  # TODO: verify this works
  end
  
  def save(filename)
    svm_save_model(filename,@model)
  end
  
  def destroy
    svm_destroy_model(@model)
  end
end


def cross_validation(prob, param, fold)
  if param.gamma == 0
    param.gamma = 1.0/prob.maxlen
  end
  dblarr = new_double(prob.size)
  svm_cross_validation(prob.prob, param.param, fold, dblarr)
  ret = _double_array_to_list(dblarr, prob.size)
  delete_double(dblarr)
  return ret
end
