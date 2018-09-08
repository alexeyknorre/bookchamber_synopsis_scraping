for (year in 2005:2016) {
  for (volume in 1:12) {
    address <- paste0("http://gbu.bookchamber.ru/members/content/auto/",
                      year,
                      "/AL",
                      substr(year,3,4),
                      formatC(volume, width=2, flag="0"),
                      "_l.HTM")
    
    download.file(address,
                  file.path("website_pages",
                            basename(address)),
                  mode = "wb")
    print(paste0(year,volume))
    Sys.sleep(1)
  }
}
