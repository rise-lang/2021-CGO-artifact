# Artifact benchmarking the harris operator on mobile CPUs for CGO 2021

This repository presents the artifact to supplement the paper
*Towards a Domain Extensible Compiler: optimizing an image processing pipeline on mobile CPUs*
to be presented at the [International Symposium on Code Generation and Optimization](https://conf.researchr.org/home/cgo-2021)
in 2021.

In this artifact, the host computer drives benchmarks on multiple target processors over ssh.
We recommend using an X86 Linux machine for the host.
To reproduce the results reported in Figures 1 and 8, you will need access to ARM Cortex A7, A15, A53 and A73 processors.
These processors can be found on the Odroid XU4 and Odroid N2 boards which were used for the paper.

**TODO: we provide access to our own Odroid XU4 and Odroid N2 boards for convenience? give ssh key instructions**

## Host Dependencies

The following software is required to run the artifact on the host.

- git, ssh, scp, POSIX shell
- zlib
- [rust](https://rust-lang.org) 1.4+
- sbt 1.x, java 1.8+ SDK
- llvm 8+
- make
- to plot figures:
  - R 3.6 or 4.0
  - DejaVu Sans font

Alternatively, we provide a docker image for convenience, which you can build and run:
```sh
sudo systemctl start docker.service
docker build . -t cgo21-rise
docker run --net=host -it cgo21-rise
```

## Installation on Host

To install the artifact on the host (potentially from the provided docker container):

**TODO: update git URL**
```sh
git clone --recursive https://gitlab.com/Bastacyclop/2020-image-processing-artifact.git -b cgo21 2021-CGO-artifact
cd 2021-CGO-artifact
```

## Target Dependencies

The following software is required to run benchmarks on a target.

- POSIX shell
- libpng and libjpeg
- OpenCL 1.2+ (recommended: check your setup with `clinfo`)
- a C/C++ compiler with C++14 support
- OpenCV 4.3

### Original Odroid XU4 setup

- clang 8 from LLVM 8. Built from source.
- [POCL](portablecl.org) 1.3 OpenCL implementation for the CPUs. Built from source along with LLVM 8.
- [OpenCV](https://opencv.org/) 4.3.0 built from source with the following flags:
```
cmake -D CMAKE_BUILD_TYPE=RELEASE \
  -D CMAKE_INSTALL_PREFIX=/usr/local \
  -D ENABLE_NEON=ON \
  -D ENABLE_VFPV3=ON \
  -D WITH_OPENCL=ON \
  -D WITH_JASPER=OFF \
  -D BUILD_TESTS=OFF \
  -D INSTALL_PYTHON_EXAMPLES=OFF \
  -D BUILD_EXAMPLES=OFF ..
```

### Original Odroid N2 setup

- clang 10 from LLVM 10. Built from source.
- [POCL](portablecl.org) 1.5 OpenCL implementation for the CPUs. Built from source along with LLVM 10.
- [OpenCV](https://opencv.org/) 4.3.0 built from source with the following flags:
```
cmake -D CMAKE_BUILD_TYPE=RELEASE \
  -D CMAKE_INSTALL_PREFIX=/usr/local \
  -D ENABLE_NEON=ON \
  -D WITH_OPENCL=ON \
  -D WITH_JASPER=OFF \
  -D BUILD_TESTS=OFF \
  -D INSTALL_PYTHON_EXAMPLES=OFF \
  -D BUILD_EXAMPLES=OFF ..
```

## Target Configuration

This artifact includes configuration files used for the paper (`.yaml` files at the root).
You might need to tweak them according to your setup (e.g. change the ssh destination).
You can create custom configuration files to run benchmarks on any OpenCL-enabled target (not just the ARM CPUs used in the paper), but expect different performance behaviour.

**You need ssh access to the remote target without password prompt (use ssh keys).**
**TODO: give instructions to setup an ssh key**

### Odroid XU4 target configurations

- [`cortex-a7.yaml`](cortex-a7.yaml)
- [`cortex-a15.yaml`](cortex-a15.yaml)

When benchmarking, we set the CPU frequency using the scripts in [`scripts/odroid-xu4/`](scripts/odroid-xu4/).
The above configuration files expect to find these scripts in the `~` directory
of the target, and will run them with password-less `sudo`.
You can allow password-less `sudo` by adding the line `odroid ALL =(ALL) NOPASSWD: /home/odroid/perf_on_a15, /home/odroid/perf_on_a7, /home/odroid/perf_off` to `/etc/sudoers`.
Alternatively, you can run these scripts manually before and after running the benchmarks.
 
### Odroid N2 target configurations

- [`cortex-a53.yaml`](cortex-a53.yaml)
- [`cortex-a73.yaml`](cortex-a73.yaml)

Similarly to the XU4, we set the CPU frequency using the scripts in [`scripts/odroid-n2/`](scripts/odroid-n2/).
You can allow password-less `sudo` by adding the line `odroid ALL =(ALL) NOPASSWD: /home/odroid/perf_on_a53, /home/odroid/perf_on_a73, /home/odroid/perf_off` to `/etc/sudoers`.

## Reproducing the paper results

To reproduce the results reported in Figures 1 and 8 you should first run the benchmarks for every target,
and then plot the figures.

### Running benchmarks

The entire workflow should be feasible within an hour.
For every $TARGET (cortex-a7, cortex-a15, cortex-a53, cortex-a73):
- generate code by running `./codegen -t $TARGET.yaml`
  
  This will generate halide binaries in `lib/halide/apps/harris/bin/` and rise kernels in
  `lib/harris-rise-and-shine/gen/`. Building Halide and Rise can take some time on the first run,
   after that code generation should take within a minute.
   
- run benchmarks by running `./benchmark -t $TARGET.yaml`

  This will create a `2021-CGO-experiment` folder in the home directory
of the remote user, where the necessary files will be uploaded during the experiment.
  Benchmarking takes roughly between 2 and 10mn depending on the target.

A `results/$TARGET` folder is also created on the host, where you can find logs and raw `benchmark.data`. 

### Plotting the Figures

First, either create or symlink `lib/Rlibs`, where R libraries will be fetched and stored:
```sh
# use a fresh directory
mkdir lib/Rlibs
# or use an existing directory to avoid duplication
ln -s ~/.rlibs lib/Rlibs
# alternatively do neither to use system libraries (requires sudo)
```

Now you can plot the figures by running `./plot-figures`, which will generate:
- `results/figure1.pdf`, some visual details are different from the paper figure because it was edited using Inkscape.
- `results/figure8.pdf`

## Looking at the Logs

You can use `cat` or `less -R` on the logs in the result directory:

- `info`: general system information
- `hwinfo`: target hardware information
- ..

You can also use `tail -f` to watch a log.

## **TODO? describe artifact file structure more**

## Authors

- Thomas Koehler, University of Glasgow ([thomas.koehler@thok.eu](mailto:thomas.koehler@thok.eu))
- Michel Steuwer, University of Edinburgh ([michel.steuwer@ed.ac.uk](mailto:michel.steuwer@ed.ac.uk))