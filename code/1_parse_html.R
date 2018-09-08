library(rvest)
library(purrr)
library(data.table)
library(pbapply)

webpages <- list.files("website_pages/",full.names = T)
#webpages_path <- webpages[61]

extract_data <- function(webpage_path) {
  webpage <- basename(webpage_path)
  doc_year <- paste0(20, substr(webpage,3,4))
  
  f <- readChar(webpage_path, file.info(webpage_path)$size)
  f <- gsub('<sup>',
            '',f, fixed = T)
  f <- gsub('</sup>',
            '',f, fixed = T)
  f <- gsub('<sub>',
            '',f, fixed = T)
  f <- gsub('</sub>',
            '',f, fixed = T)
  
  nodes <- read_html(f, options = "HUGE") %>%
    custom_html_nodes(.,doc_year) %>% 
    .[html_attr(., "style") == "text-align:justify;text-indent:.66cm"] 
  
  authors <- nodes %>% html_node("b") %>% html_text()
  
  
  
  if (doc_year == 2009) {
    f <- gsub('<input type="button" value="Заказать" onClick="writeinvArray()" />',
              '</p>',f, fixed = T)
    nodes <- read_html(f, options = "HUGE") %>%
      html_nodes(css = '.a') %>% 
      .[html_attr(., "style") == "text-align:justify;text-indent:.66cm"] 
    
    doc_numbers <- map_chr(nodes, ~ xml_text(xml_find_all(.x,"*/text()"))[1])
    strings <- map_chr(nodes, ~ trimws(xml_text(xml_find_all(.x,"*/text()")))[2])
    
  }
  
  else {
    doc_numbers <- map_chr(nodes, ~ xml_text(xml_find_all(.x,"./text()"))[1])
    strings <- map_chr(nodes, ~ trimws(xml_text(xml_find_all(.x,"./text()")))[2])
  }
  
  df <- data.frame(year = doc_year,
                   volume = substr(webpage,5,6),
                   number = doc_numbers,
                   author = authors, 
                   text = strings,
                   stringsAsFactors = F)
  print(webpage)
  return(df)
}

custom_html_nodes <- function(data, year) {
  if (year > 2013) {
    return(html_nodes(data,
                      xpath = '//*[contains(concat( " ", @class, " " ), concat( " ", "1", " " ))]'))
  }
  else if (year > 2009) {
    return(html_nodes(data,
                      xpath = '//a//*[contains(concat( " ", @class, " " ), concat( " ", "1", " " ))]'))
  }
  
  #else if (year == 2009) {
  #  return(html_nodes(data, css = ".a a"))}
  else{
    return(html_nodes(data,
                      css = '.a'))
  }
}

#temp <- extract_data(webpages_path)

df_list <- pblapply(webpages, extract_data)

df <- rbindlist(df_list)

write.csv(df, "data/bookchamber_referat.csv", row.names = F)