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
- R (version used for the paper: 3.6.1)
- sbt 1.x, java 1.8+ SDK
- llvm 8+
- make

## Target Dependencies

- POSIX shell
- libpng and libjpeg
- OpenCL 1.2+ (recommended: check your setup with `clinfo`)
- a C/C++ compiler with C++14 support

## Running the Experiment

Given a `$HOST/$TARGET.yaml` configuration file, the experiment can be run on
`$TARGET` with:

```sh
./experiment -t $TARGET.yaml
```

**You need ssh access to the remote target without password prompt.**

This will create a `2020-image-processing-experiment` folder in the home directory
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

## Linux desktop with Intel processors

Configuration files:
- `intel-i7-7700.yaml`
- `intel-hd-gen9.yaml`

Software used:
- icc 19.0.5 (installed with Intel System Studio 2019 update 5)
- OpenCL implementation for the CPU (installed with Intel System Studio)
- OpenCL implementation for the GPU using the [Intel Graphics Compute Runtime](https://github.com/intel/compute-runtime)

## Odroid XU4 with ARM processors

Configuration files:
- `cortex-a7.yaml`
- `cortex-a15.yaml`
- `mali-t628.yaml`

Software used:
- clang 8 from LLVM 8. Built from source. (can also use gcc 7.4)
- [POCL](portablecl.org) OpenCL implementation for the CPUs. Built from source along with LLVM 8.
- OpenCL implementation for the Mali GPU. Helpful pages:
  - <https://www.cnx-software.com/2018/05/13/how-to-get-started-with-opencl-on-odroid-xu4-board-with-arm-mali-t628mp6-gpu/>
  - <https://magazine.odroid.com/article/clinfo-compiling-the-essential-opencl-gpu-tuning-utility-for-the-odroid-xu4/>
  
### ARM CPUs frequency

When benchmarking the ARM CPUs of the Odroid, we set their frequency to the maximum using the scripts:

```sh
odroid@odroid:~$ cat ./perf_on_a15 
#!/bin/sh

for i in 4 5 6 7; do
  echo 1 > /sys/devices/system/cpu/cpu$i/online
  echo performance > /sys/devices/system/cpu/cpu$i/cpufreq/scaling_governor
  echo 1500000 > /sys/devices/system/cpu/cpu$i/cpufreq/scaling_max_freq
done

for i in 0 1 2 3; do
  echo 1 > /sys/devices/system/cpu/cpu$i/online
  echo ondemand > /sys/devices/system/cpu/cpu$i/cpufreq/scaling_governor
done

echo "120 180 240 255" > /sys/devices/platform/pwm-fan/hwmon/hwmon0/fan_speed

~/perf_status
odroid@odroid:~$ cat ./perf_on_a7
#!/bin/sh

for i in 0 1 2 3; do
  echo 1 > /sys/devices/system/cpu/cpu$i/online
  echo performance > /sys/devices/system/cpu/cpu$i/cpufreq/scaling_governor
  echo 1500000 > /sys/devices/system/cpu/cpu$i/cpufreq/scaling_max_freq
done

for i in 4 5 6 7; do
  echo 1 > /sys/devices/system/cpu/cpu$i/online
  echo ondemand > /sys/devices/system/cpu/cpu$i/cpufreq/scaling_governor
done

echo "120 180 240 255" > /sys/devices/platform/pwm-fan/hwmon/hwmon0/fan_speed

~/perf_status
odroid@odroid:~$ cat ./perf_off 
#!/bin/sh

for i in 0 1 2 3 4 5 6 7; do
  echo 1 > /sys/devices/system/cpu/cpu$i/online
  echo ondemand > /sys/devices/system/cpu/cpu$i/cpufreq/scaling_governor
done

echo "0 120 180 240" > /sys/devices/platform/pwm-fan/hwmon/hwmon0/fan_speed

~/perf_status
odroid@odroid:~$ cat ./perf_status 
#!/bin/sh

grep "" /dev/null /sys/devices/system/cpu/cpufreq/policy*/scaling_governor
grep "" /dev/null /sys/devices/system/cpu/cpufreq/policy*/scaling_cur_freq
grep "" /dev/null /sys/devices/system/cpu/cpufreq/policy*/scaling_max_freq
``` 

We also allow to run these scripts without password with `sudo`
by adding the line `odroid ALL =(ALL) NOPASSWD: /home/odroid/perf_on_a15, /home/odroid/perf_on_a7, /home/odroid/perf_off`
to `/etc/sudoers`.
An alternative is to run these scripts manually before and after running the experiment.
