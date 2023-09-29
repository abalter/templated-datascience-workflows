### Load libraries
library(tidyverse)
library(here)
library(whisker)

default_paths = c("src", "results", "reports", "logs")

makePrettyTitles = function(text)
{
  text %>%
    str_replace_all("_", " ") %>%
    str_to_title() %>%
    return()
}


createProjectName = function(config_data)
{
  pretty_project_name = makePrettyTitles(config_data$project_name)

  if (config_data$timestamp)
  {
    timestampe = format(Sys.time(), "%Y%d%m_%H%M%S")
    return(str_glue("{pretty_project_name}_{timestampe}"))
  } else
  {
    return(pretty_project_name)
  }
}


createProjectDirectories = function(workflow)
{
  for (step in names(workflow))
  {
    str_glue("analysis step: {step}") %>% print()

    ### Create default project folders in each step. Use the "recursive"
    ### flag so I don't have to create each step folder as well
    for (dir in default_paths)
    {
      str_glue("creating folder {file.path(project_dir, step, dir)}") %>% print()
      dir.create(
        path = file.path(project_dir, step, dir),
        recursive = T,
        showWarnings = F
      )
    }

  }

}


writeProjectNotebooks = function(config_data)
{
  workflow_path = config_data$workflow_path
  workflow_meta_file = file.path(workflow_path, "workflow_meta.R")
  workflow_def_env = new.env()
  workflow_def_data = loadConfigData(workflow_meta_file)
  workflow = workflow_def_data$workflow

  ### Get the path to the template. This comes from the workflow definition
  templates_path = file.path(config_data$workflow_path, "templates")
  header_template_text = read_file(file.path(templates_path, "template_header.Rmd"))

  for (step in names(workflow))
  {
    str_glue("analysis step: {step}") %>% print()

    templates = workflow[[step]][['templates']]
    str_glue("templates: {templates}") %>% print()

    ### Interpolate templates into step/src directory
    for (template in templates)
    {
      template_filename = str_glue("{template}.Rmd")
      project_title =
        step %>%
        str_replace_all("_", " ") %>%
        str_to_title()
      template_header_text = whisker.render(header_template_text)

      str_glue("template filename: {template_filename}") %>% print()

      template_file_path = file.path(templates_path, template_filename)
      str_glue("template file path: {template_file_path}") %>% print()

      template_file_text = read_file(template_file_path)
      # cat(template_file_text)

      ### Interpolate variables and parameters from the config file
      notebook_file_text = whisker.render(template_file_text, config_data)
      # cat(notebook_file_text)

      ### Full path for notebook file has many parts
      notebook_file_path =
        file.path(
          project_dir, # <-- from config data
          step,        # <-- from workflow definition
          "src",       # <-- default location for source files
          template_filename # <-- filename of notebook
        )
      str_glue("notebook file path: {notebook_file_path}") %>% print()

      write_file(notebook_file_text, file=notebook_file_path)
    }

  }
}


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
    # str_glue("dir: {this_file_dir}, file: {this_file_name}")
  } else
  {
    str_glue("somehow no file!")
    return(FALSE)
  }
}


getArgs = function(args)
{

  ### If the call included arguments, then the args vector will have an element
  ### like "--args". The subsequent elements are the arguments.
  ### First check if this element exists, i.e. arguments are present
  has_args_flag_index = any(str_which(args, "--args"))
  if (has_args_flag_index)
  {
    # str_glue("has args flag index")

    ### Find the index for the "--args" element
    args_flag_index = str_which(args, "--args")
    # str_glue("args_flag_index: {args_flag_index}")
    # str_glue("removing preceding elements")

    ### Remove preceding elements
    args = args[-c(1:args_flag_index)]
    # str_glue("new args: {str_flatten(args, collapse=', ')}")
  } else
  {
    str_glue("no args.")
    return(FALSE)
    # quit()
  }
}


loadConfigData = function(config_file_path)
{
  str_glue("loadConfigData({config_file_path}")
  ### Create an environment to hold the project data
  config_env = new.env()

  ### Read the default config data into an environment
  ### If not exist, empty environment
  if (file.exists(config_file_path))
  {
    str_glue("found config file{config_file_path}") %>% print()
    source(config_file_path, local=config_env)
  } else
  {
    str_glue("No default config")
  }

  return(as.list(config_env))
}


mergeConfigData = function(project_dir)
{
  str_glue("mergeConfigData({project_dir})") %>% print()

  ### First we need to load any default config data from the workflow definition.
  ### However, the workflow definition path is in the project config file,
  ### so load it first.
  config_env = new.env()

  project_config_file_path = file.path(project_dir, "config.R")
  project_config_data = loadConfigData(project_config_file_path)

  default_config_file_path = file.path(project_config_data$workflow_path, "default_config.R")
  default_config_data = loadConfigData(default_config_file_path)

  ### Merge the project config data over the default config data
  merged_config_data = default_config_data
  merged_config_data[names(project_config_data)] = project_config_data

  return(merged_config_data)
}
