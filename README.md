# matlab_Benchmarks
Real world use case benchmarks for a very specific niche of industry.

# Results

| Machine             	| CPU      	| CPU 	| RAM  	| UserBenchmark 	| CPU-Z         	| CPU-Z        	| CPU Benchmark                                                                            	|  CPU Benchmark                                                                            	| Cinebench R15 	| Cinebench R15 	|
|---------------------	|----------	|-----	|------	|---------------	|---------------	|--------------	|------------------------------------------------------------------------------------------	|-------------------------------------------------------------------------------------------	|---------------	|---------------	|
|                     	|          	| GHz 	| (GB) 	|               	| Single Thread 	| Multi Thread 	| Single Thread*                                                                           	| CPU Mark*                                                                                 	| CPU           	| Single Core   	|
| ASrock Z87 Extreme6 	| 4770k OC 	| 4.4 	| 16   	|               	| 458.8         	| 2363.7       	|                                                                                          	|                                                                                           	| 835           	| 177           	|
| ASrock Z87 Extreme6 	| 4770k    	| 3.5 	| 16   	|               	|               	|              	| [2253](https://www.cpubenchmark.net/cpu.php?cpu=Intel+Core+i7-4770K+%40+3.50GHz&id=1919) 	| [10104](https://www.cpubenchmark.net/cpu.php?cpu=Intel+Core+i7-4770K+%40+3.50GHz&id=1919) 	|               	|               	|
| HP ZBook G3         	|          	|     	|      	|               	|               	|              	|                                                                                          	|                                                                                           	|               	|               	|
| HP Z840             	|          	|     	|      	|               	|               	|              	|                                                                                          	|                                                                                           	|               	|               	|
|                     	|          	|     	|      	|               	|               	|              	|                                                                                          	|                                                                                           	|               	|               	|
|                     	|          	|     	|      	|               	|               	|              	|                                                                                          	|                                                                                           	|               	|               	|

## Motivation

After doing some [``profiling``](https://www.mathworks.com/help/matlab/ref/profile.html) of my daily workflow I discovered that my [Laptop](http://store.hp.com/us/en/pdp/hp-zbook-studio-g3-mobile-workstation-(energy-star\)) was faster than my [Desktop](http://store.hp.com/us/en/mdp/business-solutions/z840-workstation), despite a large disparity in specifications.

Specifications and benchmarks don't give an indication of how a system will affect my workflow.

# Contributing

## Benchmark Results

1. Run the provided scripts and tools listed below.
2. Fill in the table.
3. Make a pull request.

## Benchmarks

1. Add simple benchmark with documentation for use case.
2. Make a pull request.

# Tools

- [UserBenchmark](https://www.cpuid.com/softwares/cpu-z.html)
- [CPU-Z](https://www.cpuid.com/softwares/cpu-z.html)
  - Bench Tab
  - Bench CPU
- [Cinebench R15](https://www.maxon.net/en/products/cinebench/)
  - File > Advanced Benchmark
  - Uncheck OpenGL
  - File > Run All Selected Checks
- [Matlab R2016b](https://www.mathworks.com/products/new_products/release2016b.html)
- [CPU Benchmarks](https://www.cpubenchmark.net/CPU_mega_page.html)