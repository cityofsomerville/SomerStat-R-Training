
cache_dir <- "docs/_cache"

if (dir.exists(cache_dir)) {
  unlink(cache_dir, recursive = TRUE)
}
rmarkdown::run("docs/index.Rmd")

rsconnect::setAccountInfo(name='dschaadt',
                          token='975BBD964A5DAB59FB95D2995BA278D2',
                          secret='/6L6A1r77riFPQotSrNP5V3oguFQa6QWT+/bOkon')

rsconnect::deployDoc("docs/index.Rmd")

