
# roll back curl to a stable version for macos
install.packages("http://cran.r-project.org/src/contrib/Archive/curl/curl_6.2.3.tar.gz",
                 repos = NULL,
                 type = "source")

rsconnect::removeAccount('dschaadt', server = 'shinyapps.io') 

# Re-run setAccountInfo with your credentials
rsconnect::setAccountInfo(name= "dschaadt",
                          token = token,
                          secret = secret) 

# Then try the deployment again
rsconnect::deployDoc("docs/index.Rmd")
