
rm(list = ls())

`%||%` <- function(x, y) {
  if (is.null(x) || length(x) == 0 || is.na(x)) y else x
}

script_path <- tryCatch(normalizePath(sys.frames()[[1]]$ofile, winslash = "/", mustWork = FALSE), error = function(e) "")
if (!nzchar(script_path)) {
  trailing_args <- commandArgs(trailingOnly = TRUE)
  if (length(trailing_args) > 0 && file.exists(trailing_args[1])) {
    script_path <- normalizePath(trailing_args[1], winslash = "/", mustWork = FALSE)
  }
}
script_dir <- dirname(script_path %||% "")
candidate_dirs <- unique(c(
  script_dir,
  getwd(),
  file.path(getwd(), "algorithm"),
  dirname(getwd())
))
script_dir <- ""
for (cand in candidate_dirs) {
  if (nzchar(cand) && dir.exists(cand) && file.exists(file.path(cand, "function_basic.R"))) {
    script_dir <- cand
    break
  }
}
if (!nzchar(script_dir)) {
  script_dir <- getwd()
}
setwd(script_dir)

algorithm_dir <- script_dir
project_root <- normalizePath(file.path(algorithm_dir, ".."), winslash = "/", mustWork = FALSE)
generated_data_dir <- file.path(algorithm_dir, "generated_data")
results_root <- file.path(algorithm_dir, "results")
dir.create(generated_data_dir, recursive = TRUE, showWarnings = FALSE)
dir.create(results_root, recursive = TRUE, showWarnings = FALSE)

t_start <- Sys.time()

source("./function_basic.R")
source("./function_bandwidths.R")
source("./function_estimation.R")
source("./simulation_pre.R")

first_sim_file <- file.path(generated_data_dir, sprintf("data_N=%s_test1.csv", N))
if (!file.exists(first_sim_file)) {
  message("No generated simulation data found. Creating data in ./generated_data ...")
  source("./data_generation.R")
}

source("./calibration_n_times.R")

t_end <- Sys.time()
time <- t_end - t_start
print(time)





