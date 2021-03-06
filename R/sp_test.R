#' @title
#' Tests \code{stored_procedure} functionality on the local machine.
#' 
#' @description
#' \code{stored_procedure} is the workhorse of \code{pocr}. However, the strings
#' it produces are only useful if the local machine is correctly configured to 
#' connect to a POC SQL server, the database(s) involved are up to date, and 
#' if the stored procedures called by the strings are valid.
#' 
#' \code{sp_test} creates the SQL call strings for all available stored 
#' procedures and tests the results of attempting to use each one to retrieve
#' data from a specified POC SQL server.
#' 
#' This function allows you to quickly check if the strings produced by 
#' \code{stored_procedure} can be used to get valid results on the local 
#' machine.
#' 
#' More specifically, the function will let you determine if:
#' \itemize{
#'   \item The provided POC SQL server connection works for accessing the
#'   needed database(s) and table(s).
#'   \item Each of the available stored procedures return valid results.
#' }
#' 
#' @param connection An RODBC connection or a character vector that can be
#' passed to \code{odbcConnect} to create an RODBC connection appropriate for 
#' your local machine and the server you want to test.
#' @param target_server POC has a few different servers you may want to 
#' test against, test-annie (use MySQL) and poc (uses SQL server). You 
#' need to specify which to test against: 'test_annie' or 'mysql' (equivalent), 
#' 'poc' or 'sqlserver' (equivalent).
#' @param close_connection Boolean specifying if the provided or created
#' connection should be closed by the sp_test function. Defaults to \code{TRUE}.
#' 
#' @return
#' When run, the function sends messages to the console describing the phases
#' the function is running through. If the function completes without any
#' connection or package errors, it returns a list with three pieces. 
#' 
#' The first piece is a data frame ($sp_summary) summarizing the fate of 
#' each stored procedure call to the target server. This provides a quick
#' summary of whether each stored procedure returned a data frame and states
#' the number of columns and rows in the return.
#' 
#' The second is a data frame ($sp_strings) of the stored procedure names and 
#' the strings prepared for each by the stored_procedure function. This is 
#' useful for checking that valid strings were prepared and for seeing exactly 
#' what was passed to the server.
#' 
#' The third is a named list ($sp_details) of the data returned by each 
#' stored procedure call. This is useful for investigating stored procedures 
#' that were problematic and for manual inspection of stored procedure results 
#' in general.
#' 
#' @note 
#' \code{sp_test} is configured to use its own print method. By default, 
#' printing the results of \code{sp_test} will only return the summary object
#' ($sp_summary). 
#' 
#' @export
sp_test <- function(connection, target_server = "test_annie",
                    close_connection = TRUE) {
    # test if user provided valid input for the 'target_server" parameter
    message("Testing if 'target_server' input is valid...")
    if(target_server %in% eval(formals(pocr::stored_procedure)$db)) {
        message("Success. \n")
    } else {
        stop("'target_server' must name a valid POC server - see ?sp_test")
    }
    
    # test if user provided valid input for the 'connection' parameter and
    # make the connection if character vector provided
    message("Testing if 'connection' input is valid...")
    conn_result <- pocr::validate_RODBC_input(connection)
    if(conn_result$test_result) {
        validated_conn <- conn_result$connection
        message(conn_result$test_message)
    } else {
        stop(conn_result$test_message)
    }
    
    # attempt to get the current collection of stored procedures from the 
    # stored_procedure function definition
    message("Getting the current list of supported stored procedures...")
    
    try(sp_names <- eval(formals(pocr::stored_procedure)$sp), silent = TRUE)
    if(exists("sp_names") && !is.null(sp_names)) {
        message("Success. \n")
    } else {
        stop(paste0("unable to retrieve list from the function ", 
                    "pocr::stored_procedure"))
    }
    
    # create a call for each stored procedure with the default arguments (all
    # 0s)
    message("Creating a vector with all basic stored procedure strings...")
    
    sp_strings <- unlist(lapply(sp_names, 
                                function(x) pocr::stored_procedure(x, 
                                                                   target_server)))
    message("Success. \n")
    
    # run each stored procedure call with the given RODBC connection and collect
    # the results
    message("Attempting to run each stored procedure against target server...")
    sp_details <- lapply(sp_strings, 
                         function(x) sqlQuery(validated_conn, x))
    message("Success. \n")
    
    # here is where we tidy up any open connections unless the user specifies
    # explicitly otherwise
    if(close_connection) {
        odbcClose(validated_conn)
    }
    
    # assess the call details to assess if the returned items are data frames
    # and try to count their rows and columns
    message("Checking and summarizing stored procedure results...")
    sp_returns_df <- lapply(sp_details, is.data.frame)
    num_col <- lapply(sp_details, ncol)
    num_row <- lapply(sp_details, nrow)
    sp_summary <- data.frame(cbind(sp_names,
                                   sp_returns_df,
                                   num_col,
                                   num_row))
    message("Success. \n")
    
    # format the strings and details for easy navigation between the
    # various test objects
    sp_strings <- data.frame(cbind(sp_names,
                                   sp_strings))
    names(sp_details) <- sp_names
    
    # gather the key test materials
    message("Gathering test results...")
    test_results <- list("sp_summary" = sp_summary,
                         "sp_strings" = sp_strings, 
                         "sp_details" = sp_details)
    message("Success. \n")
    
    # assign the results the sp_results class so they print nicely
    class(test_results) <- "sp_results"
    
    return(test_results)
}

#' Print method for sp_test.
#' 
#' Simple method to insure that the result turned by sp_test only prints out
#' the concise summary by default. Not exported.
#' 
#' @param x Object to print (inherited from print).
#' @param ... Additional arguments to pass to print.
print.sp_results = function(x, ...) {
    print(x$sp_summary)
}