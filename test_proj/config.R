project_name = "test_project"
timestamp = F

workflow_path = "~/rnaseq_workflow"
fastq_path = "raw_sequences"

### FastQC
# use deafult

### Trim
trim_left = 30
trim_right = 50
min_score = 30
trim_diagnostics = "all"

### Align
# use default algorithm
num_threads = 8
mark_short_splits = "-M \\\n"
alignment_diagnositcs = "all"

