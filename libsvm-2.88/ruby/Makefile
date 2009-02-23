CXX? = g++
SWIG ?= swig

#Windows: see ../README ../Makefile.win
RUBY_INCLUDEDIR ?= /usr/lib/ruby/1.8/i486-linux

CFLAGS = -O3 -I$(RUBY_INCLUDEDIR) -I..
LDFLAGS = -shared
# Mac OS
# LDFLAGS = -framework Ruby -bundle

all: svmc.so

svmc.so: svmc_wrap.o svm.o
	$(CXX) $(LDFLAGS) -o svmc.so svmc_wrap.o svm.o

svmc_wrap.o: svmc_wrap.c ../svm.h
	$(CXX) $(CFLAGS) -fPIC -c svmc_wrap.cxx

svmc_wrap.c: svmc.i
	$(SWIG) -ruby -c++ svmc.i

svm.o: ../svm.cpp ../svm.h
	$(CXX) $(CFLAGS) -fPIC -c ../svm.cpp

clean:
	rm -f *~ *.o *.so svm.o

moreclean:	clean
	rm -f svmc_wrap.c??
