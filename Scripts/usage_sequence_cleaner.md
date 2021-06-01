# Using the command line, you should run:

## sequence_cleaner

**usage** `python sequence_cleaner.py input[1] min_length[2] min[3]`

There are 3 basic parameters:

* [1]: your fasta file
* [2]: the user defines the minimum length. Default value 0, it means you don’t have to care about the minimum length
* [3]: the user defines the % of N is allowed. Default value 100, all sequences with ’N’ will be in your ouput, set value to 0 if you want no sequences with ”N” in your output

For example:

```python sequence_cleaner.py "your_sequences".fasta 10 10```

> If you don’t care about the 2nd and the 3rd parameters you are just gonna remove the duplicate sequences

## sequence_cleaner_2

**usage** `python sequence_cleaner.py input[1] min_length[2] min[3] min[4] min[5]  min[6]  min[7]  min[8]  min[9]  min[10]  min[11]  min[12]`

* [1]: your fasta file
* [2]: the user defines the minimum length. Default value 0, it means you don’t have to care about the minimum length
* [3]: the user defines the % of N is allowed. Default value 100, all sequences with ’N’ will be in your ouput, set value to 0 if you want `no` sequences with ”N” in your output
* [4]: the user defines the % of R is allowed. Default value 100, all sequences with ’R’ will be in your ouput, set value to 0 if you want `no` sequences with ”R” in your output
* [5]: the user defines the % of Y is allowed. Default value 100, all sequences with ’Y’ will be in your ouput, set value to 0 if you want `no` sequences with ”Y” in your output
* [6]: the user defines the % of S is allowed. Default value 100, all sequences with ’S’ will be in your ouput, set value to 0 if you want `no` sequences with ”S” in your output
* [7]: the user defines the % of W is allowed. Default value 100, all sequences with ’W’ will be in your ouput, set value to 0 if you want `no` sequences with ”W” in your output
* [8]: the user defines the % of K is allowed. Default value 100, all sequences with ’K’ will be in your ouput, set value to 0 if you want `no` sequences with ”K” in your output
* [9]: the user defines the % of M is allowed. Default value 100, all sequences with ’M’ will be in your ouput, set value to 0 if you want `no` sequences with ”M” in your output
* [10]: the user defines the % of B is allowed. Default value 100, all sequences with ’B’ will be in your ouput, set value to 0 if you want `no` sequences with ”B” in your output
* [11]: the user defines the % of D is allowed. Default value 100, all sequences with ’D’ will be in your ouput, set value to 0 if you want `no` sequences with ”D” in your output
* [12]: the user defines the % of H is allowed. Default value 100, all sequences with ’H’ will be in your ouput, set value to 0 if you want `no` sequences with ”H” in your output
* [13]: the user defines the % of V is allowed. Default value 100, all sequences with ’V’ will be in your ouput, set value to 0 if you want `no` sequences with ”V” in your output

For example:

```python sequence_cleaner_2.py dataset_test.fasta 0 0 0 0 0 0 0 0 0 0 0 0```

For both the output will generate `clear_"your_sequences".fasta`
