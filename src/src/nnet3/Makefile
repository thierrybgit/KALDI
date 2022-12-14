
all:

include ../kaldi.mk

LDFLAGS += $(CUDA_LDFLAGS)
LDLIBS += $(CUDA_LDLIBS)


TESTFILES = natural-gradient-online-test nnet-graph-test \
  nnet-descriptor-test nnet-parse-test nnet-component-test \
  nnet-compile-utils-test nnet-nnet-test nnet-utils-test \
  nnet-compile-test nnet-analyze-test nnet-compute-test \
  nnet-optimize-test nnet-derivative-test nnet-example-test \
  nnet-common-test convolution-test attention-test

ifeq ($(CUDA), true)
OBJFILES = nnet-common.o nnet-compile.o nnet-component-itf.o \
  nnet-simple-component.o nnet-combined-component.o nnet-normalize-component.o \
  nnet-general-component.o nnet-parse.o natural-gradient-online.o \
  nnet-descriptor.o nnet-optimize.o nnet-computation.o \
  nnet-computation-graph.o nnet-graph.o am-nnet-simple.o \
  nnet-example.o nnet-nnet.o nnet-compile-utils.o \
  nnet-utils.o nnet-compute.o nnet-test-utils.o nnet-analyze.o \
  nnet-example-utils.o nnet-training.o \
  nnet-diagnostics.o nnet-am-decodable-simple.o \
  nnet-optimize-utils.o nnet-chain-example.o \
  nnet-chain-training.o nnet-chain-diagnostics.o \
  discriminative-supervision.o nnet-discriminative-example.o \
  nnet-discriminative-diagnostics.o \
  discriminative-training.o nnet-discriminative-training.o \
  nnet-compile-looped.o decodable-simple-looped.o \
  decodable-online-looped.o decodable-batch-looped.o convolution.o \
  nnet-convolutional-component.o attention.o \
  nnet-attention-component.o nnet-tdnn-component.o nnet-batch-compute.o \
  nnet-chain-training2.o nnet-chain-diagnostics2.o
endif
ifeq ($(ROCM), true)
OBJFILES = nnet-common.cc.o nnet-compile.cc.o nnet-component-itf.cc.o \
  nnet-simple-component.cc.o nnet-combined-component.cc.o nnet-normalize-component.cc.o \
  nnet-general-component.cc.o nnet-parse.cc.o natural-gradient-online.cc.o \
  nnet-descriptor.cc.o nnet-optimize.cc.o nnet-computation.cc.o \
  nnet-computation-graph.cc.o nnet-graph.cc.o am-nnet-simple.cc.o \
  nnet-example.cc.o nnet-nnet.cc.o nnet-compile-utils.cc.o \
  nnet-utils.cc.o nnet-compute.cc.o nnet-test-utils.cc.o nnet-analyze.cc.o \
  nnet-example-utils.cc.o nnet-training.cc.o \
  nnet-diagnostics.cc.o nnet-am-decodable-simple.cc.o \
  nnet-optimize-utils.cc.o nnet-chain-example.cc.o \
  nnet-chain-training.cc.o nnet-chain-diagnostics.cc.o \
  discriminative-supervision.o nnet-discriminative-example.cc.o \
  nnet-discriminative-diagnostics.cc.o \
  discriminative-training.cc.o nnet-discriminative-training.cc.o \
  nnet-compile-looped.cc.o decodable-simple-looped.cc.o \
  decodable-online-looped.cc.o decodable-batch-looped.cc.o convolution.cc.o \
  nnet-convolutional-component.cc.o attention.cc.o \
  nnet-attention-component.cc.o nnet-tdnn-component.cc.o nnet-batch-compute.cc.o \
  nnet-chain-training2.cc.o nnet-chain-diagnostics2.cc.o
endif
LIBNAME = kaldi-nnet3

ADDLIBS = ../chain/kaldi-chain.a ../cudamatrix/kaldi-cudamatrix.a \
          ../decoder/kaldi-decoder.a ../lat/kaldi-lat.a \
          ../fstext/kaldi-fstext.a ../hmm/kaldi-hmm.a \
          ../transform/kaldi-transform.a ../gmm/kaldi-gmm.a \
          ../tree/kaldi-tree.a ../util/kaldi-util.a ../matrix/kaldi-matrix.a \
          ../base/kaldi-base.a 

ifeq ($(CUDA), true)
%.o : %.cu
	$(CUDATKDIR)/bin/nvcc -c $< -o $@ $(CUDA_INCLUDE) $(CUDA_FLAGS) $(CUDA_ARCH) -I../
endif
ifeq ($(ROCM), true)
%.o : %.hip
	$(ROCMDIR)/bin/hipcc -c $< -o $@ $(ROCM_INCLUDE) $(ROCM_FLAGS) $(CUDA_ARCH) -I../
endif

include ../makefiles/default_rules.mk
