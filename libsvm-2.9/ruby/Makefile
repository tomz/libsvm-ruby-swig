CXX? = g++
SWIG ?= swig

#Windows: see ../README ../Makefile.win
#RUBY_INCLUDEDIR ?= /usr/local/lib/ruby/1.8/x86_64-linux 
RUBY_INCLUDEDIR ?=/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/lib/ruby/1.8/universal-darwin10.0
#RUBY_INCLUDEDIR ?= /Users/TomZeng/.rvm/rubies/ruby-1.9.2-p290/include/ruby-1.9.1
#RUBY_INCLUDEDIR ?= /Users/TomZeng/.rvm/rubies/ree-1.8.7-2011.03/lib/ruby/1.8/i686-darwin10.6.0

CFLAGS = -O3 -I$(RUBY_INCLUDEDIR) -I..
#LDFLAGS = -shared
#TARGET = libsvm.so
# Mac OS
LDFLAGS = -framework Ruby -bundle
TARGET = libsvm.bundle

all: $(TARGET)

$(TARGET): libsvm_wrap.o svm.o
	$(CXX) $(LDFLAGS) -o $(TARGET) libsvm_wrap.o svm.o

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
