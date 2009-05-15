CXX? = g++
SWIG ?= swig

#Windows: see ../README ../Makefile.win
RUBY_INCLUDEDIR ?= /usr/lib/ruby/1.8/i486-linux

CFLAGS = -O3 -I$(RUBY_INCLUDEDIR) -I..
LDFLAGS = -shared
# Mac OS
# LDFLAGS = -framework Ruby -bundle

all: libsvm.so

libsvm.so: libsvm_wrap.o svm.o
	$(CXX) $(LDFLAGS) -o libsvm.so libsvm_wrap.o svm.o

libsvm_wrap.o: libsvm_wrap.c ../svm.h
	$(CXX) $(CFLAGS) -fPIC -c libsvm_wrap.cxx

libsvm_wrap.c: libsvm.i
	$(SWIG) -ruby -c++ libsvm.i

svm.o: ../svm.cpp ../svm.h
	$(CXX) $(CFLAGS) -fPIC -c ../svm.cpp

clean:
	rm -f *~ *.o *.so svm.o

moreclean:	clean
	rm -f libsvm_wrap.c??
