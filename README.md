# Artifact benchmarking the Harris operator on mobile CPUs for CGO 2021

This repository presents the artifact to supplement the paper
*Towards a Domain Extensible Compiler: optimizing an image processing pipeline on mobile CPUs*
to be presented at the [International Symposium on Code Generation and Optimization](https://conf.researchr.org/home/cgo-2021)
in 2021.

This artifact contains the source code used to produce the performance results presented in the paper.
The host computer drives benchmarks on multiple target processors over ssh.
We recommend using an X86 Linux machine for the host, and Linux targets.
To fully reproduce the results reported in Figures 1 and 8, you will need access to ARM Cortex A7, A15, A53 and A73 processors
(we used Odroid XU4 and Odroid N2 boards for the paper).
Other OpenCL-enabled processors can be used, but expect different performance behavior.

**TODO: provide access to our own Odroid XU4 and Odroid N2 boards for convenience? give ssh key instructions**

## Reproducing the paper results

Follow these steps to reproduce the paper results:
1. Install host dependencies
2. Clone this repository on the host
3. Use the Halide and Rise compilers to generate binaries and OpenCL kernels for each target (e.g. cortex-a7, cortex-a15, cortex-a53, cortex-a73)
4. Configure each target
5. Reproduce the performance results by running benchmarks for each target
6. Plot figure 1 and 8

All of this should be feasible in one or two hours once dependencies are installed and targets are configured.
The following sections provide more details for every step.

## 1. Installing Host Dependencies

We provide a docker image for convenience, which you can download, build and run:
```sh
wget https://raw.githubusercontent.com/rise-lang/2021-CGO-artifact/main/Dockerfile
sudo systemctl start docker.service
docker build . -t cgo21-rise
docker run --net=host -it cgo21-rise
```

Alternatively, install the following required software:
- git, ssh, scp, POSIX shell
- zlib
- [rust](https://rust-lang.org) 1.4+
- sbt 1.x, java 1.8 to 1.11 SDK
- llvm 8 to 10
- make
- to plot figures:
  - R 3.6 to 4.0
  - DejaVu Sans font

## 2. Cloning the repository

To install the artifact on the host (potentially from the provided docker container):

```sh
git clone --recursive https://github.com/rise-lang/2021-CGO-artifact.git
cd 2021-CGO-artifact
```

## 3. Generating code

Running `./codegen -t $TARGET.yaml` on the host will generate Halide binaries in `lib/halide/apps/harris/bin/` and Rise kernels in `lib/harris-rise-and-shine/gen/`.
The generated code is affected by the `halide` target string and `vector-width` specified in the `$TARGET.yaml` configuration file.
SSH access to a properly configured target is not required at this point (everything happens on the host).
Building Halide and Rise can take some time on the first run, after that code generation should take within a minute.

## 4. Target Configuration

This artifact includes configuration files used for the paper (`.yaml` files at the root).
You will need to tweak them according to your setup (e.g. change the ssh destination in the `remote` field).
You can create custom configuration files to generate code and run benchmarks on any other OpenCL-enabled target, but expect different performance behaviour.
See [`intel-i7-7700.yaml`](intel-i7-7700.yaml) for an example of Intel CPU target configuration.

**You need ssh access to the remote target without password prompt ([setup ssh keys](https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys-2)).**

The following software is required to run benchmarks on a target:
- POSIX shell
- libpng and libjpeg
- OpenCL 1.2+ (recommended: check your setup with `clinfo`)
- a C/C++ compiler with C++14 support
- OpenCV 4.3

### Original Odroid XU4 configuration

- [`cortex-a7.yaml`](cortex-a7.yaml)
- [`cortex-a15.yaml`](cortex-a15.yaml)

When benchmarking, we set the CPU frequency using the scripts in [`scripts/odroid-xu4/`](scripts/odroid-xu4/).
The above configuration files expect to find these scripts in the `~` directory
of the target, and will run them with password-less `sudo`.
You can allow password-less `sudo` by adding the line `odroid ALL =(ALL) NOPASSWD: /home/odroid/perf_on_a15, /home/odroid/perf_on_a7, /home/odroid/perf_off` to `/etc/sudoers`.
Alternatively, you can run these scripts manually before and after running the benchmarks.

The following software was used:
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

### Original Odroid N2 configuration

- [`cortex-a53.yaml`](cortex-a53.yaml)
- [`cortex-a73.yaml`](cortex-a73.yaml)

Similarly to the XU4, we set the CPU frequency using the scripts in [`scripts/odroid-n2/`](scripts/odroid-n2/).
You can allow password-less `sudo` by adding the line `odroid ALL =(ALL) NOPASSWD: /home/odroid/perf_on_a53, /home/odroid/perf_on_a73, /home/odroid/perf_off` to `/etc/sudoers`.

The following software was used:
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

## 5. Running benchmarks

Running `./benchmark -t $TARGET.yaml` on the host will:
- create a `2021-CGO-experiment` folder in the home directory of the remote user, where the necessary files will be automatically uploaded.
- benchmark the performance of the Harris operator using OpenCV, Halide, Rise and Lift implementations; checking output correctness
  - for the small image `lib/halide/apps/images/rgb.png`
  - for the big image `lib/polymage/images/venice_wikimedia.jpg`
- record the benchmark results on the host in `results/$TARGET/benchmark.data`.

At this point SSH access to a properly configured target is required (see target configuration section).
Benchmarking takes roughly between 2 and 10mn depending on the target.

## 6. Plotting the figures

If you could not run the benchmarks on all the processors used in the paper,
you will still be able to plot the figures using our own benchmark data, which is included in this artifact.

First, either create or symlink `lib/Rlibs`, where R libraries will be fetched and stored:
```sh
# use a fresh directory
mkdir lib/Rlibs
# or use an existing directory to avoid duplication
ln -s ~/.rlibs lib/Rlibs
# alternatively do neither to use system libraries (requires sudo)
```

Running `./plot-figures` on the host will generate:
- `results/figure1.pdf`, some visual details are different from the paper figure because it was edited using Inkscape.
- `results/figure8.pdf`


## Looking at the Logs

You can use `cat` or `less -R` on the logs in a `results/$TARGET` directory:

- `info`: general system information
- `hwinfo`: target hardware information
- ..

You can also use `tail -f` to watch a log.

## Artifact directories

- [`driver`](driver) contains Rust and C/C++ code to run the benchmarks
- [`lib`](lib) contains various library dependencies, in particular:
  - [`halide`](lib/halide) contains the Halide language and compiler
  - [`shine`](lib/shine) contains the Rise language and its Shine compiler
- [`lift-gen`](lift-gen) contains the Lift-generated OpenCL kernels
- [`plot`](plot) contains the R plotting scripts
- [`results`](results) contains the benchmark logs and results
- [`scripts`](scripts) contains various useful scripts

## Authors

- Thomas Koehler, University of Glasgow ([thomas.koehler@thok.eu](mailto:thomas.koehler@thok.eu))
- Michel Steuwer, University of Edinburgh ([michel.steuwer@ed.ac.uk](mailto:michel.steuwer@ed.ac.uk))
