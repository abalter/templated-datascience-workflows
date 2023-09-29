#!/bin/env Rscript

library(tidyverse)
# library(here)
# source(here("setup_utils.R"))

### Get the path to THIS file, i.e. setup.R in the workflow code base
### There will be an element in the args vector like "--file=/path/to/this/file"
getSetupFilePath = function(args)
{
  has_file = any(str_which(args, "--file.*"))
  if (has_file)
  {
    this_file =
      args %>%
      str_subset("--file") %>%
      str_remove("--file=")
    this_file_dir = dirname(this_file)
    this_file_name = basename(this_file)
    return(this_file)
    str_glue("dir: {this_file_dir}, file: {this_file_name}") %>% print()
  } else
  {
    str_glue("somehow no file!")
    return(FALSE)
  }
}

this_file = getSetupFilePath(commandArgs())
this_dir = dirname(this_file)
source(file.path(this_dir, "setup_utils.R"))

### Collect command line arguments
### Only positional for now
### And the only argument is the config file path
args =
  commandArgs() %>%
  getArgs()
# print(args)


### The config file path is now the first argument
project_dir = args[1]
str_glue("project dir: {project_dir}")

project_dir = "/home/balter/templated-datascience-workflows/test_proj"

config_data = mergeConfigData(project_dir)

walk(names(config_data), ~str_glue("{.}: {config_data[.]}") %>% print())

### Create a pretty project name
### With or without a timestampe
project_title = createProjectName(config_data)
str_glue("project name: {project_title}")
config_data$project_title = project_title

### Load worflow information
workflow_def_file = str_glue("{config_data$workflow_path}/workflow_meta.R")
source(workflow_def_file)

createProjectDirectories(workflow)
writeProjectNotebooks(config_data)
# writeRunScript(config_data, workflow)
