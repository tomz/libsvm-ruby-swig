CXX? = g++
SWIG ?= swig

UNAME := $(shell uname)
RUBY_INCLUDEDIR := $(shell ruby -e 'print $$:[-2]')

ifeq ($(UNAME), Linux)
LDFLAGS = -shared
EXT = so
endif
ifeq ($(UNAME), Darwin)
LDFLAGS = -framework Ruby -bundle
EXT = bundle
endif
#Windows: see ../README ../Makefile.win

ifdef EXT
CFLAGS = -O3 -I$(RUBY_INCLUDEDIR) -I..

all: libsvm.$(EXT)

else
all: ; @echo "Only Linux and OS X are supported, please add your OS in Makefile"
endif

libsvm.$(EXT): libsvm_wrap.o svm.o
	$(CXX) $(LDFLAGS) -o libsvm.$(EXT) libsvm_wrap.o svm.o

libsvm_wrap.o: libsvm_wrap.c ../svm.h
	$(CXX) $(CFLAGS) -fPIC -c libsvm_wrap.cxx

libsvm_wrap.c: libsvm.i
	$(SWIG) -ruby -c++ libsvm.i

svm.o: ../svm.cpp ../svm.h
	$(CXX) $(CFLAGS) -fPIC -c ../svm.cpp

clean:
	rm -f *~ *.o *.so svm.o *.bundle

moreclean:	clean
	rm -f libsvm_wrap.c??
