# Artifact for Image Processing

The host drives the experiment on multiple targets.
We recommend using an X86 Linux machine for the host.

## Installation on Host

```sh
git clone --recursive https://gitlab.com/Bastacyclop/2020-image-processing-artifact.git
cd 2020-image-processing-artifact
```

We will refer to this directory as `$HOST`.

## Host Dependencies

- git, ssh, scp, POSIX shell
- [rust 2018](https://rust-lang.org)
- R (version used for the paper: 4.0.3)
- sbt 1.x, java 1.8+ SDK
- llvm 8+
- make

## Target Dependencies

- POSIX shell
- libpng and libjpeg
- OpenCL 1.2+ (recommended: check your setup with `clinfo`)
- a C/C++ compiler with C++14 support
- OpenCV 4.3

## Running the Experiment

Given a `$HOST/$TARGET.yaml` configuration file, the experiment can be run on
`$TARGET` with:

```sh
./experiment -t $TARGET.yaml
```

**You need ssh access to the remote target without password prompt.**

This will create a `2021-CGO-experiment` folder in the home directory
of the remote user, where files will be uploaded during the experiment.
The configuration files used for the paper are present in this artifact,
but you will need to change them according to your own setup.

## Plotting the Results

First, either create or symlink `lib/Rlibs`, where R libraries will be fetched and stored:
```sh
# use a fresh directory
mkdir lib/Rlibs
# or use an existing directory to avoid duplication
ln -s ~/.rlibs lib/Rlibs
```

Now you can plot everything:

**TODO**

## Looking at the Logs

You can use `cat` or `less -R` on the logs in the result directory:

- `info`: general system information
- `hwinfo`: target hardware information
- ..

You can also use `tail -f` to watch a log.

## Odroid XU4 with ARM processors

Configuration files (can be adjusted to change e.g. the ssh remote):
- `cortex-a7.yaml`
- `cortex-a15.yaml`

Software used:
- clang 8 from LLVM 8. Built from source.
- [POCL](portablecl.org) OpenCL implementation for the CPUs. Built from source along with LLVM 8.
- [OpenCV](https://opencv.org/) 4.3.0 built from source.
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

When benchmarking, we set the CPU frequency using the scripts in <scripts/odroid-xu4/>.
The above configuration files expect to find these scripts in the `~` directory
of the target, and will run them with password-less `sudo`.
You can allow password-less `sudo` by adding the line `odroid ALL =(ALL) NOPASSWD: /home/odroid/perf_on_a15, /home/odroid/perf_on_a7, /home/odroid/perf_off` to `/etc/sudoers`.
Alternatively, you can run these scripts manually before and after running the experiment.
 
## Odroid N2 with ARM processors

Configuration files (can be adjusted to change e.g. the ssh remote):
- `cortex-a53.yaml`
- `cortex-a73.yaml`

Software used:
- clang 10 from LLVM 10. Built from source.
- [POCL](portablecl.org) OpenCL implementation for the CPUs. Built from source along with LLVM 10.
- [OpenCV](https://opencv.org/) 4.3.0 built from source.
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

When benchmarking, we set the CPU frequency using the scripts in <scripts/odroid-n2/>.
The above configuration files expect to find these scripts in the `~` directory
of the target, and will run them with password-less `sudo`.
You can allow password-less `sudo` by adding the line `odroid ALL =(ALL) NOPASSWD: /home/odroid/perf_on_a53, /home/odroid/perf_on_a73, /home/odroid/perf_off` to `/etc/sudoers`.
Alternatively, you can run these scripts manually before and after running the experiment.
 
