library(rsconnect)
rsconnect::setAccountInfo(name='dschaadt',
                          token='975BBD964A5DAB59FB95D2995BA278D2',
                          secret='/6L6A1r77riFPQotSrNP5V3oguFQa6QWT+/bOkon')

rsconnect::deployDoc("~/Documents/dschaadt32.github.io/docs/index.Rmd")

