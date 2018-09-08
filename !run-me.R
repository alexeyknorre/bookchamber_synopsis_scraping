### Master-script to download and parse avtoreferaty from bookchamber.ru
### Alexey Knorre
### 8/9/18

### Prepare packages
if (!require("pacman", character.only = TRUE)){
  install.packages("pacman", dep = TRUE)
  if (!require("pacman", character.only = TRUE))
    stop("Package not found")
}

# these are the required packages
pkgs <- c(
  "rvest",
  "purrr",
  "data.table",
  "pbapply",
  "tidyr",
  "stringr"
)

# install the missing packages
# only run if at least one package is missing
if(!sum(!p_isinstalled(pkgs))==0){
  p_install(
    package = pkgs[!p_isinstalled(pkgs)], 
    character.only = TRUE
  )
}

dir.create("data")
dir.create("website_pages")

eval(parse("code/0_save_webpages.R", encoding = "UTF-8"))
eval(parse("code/1_parse_html.R", encoding = "UTF-8"))
eval(parse("code/2_parse_strings.R", encoding = "UTF-8"))