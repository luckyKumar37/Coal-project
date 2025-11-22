# **Comparative Analysis of Sorting & Searching Algorithms in x86 Assembly**

This project is a low-level implementation and benchmarking suite for fundamental sorting and searching algorithms using **x86 Assembly Language (MASM)**. It provides both interactive modes for visualizing algorithm outputs and automated benchmarking tools to measure performance in CPU cycles.

## **📌 Project Overview**

The primary goal of this project is to analyze the efficiency of standard algorithms at the hardware level. By utilizing the CPU Time-Stamp Counter (rdtsc), we measure the exact number of clock cycles required for execution, providing a precise comparison between $O(n^2)$ and $O(n \\log n)$ algorithms.

### **Key Features**

* **Sorting Algorithms:** Bubble Sort, Selection Sort, Insertion Sort, Quick Sort, Shell Sort.  
* **Searching Algorithms:** Linear Search, Binary Search, Interpolation Search.  
* **Performance Metrics:** Real-time measurement of CPU clock cycles.  
* **Interactive Mode:** User-friendly menus to input data and select algorithms.

## **📂 Project Structure**

| File Name | Description |
| :---- | :---- |
| **main.asm** | **Automated Benchmarking Suite.** Generates random arrays of 500 integers and runs all 5 sorting algorithms sequentially to compare their cycle counts. |
| **sorting.asm** | **Interactive Sorting Tool.** Allows the user to input a custom array size and elements, then choose a specific sorting algorithm to see the sorted result. |
| **searching.asm** | **Search Performance Analyzer.** Generates a random array, sorts it, and then compares the performance of Linear, Binary, and Interpolation search on a target value. |

## **🛠️ Prerequisites**

To run this project, you need:

1. **Visual Studio** (2019 or 2022 recommended) with C++ Desktop Development workload installed.  
2. **MASM (Microsoft Macro Assembler)** (Included with Visual Studio).  
3. **Irvine32 Library:** A library for simplified I/O in Assembly language.  
   * [Download Irvine32](http://asmirvine.com/gettingStartedVS2019/index.htm)  
   * Follow the setup guide to link the library to your Visual Studio project.

## **🚀 How to Run**

### **Setting up the Project**

1. Open Visual Studio and create a new **Empty Project (C++)**.  
2. Right-click the project in Solution Explorer → **Build Dependencies** → **Build Customizations** → Check **masm**.  
3. Right-click the project → **Properties** → **Linker** → **General** → **Additional Library Directories** → Add the path to your Irvine folder (e.g., C:\\Irvine).  
4. In **Linker** → **Input** → **Additional Dependencies**, add irvine32.lib;.

### **Running Specific Modules**

Since there are multiple .asm files containing a main procedure, you cannot build them all at once. You must exclude the files you aren't running.

1. **To run the Benchmarking Suite (main.asm):**  
   * Right-click sorting.asm and searching.asm → **Properties** → **General** → **Excluded From Build** → **Yes**.  
   * Build and Run.  
2. **To run the Interactive Sorter (sorting.asm):**  
   * Exclude main.asm and searching.asm.  
   * Build and Run.  
3. **To run the Search Analyzer (searching.asm):**  
   * Exclude main.asm and sorting.asm.  
   * Build and Run.

## **📊 Benchmarking Methodology**

Performance is measured using the rdtsc (Read Time-Stamp Counter) instruction, which returns the number of clock cycles since the CPU was reset.

* **Start:** rdtsc is called before the algorithm begins.  
* **End:** rdtsc is called after the algorithm finishes.  
* **Calculation:** End Cycles \- Start Cycles \= Total Execution Time.

*Note: Cycle counts may vary slightly based on background OS processes.*
