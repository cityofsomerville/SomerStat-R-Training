
options(rsconnect.check.certificate = FALSE)
rsconnect::setAccountInfo(name='dschaadt',
                          token = token,
                          secret = secret)

rsconnect::deployDoc("docs/index.Rmd")
