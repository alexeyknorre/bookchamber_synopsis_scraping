library(tidyr)
library(stringr)

'%nin%' <- function(x,y)!('%in%'(x,y))


df <- read.csv("data/bookchamber_referat.csv", stringsAsFactors = F)
#df_full <- df

df <- df_full

df$year_volume <- paste(df$year, formatC(df$volume,width = 2, flag = "0"))
df <- df[c(1,2,6,3,4,5)]


#df <- df[ !duplicated(df$year_volume),]

# Title
df$title <- str_extract(df$text, ".*?(специальность|втореф)")
df$title <- gsub("(: специальность)|(: автореф)", "", df$title)

# Subset those that do not have much data

df$no_data <- 0
df$no_data[df$year_volume == "2012 07" & df$author == "Солодкова Е. В."] <- 1
df$no_data[is.na(df$title)] <- 1


df_no_data <- df[df$no_data == 1,]
df <- df[df$no_data == 0,]

# Degree
df$degree <- str_extract(df$text, "(втореф).*?(:|/)")

# Specialty
df$specialty <- str_extract(df$text, "(пециальность ).*?(:|/)")

# Full name

last_name <- str_extract(df$author, '\\w*-\\w*|\\w*')
df$full_name <- str_extract(df$text, paste0("(",last_name," ).*?(;)"))


# Other text 

df$other_text <- str_extract(df$text, paste0("(",last_name," ).*"))
df$other_text <- substr(df$other_text,
                        nchar(df$full_name),
                        nchar(df$other_text))

# Organization
df$organization <- str_extract(df$other_text, ".*?(\\. -)|.*?(\\. –)|.*?(\\. -)|.*?(\\. −)")
df$other_text <- substr(df$other_text,
                        nchar(df$organization),
                        nchar(df$other_text))
# Place and year
df$place_and_year <- str_extract(df$other_text, ".*?(\\. -)|.*?(\\. –)|.*?(\\. -)|.*?(\\. −)")

# Pages
df$other_text <- substr(df$other_text,
                        nchar(df$place_and_year),
                        nchar(df$other_text))

df$pages <- str_extract(df$other_text, ".*?(\\. -)|.*?(\\. –)|.*?(\\. -)|.*?(\\. −)")

# Unique number
df$other_text <- substr(df$other_text,
                        nchar(df$pages),
                        nchar(df$other_text))

df$unique_no <- str_extract(df$other_text, "\\[.*\\]")

###
write.csv2(df, "data/bookchamber_referat_table.csv", row.names = F)
