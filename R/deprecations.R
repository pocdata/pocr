###############################################################################
## deprecations.R

# This is a collection of functions that have been renamed or replaced in the
# current version of pocr. 

# These functions will be removed in future pocr versions but are retained
# here with deprecation warnings so that dependencies can be identified and 
# corrected without code breaking everywhere.

# It is the responsibility of the updater to insure that updated functions
# will accept the old function arguments during the deprecation cycle. 

# Alternitavely, you can:
# - give the updated version a new name
# - treat the old version as a deprecation due to removal
# - rename the updated version after the deprecation cycle and use the 
#   deprecation due to rename process to direct people back to the original name

# EXAMPLE OF DEPRECATION DUE TO RENAME:
# Deprecated. Use \code{new_version}.
#
# @param ... All input passed to new function.
# oldVersion <- function(...) {
#     warning("
#             'oldVersion is deprecated as of pocr VX.X and will be removed in 
#             future versions of pocr. Use 'new_version' instead.
#             ")
#     
#     # arguments passed to updated function
#     new_version(...)
# }

# EXAMPLE OF DEPRECATION DUE TO REMOVAL:
# @title Likely to be removed in future versions. Avoid dependencies.
# 
# current_function_documentation
# function_to_remove <- function(args) {
#     warning("
#             'function_to_remove' is no longer supported as of pocr VX.X and
#             will be removed in future versions of pocr. Please check the 
#             package documentation for alternative solutions or contact the
#             package administrator for support - use 'maintainer('pocr')' to
#             get contact details.
#             ")
#             
#             function_code...
# }

###############################################################################

# V1.1: update_county_data() removed, no intermediate steps

# V1.0: trend_plot and context_plot were completely replaced with updated 
# versions, no intermediate steps

# v1.0: trend_plot2, trend_plot3, and trend_plot_state were removed from the
# package, no intermediate steps

# V1.0: stored_procedure was updated with sp_cr code, sp_cr is deprecated below
# as a rename

# read.sql renamed to read_sql
#' Deprecated. Use \code{read_sql}.
#' 
#' @param ... All input passed to new function.
read.sql <- function(...) { 
    warning("
            'read.sql' is deprecated as of pocr V1.0 and will be removed in
            future versions of pocr. Use 'read_sql' instead.
            ")
    
    # arguments passed to updated function
    read_sql(...)
}

# fac.to.num renamed to factor_to_number
#' Deprecated. Use \code{factor_to_number}.
#' 
#' @param ... All input passed to new function.
fac.to.num <- function(...) {
    warning("
            'fact.to.num' is deprecated as of pocr V1.0 and will be removed in
            future versions of pocr. Use 'factor_to_number' instead.
            ")
    
    # arguments passed to updated function
    factor_to_number(...)
}

# layOut renamed to lay_out
#' Deprecated. Use \code{lay_out}.
#' 
#' @param ... All input passed to new function.
layOut <- function(...) {
    warning("
            'layOut' is deprecated as of pocr V1.0 and will be removed in
            future versions of pocr. Use 'lay_out' instead.
            ")
    
    # arguments passed to updated function
    lay_out(...)
}

# sp_cr renamed as stored_procedure
#' Deprecated. Use \code{stored_procedure}.
#' 
#' @param ... All input passed to new function.
sp_cr <- function(...) {
    warning("
            'sp_cr' is deprecated as of pocr V1.0 and will be removed in
            future versions of pocr. Use 'stored_procedure' instead.
            ")
    
    # arguments passed to updated function
    stored_procedure(...)
}

# remove - unused
#' Likely to be removed in future versions. Avoid dependencies.
#' 
#' Mode of a vector. Found on Stackoverflow.
#' 
#' @param x Vector for which you want to know the mode.
#' 
#' @export
Mode <- function(x) {
    warning("
            'Mode' is no longer supported as of pocr V1.0 and
            will be removed in future versions of pocr. Please check the 
            package documentation for alternative solutions or contact the
            package administration for support - use 'maintainer('pocr')' to
            get contact details.")
    
    ux <- unique(x)
    ux[which.max(tabulate(match(x, ux)))]
}

# remove - maybe not necessary; should get made a data object if want to keep
#' Stored Procedure Names (may be removed - avoid dependencies)
#' 
#' sp_names returns the names of all stored procedures.
sp_names <- c("ia_trends_counts", "ia_trends_rates", "ia_safety",
              "ooh_pit_counts", "ooh_pit_rates", "ooh_flow_entries_counts",
              "ooh_flow_entries_rates", "ooh_flow_exits", "ooh_reentry",
              "ooh_outcomes", "ooh_outcomes_12m", "ooh_outcomes_24m",
              "ooh_outcomes_3m", "ooh_wb_familysettings", "ooh_wb_siblings",
              "ooh_wb_siblings_pvt", "ooh_wb_siblings_uncensored", "population_household",
              "population_person")

# remove: outdated cr_clean
#' Likely to be removed in future versions. Avoid dependencies.
#'
#' Clean up colnames from Portal, allow option to 
#' select columns and to convert to \code{Date} class.
#' 
#' You probably actually want \code{cr_clean}.
#' 
#' @param df data.frame frame stored procedure
#' @param select optional character vector of columns to keep
#' @param date boolean indicating whether any \code{datetime} columns
#' should be coverted to \code{Date} classes (default is \code{T}).
#' @export
portal_clean <- function(df, select = NULL, date = T) {
    warning("
            'portal_clean' is no longer supported as of pocr V1.0 and
            will be removed in future versions of pocr. You probably want
            `cr_clean` instead. Contact the package administrator for support 
            if you cannot resolve your issue - use 'maintainer('pocr')' to
            get contact details.
            ")
    names(df) <- make.names(names(df, allow_ = F))
    names(df) <- tolower(names(df))
    names(df) <- str_replace_all(names(df), pattern=" |/|\\(|\\)", replacement = ".")
    names(df) <- str_replace_all(names(df), pattern="/", replacement = ".")
    names(df) <- str_replace_all(names(df), pattern="\\(", replacement = "")
    names(df) <- str_replace_all(names(df), pattern="\\)", replacement = "")
    if (! is.null(select)) {
        select <- make.names(select, allow_ = F)
        df <- df[, select]
    }
    if (date) {
        to.change <- which(sapply(df, is.POSIXct))
        for (i in to.change) {
            df[, i] <- as.Date(df[, i])
        }
    }
    return(df)
}

# remove - unused
#' Likely to be removed in future versions. Avoid dependencies.
#' 
#' Sets working directory to \code{"S:/Data Portal"}
#' @export
resetwd <- function() {
    warning("
            'resetwd' is no longer supported as of pocr V1.0 and
            will be removed in future versions of pocr. You probably want
            `cr_clean` instead. Contact the package administrator for support 
            if you cannot resolve your issue - use 'maintainer('pocr')' to
            get contact details.
            ")
    
    setwd("S:/Data Portal")
}