# This script downloads and extracts the data of the censo 2002 of Chile
# from the page http://datos.gob.cl/datasets/ver/4117
# This will only work in unix sytems
# This script will download app 2.1G of data

download <- function(row) {
    resource.url <- row[3]
    resource.name <- row[2]
    print(paste("Checking", resource.name, "...", sep=" "))
    if (!file.exists(resource.name)) {
        print("File is not present, downloading...")
        download.file(resource.url, resource.name, method = "curl", extra="-L")
    }
}

gunzip <- function(file) {
    file.sav <- substr(file, 0, nchar(file)-3)
    if (!file.exists(file.sav)) {
        print(paste("Unzipping", file, "...", sep=" "))
        system(paste("gunzip -k", file, sep=" "))
    }
}

data <- read.csv("download.csv", header = FALSE, sep = ";")
apply(data, 1, download)

# Checking if the parts of persona are present to create a new file
if (!file.exists("persona.sav.gz")) {
    print("Pasting persona...")
    system("cat persona.sav.gz.00* > persona.sav.gz", intern = FALSE)
}

gz.files = system("ls *.gz", intern = TRUE)
lapply(gz.files, gunzip)
