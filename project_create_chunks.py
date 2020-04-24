
from Bio import SeqIO
from Bio.SeqRecord import SeqRecord
path = '/data/ficklin_class/AFS505/course_material/data/all.pep'
chunk_number = 10
records = list(SeqIO.parse(path, "fasta"))
chunk_size = sum(len(r) for r in records) // chunk_number + 1


def create_batch(records, chunk_size):
	record_it = iter(records)

	record = next(record_it)
	current_base = 0

	batch = []
	batch_size = 0

	while record:
        # Loop over records untill the batch is full. (or no new records)
		while batch_size != chunk_size and record:

			end = current_base + chunk_size - batch_size
			seq = record[current_base:end]

			end_of_slice = current_base + len(seq) - 1
			fasta_header = record.id + ":{}-{}".format(current_base, end_of_slice)

			seq.description = ''
			batch.append(seq)

			current_base += len(seq)
			batch_size += len(seq)

            # Current record is exhausted, get a new one.
			if current_base >= len(record):
				record = next(record_it, None)
				current_base = 0

        # We have a batch with the correct size (or no new bathces)
		yield batch
		batch = []
		batch_size = 0

chunked_files = []
for i, batch in enumerate(create_batch(records, chunk_size)):
	filename = "chunk{}.fasta".format(i)
	SeqIO.write(batch, filename, "fasta")
	chunked_files.append(filename)
print(f"These files have been chunked and placed in your current directory: {chunked_files}")
	

		

	
