#' Mark Use Day by Subject
#'
#' @param targetDrugs_char A character vector including which drugs should be
#'    counted against the subject
#' @param drugs_df A data frame with columns \code{who}, \code{when}, and
#'    \code{what}. This data frame measures which drugs were used by each
#'    subject over all days of treatment. This data set must also include a
#'    column \code{source}, which marks from which reporting source the drug use
#'    was recorded
#' @param reportSource A character vector matching the source of the reported
#'    drug use. The options must be from Timeline Followback (\code{"TFB"})
#'    questionnaires or daily urine drug screens (\code{"UDS"} or\code{"UDSAB"}).
#'
#' @return A modification of the \code{drugs_df} data set: the columns are
#'    \code{"who"}, \code{"when"}, and \code{"source"}; each row corresponds
#'    to one use day per subject per use source (if, for instance, there is drug
#'    use for a particular day recorded in both TFB and UDS, then that day will
#'    have two rows in the resulting data set).
#'
#' @details This function is basically just a fancy wrapper around some dplyr
#'    code. We just don't want the user to have to 1) know dplyr, or 2) write
#'    the code themselves.
#'
#' @importFrom magrittr `%>%`
#' @importFrom tibble as_tibble
#' @importFrom dplyr filter select distinct arrange
#'
#' @export
#'
#' @examples
#'    MarkUse(c("Crack", "Pcp", "Opioid"))
MarkUse <- function(targetDrugs_char,
                    drugs_df = NULL,
                    reportSource = c("TFB", "UDSAB", "UDS")){
  # browser()

  ###  Get the Data  ###
  if(is.null(drugs_df)){

    drugs_df <- loadRawData("all_drugs")[[1]]
    # We only want to match the argument if we are using the default data.
    #   Otherwise, the users can specify whatever source they want (as long as
    #   it's in the "source" column).
    reportSource <- match.arg(reportSource, several.ok = TRUE)

  } else {

    reqCols_char <- c("who", "when", "what", "source")
    if(!all(reqCols_char %in% colnames(drugs_df))){
      stop(
        "Columns [", paste(reqCols_char, collapse = " "), "] must be included in the drug use table.",
        call. = FALSE
      )
    }

  }

  ###  Match the Drug Names  ###
  allDrugs_char <- unique(drugs_df[["what"]])
  matchedDrugs_lgl <- targetDrugs_char %in% allDrugs_char
  if(all(!matchedDrugs_lgl)){
    stop(
      "No matching drugs found. If you are using the default data set, please
  see the help file for a list of possible drug choices.",
      call. = FALSE
    )
  } else if(any(!matchedDrugs_lgl)) {

    warning(
      "The following drugs were not matched: ",
      paste0(targetDrugs_char[!matchedDrugs_lgl], collapse = ", "),
      ". Please check for possible spelling/capitalization errors.",
      call. = FALSE
    )
    keptDrugs_char <- targetDrugs_char[matchedDrugs_lgl]

  } else {
    keptDrugs_char <- targetDrugs_char
  }

  ###  Filter the Data  ###
  who <- when <- what <- source <- NULL
  drugs_df %>%
    as_tibble() %>%
    filter(what %in% keptDrugs_char) %>%
    select(who, when, source) %>%
    distinct() %>%
    arrange(who, when)

}
