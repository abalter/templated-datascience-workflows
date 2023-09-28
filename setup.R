#!/bin/env Rscript

suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(here))

args = commandArgs()
# print(args)

has_file = any(str_which(args, "--file.*"))
if (has_file)
{
  this_file =
    args %>%
    str_subset("--file") %>%
    str_remove("--file=")
  this_file_dir = dirname(this_file)
  this_file_name = basename(this_file)
  # str_glue("dir: {this_file_dir}, file: {this_file_name}")
} else
{
  str_glue("somehow no file!")
}

# str_glue("args: {args}")
# str_glue("args flag index: {str_which(args, '--args')}")

has_args_flag_index = any(str_which(args, "--args"))
if (has_args_flag_index)
{
  # str_glue("has args flag index")
  args_flag_index = str_which(args, "--args")
  # str_glue("args_flag_index: {args_flag_index}")
  # str_glue("removing preceeding args")
  args = args[-c(1:args_flag_index)]
  # str_glue("new args: {str_flatten(args, collapse=', ')}")
} else
{
  str_glue("no args.")
  quit()
}

config_file = args[1]
str_glue("config file: {config_file}")
config_dir = dirname(config_file)
config_file_name = basename(config_file)

config_env = new.env()

if (file.exists(here("config_defaults.R")))
{
  print(here("config_defaults.R"))
  str_glue("found default config {here('config_defaults.R')}")
  source(here("config_defaults.R"), local=config_env)
}

source(config_file, local=config_env)

config_data = as.list(config_env)

walk(names(config_data), ~str_glue("{.}: {config_data[.]}") %>% print())
