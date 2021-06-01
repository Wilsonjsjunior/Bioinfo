import sys
from Bio import SeqIO


def sequence_cleaner(fasta_file, min_length=0, por_n=100, por_r=100, por_y=100, por_s=100, por_w=100, por_k=100, por_m=100, por_b=100, por_d=100, por_h=100, por_v=100):
    # Create our hash table to add the sequences
    sequences = {}

    # Using the Biopython fasta parse we can read our fasta input
    for seq_record in SeqIO.parse(fasta_file, "fasta"):
        # Take the current sequence
        sequence = str(seq_record.seq).upper()
        # Check if the current sequence is according to the user parameters
        if (
            len(sequence) >= min_length
            and (float(sequence.count("N")) / float(len(sequence))) * 100 <= por_n
            and (float(sequence.count("R")) / float(len(sequence))) * 100 <= por_r
            and (float(sequence.count("Y")) / float(len(sequence))) * 100 <= por_y
            and (float(sequence.count("S")) / float(len(sequence))) * 100 <= por_s
            and (float(sequence.count("W")) / float(len(sequence))) * 100 <= por_w
            and (float(sequence.count("K")) / float(len(sequence))) * 100 <= por_k
            and (float(sequence.count("M")) / float(len(sequence))) * 100 <= por_m
            and (float(sequence.count("B")) / float(len(sequence))) * 100 <= por_b
            and (float(sequence.count("D")) / float(len(sequence))) * 100 <= por_d
            and (float(sequence.count("H")) / float(len(sequence))) * 100 <= por_h
            and (float(sequence.count("V")) / float(len(sequence))) * 100 <= por_v
        ):
            # If the sequence passed in the test "is it clean?" and it isn't in the
            # hash table, the sequence and its id are going to be in the hash
            if sequence not in sequences:
                sequences[sequence] = seq_record.id
            # If it is already in the hash table, we're just gonna concatenate the ID
            # of the current sequence to another one that is already in the hash table
            else:
                sequences[sequence] += "_" + seq_record.id

    # Write the clean sequences

    # Create a file in the same directory where you ran this script
    with open("clear_" + fasta_file, "w+") as output_file:
        # Just read the hash table and write on the file as a fasta format
        for sequence in sequences:
            output_file.write(">" + sequences[sequence] + "\n" + sequence + "\n")

    print("CLEAN!!!\nPlease check clear_" + fasta_file)


userParameters = sys.argv[1:]

try:
    if len(userParameters) == 1:
        sequence_cleaner(userParameters[0])
    elif len(userParameters) == 2:
        sequence_cleaner(userParameters[0], float(userParameters[1]))
    elif len(userParameters) == 3:
        sequence_cleaner(userParameters[0], float(userParameters[1]), float(userParameters[2]))
    elif len(userParameters) == 4:
        sequence_cleaner(userParameters[0], float(userParameters[1]), float(userParameters[2]), float(userParameters[3]))
    elif len(userParameters) == 5:
        sequence_cleaner(userParameters[0], float(userParameters[1]), float(userParameters[2]), float(userParameters[3]), float(userParameters[4]))
    elif len(userParameters) == 6:
        sequence_cleaner(userParameters[0], float(userParameters[1]), float(userParameters[2]), float(userParameters[3]), float(userParameters[4]), float(userParameters[5]))
    elif len(userParameters) == 7:
        sequence_cleaner(userParameters[0], float(userParameters[1]), float(userParameters[2]), float(userParameters[3]), float(userParameters[4]), float(userParameters[5]), float(userParameters[6]))
    elif len(userParameters) == 8:
        sequence_cleaner(userParameters[0], float(userParameters[1]), float(userParameters[2]), float(userParameters[3]), float(userParameters[4]), float(userParameters[5]), float(userParameters[6]), float(userParameters[7]))
    elif len(userParameters) == 9:
        sequence_cleaner(userParameters[0], float(userParameters[1]), float(userParameters[2]), float(userParameters[3]), float(userParameters[4]), float(userParameters[5]), float(userParameters[6]), float(userParameters[7]), float(userParameters[8]))
    elif len(userParameters) == 10:
        sequence_cleaner(userParameters[0], float(userParameters[1]), float(userParameters[2]), float(userParameters[3]), float(userParameters[4]), float(userParameters[5]), float(userParameters[6]), float(userParameters[7]), float(userParameters[8]), float(userParameters[9]))
    elif len(userParameters) == 11:
        sequence_cleaner(userParameters[0], float(userParameters[1]), float(userParameters[2]), float(userParameters[3]), float(userParameters[4]), float(userParameters[5]), float(userParameters[6]), float(userParameters[7]), float(userParameters[8]), float(userParameters[9]), float(userParameters[10]))
    elif len(userParameters) == 12:
        sequence_cleaner(userParameters[0], float(userParameters[1]), float(userParameters[2]), float(userParameters[3]), float(userParameters[4]), float(userParameters[5]), float(userParameters[6]), float(userParameters[7]), float(userParameters[8]), float(userParameters[9]), float(userParameters[10]), float(userParameters[11]))
    elif len(userParameters) == 13:
        sequence_cleaner(
            userParameters[0], float(userParameters[1]), float(userParameters[2]), float(userParameters[3]), float(userParameters[4]), float(userParameters[5]), float(userParameters[6]), float(userParameters[7]), float(userParameters[8]), float(userParameters[9]), float(userParameters[10]), float(userParameters[11]), float(userParameters[12])
        )
    else:
        print("There is a problem!")
except:
    print("There is a problem!")
