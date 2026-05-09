project_root <- getwd()
algorithm_dir <- file.path(project_root, "algorithm")

if (!dir.exists(algorithm_dir)) {
  stop("Run this script from the code_bundle root directory.", call. = FALSE)
}

setwd(algorithm_dir)
source("main.R", local = new.env())
