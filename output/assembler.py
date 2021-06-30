def define_pairs(seq1, seq2):
    tuples = []
    kmer = int(len(seq1))/2
    kmer2 = int(len(seq2))/2
    win = len(seq1)-int(kmer)+1
    for i in range(win):
        new_sequence = seq1[i:int(kmer)+i]
        for j in range(len(seq2)):
            kmer_seq2 = seq2[j:int(kmer2)+j]
            if kmer_seq2 == new_sequence:
                tuples = (seq1, seq2, i, j)
                return tuples
   

def avengers_assemble(seq1, seq2, position_seq1, position_seq2):
    new_sequence = seq1[:position_seq1] + seq2[position_seq2:]
    if new_sequence>=min(seq1, seq2):
        return new_sequence


def caller(reads):
    new_list=[]
    for i in range(len(reads)-1):
        if reads[i] or reads[i+1]:
            pairs = define_pairs(reads[i], reads[i+1])
            if pairs:
                new_contig = avengers_assemble(pairs[0], pairs[1], pairs[2], pairs[3])
                if new_contig:
                    new_list.append(new_contig)
            else: 
                pass
        else:
            pass
    return new_list

def recursive(list):
    new_list = []
    if len(list)>=2:
        new_list = caller(list)
    return new_list

reads =[]
with open("input.txt") as file:
    for line in file:
        line = line.rstrip()
        reads.append(line)

recursive_list = recursive(reads)

while len(recursive_list)>1:
    recursive_list = recursive(recursive_list)
print (recursive_list)