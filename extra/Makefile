CXX ?= g++
CXXFLAGS = -O3 -std=c++11 -I $(HALIDE_PATH)/include/ -I $(HALIDE_PATH)/tools/ -Wall -Werror -Wno-psabi
LDFLAGS = -ldl -lpthread -lz -lpng -ljpeg

HALIDE_PATH = ../lib/halide
LIB_HALIDE = $(HALIDE_PATH)/bin/libHalide.so

.PHONY: %.run, clean

all: camera_pipe.bin local_laplacian.bin bilateral_grid.bin

%.run: %.bin
	./$<

%.bin: %.cpp $(LIB_HALIDE) $(HALIDE_PATH)/include/Halide.h
	$(CXX) $(CXXFLAGS) $(filter-out %.h,$^) -o $@ $(LDFLAGS) $(HALIDE_SYSTEM_LIBS)

clean:
	rm -rf *.bin
