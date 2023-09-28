# Templated Data Science Workflow

1.  Set default values
2.  Read config file into structure
3.  Create project folder (data in config file)
4.  Copy config file to project
5.  Create Readme
6.  Get list of analysis steps
7.  Get list of templates
8.  For each analysis step:

```{=html}
<!-- -->
```
    analysis/
      |_src/
      |_reports/
      |_results/
      |_logs/

6.  Render templates into src
7.  Create run script

```{=html}
<!-- -->
```
    project/
      |_meta/
        |_config
        |_README.md
        |_README.html
        |_README.pdf
      |_run
      |_setup/
        |_src
          |_file.sh
          |_file_2.Rmd
          |_...
        |_reports/
          |_notebook_1.nb.html
          |_notebook_2.nb.html
          |_...
        |_results/
          |_result_1.csv
          |_result_2.xlsx
          |_...
        |_logs/
          |_setup.err
          |_setup.out
          |_setup/
      |_analysis_part_A
        |_src
          |_analysis_part_A_1.Rmd
          |_analysis_part_A_2.Rmd
          |_analysis_part_A_util.R
        |_reports/
          |_analysis_part_A_1.nb.html
          |_analysis_part_A_2.nb.html
          |_...
        |_results/
          |_analysis_part_A_result.csv
          |_analysis_part_A_result.xlsx
          |_...
        |_logs/
          |_analysis_part_A_1.err
          |_analysis_part_A_1.out
          |_...
      |_analysis_part_B
        |_src
          |_analysis_part_B_1.Rmd
          |_analysis_part_B_2.Rmd
          |_analysis_part_B_util.R
        |_reports/
          |_nalysis_part_B_1.nb.html
          |_nalysis_part_B_2.nb.html
          |_...
        |_results/
          |_analysis_part_B_result.csv
          |_analysis_part_B_result.xlsx
          |_...
        |_logs/
          |_analysis_part_B_1.err
          |_analysis_part_B_1.out
          |_...
        
