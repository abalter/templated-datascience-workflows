templates_path = "templates"

for (name in names(config_data))
{
  # print(name)
  # print(config_data[[name]])
  assign(name, config_data[[name]])
}
# walk(names(config_data), function(x) assign(x, config_data[[x]]))

workflow = list(
  setup = list(
    templates = "run_fastqc",
    parameters = list(fastqc_something = fastqc_something)
  ),

  trim = list(
    templates = c("trim_sequences", "trim_diagnostics"),
    parameters = list(
      trim_left = trim_left,
      trim_right = trim_left,
      min_score =  min_score,
      trim_diagnostics =  trim_diagnostics
    )
  ),

  align = list(
    templates = c("run_bwa", "alignment_diagnostics"),
    parameters = list(
      bwa_algorithm = bwa_algorithm,
      alignment_diagnositcs = alignment_diagnositcs
    )
  )
)
# as.yaml(workflow) %>% cat()

#
# steps_to_run_str = str_glue("
# setup:
#   templates:
#   - run_fastqc
#   parameters:
#     fastqc_something: {fastqc_something}
# trim:
#   templates:
#   - trim_sequences
#   - display_diagnostics
#   parameters:
#     trim_left: {trim_left}
#     trim_right: {trim_right}
#     min_score: {min_score}
#     trim_diagnostics: {trim_diagnostics}
# align:
#   templates:
#   - run_bwa
#   - display_diagnostics
#   parameters:
#     bwa_algorithm: {bwa_algorithm}
#     alignment_diagnositcs: {alignment_diagnositcs}
# ")
# yaml.load(steps_to_run_str)

