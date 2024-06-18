cache_dir <- "docs/_cache"

if (dir.exists(cache_dir)) {
  unlink(cache_dir, recursive = TRUE)
}
rmarkdown::run("docs/index.Rmd")


