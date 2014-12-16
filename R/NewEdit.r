#' @title getTitle
#' @description Finds the title from a Markdown document.
#' @details Finds the title from the yaml or as specified by the title argument.
#' @author Jared P. Lander
#' @aliases getTitle
#' @param input The Markdown file being parsed
#' @param title A specified title
#' @return The title to be used in the HTML output
#' @examples
#' See reference
getTitle <- function(input, title)
{
    # if title is not specified, get it from the yaml
    if(missing(title))
    {
        # read Rmd file
        input_lines <- readLines(input)
        
        # get yaml
        yaml <- rmarkdown:::parse_yaml_front_matter(input_lines = input_lines)
        
        # get title
        title <- yaml$title
    }
    
    return(title)
}

#' @title buildContent
#' @description Builds an HTML fragment to upload to WordPress.
#' @details Builds an HTML fragment using \code{\link{rmarkdown::render}} and packs it into a list appropriate for uploading with the WordPress API.
#' @author Jared P. Lander
#' @aliases buildContent
#' @param input The Markdown file being parsed
#' @param title A specified title
#' @param parentid Optional argument to make this file the child of another file
#' @return A list appropriate for the WordPress API consisting of description (the content), title and possibly the parentid.
#' @examples
#' See reference
buildContent <- function(input, title, parentid)
{
    # figure out the title
    title <- getTitle(input, title)
    
    # setup a temp file for rendering fragment
    tempName <- "TempNamejhfdg736her.html"
    # render the fragment
    rendered <- render(input = input, output_format = "html_fragment", output_file = tempName)
    
    # read in the fragment, and collapse it using \n
    description <- tempName %>% readLines %>% paste(collapse="\n")
    
    # build content list
    content <- list(description=description, title=title)
    
    # if there is a parentid let's add it
    if(!missing(parentid))
    {
        content <- c(wp_page_parent_id=as.integer(parentid), content)
    }
    
    # delete temp file
    file.remove(tempName)
    
    return(content)
}

#options(WordpressLogin = c(admin = 'g0@lie35'), WordpressURL = "http://internal.landeranalytics.com/wordpress/xmlrpc.php")

#' @title pageNew
#' @description Builds an HTML fragment to upload to WordPress.
#' @details Builds an HTML fragment using \code{\link{rmarkdown::render}} and packs it into a list appropriate for uploading with the WordPress API.
#' @author Jared P. Lander
#' @aliases pageNew
#' @export pageNew
#' @param input The Markdown file being parsed
#' @param title A specified title
#' @param publish
#' @param parentid Optional argument to make this file the child of another file
#' @return A list appropriate for the WordPress API consisting of description (the content), title and possibly the parentid.
#' @examples
#' See reference
pageNew <- function(input, title, publish=TRUE, 
                    login=getOption("WordpressLogin", stop("need a login and password")), 
                    server=getOption("WordpressURL", stop("need a URL")), parentid)
{
    # build content list
    content <- buildContent(input = input, title = title, parentid)
    # call newPage
    newPage(content = content, publish = publish, login = login, .server = .server)
}

postNew <- function(input, title, publish=TRUE, 
                    login=getOption("WordpressLogin", stop("need a login and password")), 
                    server=getOption("WordpressURL", stop("need a URL")))
{
    # build content list
    content <- buildContent(input = input, title = title)
    
    # call newPost
    newPost(content = content, publish = publish, login = login, .server = .server)
}

postEdit <- function(input, title, publish=TRUE, 
                     login=getOption("WordpressLogin", stop("need a login and password")), 
                     .server=getOption("WordpressURL", stop("need a URL")), postid)
{
    # stop if no postid is specified
    if(missing(postid))
    {
        stop("You must specify a postid")
    }
    
    # build content list
    content <- buildContent(input = input, title = title)
    
    # call editPost
    editPost(postid = as.integer(postid), content = content, publish = publish, login = login, .server = .server)
}