require(RSelenium)
RSelenium::checkForServer()
RSelenium::startServer()
remdr <- remoteDriver()
remdr$open()  #will open the browser
remdr$navigate("https://www.linkedin.com/vsearch/p?openAdvancedForm=true&locationType=Y&f_ED=15891&rsid=597444871434112710513&orig=ADVS&page_num=2&pt=people&openFacets=N,G,CC,ED&f_N=F,S,A,O")
df <- data.frame(MemberNames = "", Titles = "")
df$MemberNames <- as.character(df$MemberNames)
df$Titles <- as.character(df$Titles)

# loop fetch
k = 1
while (k < 3) {
    user_names <- remdr$findElements(using = "xpath", value = "//*/a[@class='title']")
    user_titles <- remdr$findElements(using = "xpath", value = "//*/div[@class='description']")
    user_names_i <- unlist(lapply(user_names, function(x) {
        x$getElementText()
    }))
    user_titles_i <- unlist(lapply(user_titles, function(x) {
        x$getElementText()
    }))
    # add
    # append(df$MemberNames,user_names,after=length(df$MemberNames))
    # append(df$Titles,user_titles,after=length(df$Titles))
    # form a list and then rbind:
    temp_list <- list(user_names_i, user_titles_i)
    df <- rbind(df, temp_list)
    # click
    page_number = paste("Page", k)
    value_param = paste0("//*/a[@title='", page_number, "']")
    
    next_page <- remdr$findElement(using = "xpath", value = value_param)
    next_page$clickElement()
    k = k + 1
} 
