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
project_root <- dirname(script_path %||% "")
candidate_roots <- unique(c(project_root, getwd(), dirname(getwd())))
project_root <- ""
for (cand in candidate_roots) {
  if (nzchar(cand) && dir.exists(file.path(cand, "article_data"))) {
    project_root <- cand
    break
  }
}
if (!nzchar(project_root)) {
  project_root <- getwd()
}

article_data_dir <- file.path(project_root, "article_data")

require_or_stop <- function(pkg) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    stop(
      sprintf("Package '%s' is required. Install it in R before running this script.", pkg),
      call. = FALSE
    )
  }
}

read_optional_xlsx <- function(path) {
  if (!file.exists(path)) {
    return(NULL)
  }
  require_or_stop("readxl")
  sheets <- readxl::excel_sheets(path)
  out <- lapply(sheets, function(s) readxl::read_excel(path, sheet = s))
  names(out) <- sheets
  out
}

read_optional_csv <- function(path) {
  if (!file.exists(path)) {
    return(NULL)
  }
  utils::read.csv(path, check.names = FALSE)
}

data_xlsx <- read_optional_xlsx(file.path(article_data_dir, "data.xlsx"))
pca_xlsx <- read_optional_xlsx(file.path(article_data_dir, "pcaData.xlsx"))
plotdata <- read_optional_csv(file.path(article_data_dir, "plotdata.csv"))
pca_beta <- read_optional_csv(file.path(article_data_dir, "pcaBeta.csv"))

cat("Loaded article_data assets:\n")
cat(sprintf("- data.xlsx sheets: %s\n", if (is.null(data_xlsx)) "missing" else paste(names(data_xlsx), collapse = ", ")))
cat(sprintf("- pcaData.xlsx sheets: %s\n", if (is.null(pca_xlsx)) "missing" else paste(names(pca_xlsx), collapse = ", ")))
cat(sprintf("- plotdata.csv rows: %s\n", if (is.null(plotdata)) "missing" else nrow(plotdata)))
cat(sprintf("- pcaBeta.csv rows: %s\n", if (is.null(pca_beta)) "missing" else nrow(pca_beta)))

if (!is.null(plotdata)) {
  cat("\nplotdata.csv columns:\n")
  print(names(plotdata))
}

if (!is.null(pca_beta)) {
  cat("\npcaBeta.csv columns:\n")
  print(names(pca_beta))
}

invisible(list(
  data_xlsx = data_xlsx,
  pca_xlsx = pca_xlsx,
  plotdata = plotdata,
  pca_beta = pca_beta
))
