###
# Functions for Time Series Block Cross-Validation
###

#' hv-Block Cross-Validation
#' 
#' This function creates indices to implement hv-Block Cross-Validation by 
#' Racine (2000) which can be processed by the caret package.
#' 
#' @param data The dataset.
#' @param v_before The number of observations in the validation sample before 
#' observation i.
#' @param v_after The number of observations in the validation sample after 
#' observation i.
#' @param gap_before The number of observations that should be deleted before 
#' the validation sample.
#' @param gap_after The number of observations that should be deleted after 
#' the validation sample.
#' @return List of indices for the training and validation samples that can be
#' processed by the caret package.
#' 
#' @references Racine, Jeff. "Consistent cross-validatory model-selection for 
#' dependent data: hv-block cross-validation." Journal of econometrics 99.1 
#' (2000): 39-61.

hv_block <- function(data, v_before, v_after, gap_before, gap_after){
  # Get full sequence of indices (all_indices)
  max_index <- nrow(data)
  all_indices <- as.integer(seq(1,max_index,1))
  # Compute the length of the validation window and number of windows:
  window_length = 1 + v_before + v_after 
  n_window = max_index - v_before - v_after 
  # Split sequence all_indices using rolling window and save indices of 
  # validation sets
  chunk_func <- function(x,l) lapply(split(embed(x, l),row( embed(x, l))), sort)
  list_validation <- chunk_func(x=all_indices, l=window_length)
  # Attach gaps to validation indices 
  extend_func <- function(i,test=list_validation ,gap_b=gap_before, 
                          gap_a=gap_after){
    as.integer(seq(min(test[[i]])-gap_b, max(test[[i]])+gap_a,1))
  }
  list_extend <- lapply(1:n_window, extend_func)
  # Drop extended indices from sequence of all indices to obtain validation sets
  dropping_func <- function(i, list_ext = list_extend){
    as.integer(all_indices[!all_indices %in% list_ext[[i]]])
  }
  list_train <- lapply(1:n_window, dropping_func)
  # Generate List containing validation and training indices
  final_list <- list("validation" = list_validation, "training" = list_train)
  return(final_list)
}


#' Simplified Block Cross-Validation
#' 
#' This function creates indices to implement the simplified Block Cross-
#' Validation suggested by Bergmeir and Benítez (2012) which can be processed 
#' by the caret package.
#' 
#' @param data The dataset.
#' @param n_splits The number of folds.
#' @param gap_before The number of observations that should be deleted before 
#' the validation sample.
#' @param gap_after The number of observations that should be deleted after 
#' the validation sample.
#' @return List of indices for the training and validation samples that can be
#' processed by the caret package.

#' @references Bergmeir, Christoph, and José M. Benítez. "On the use of cross-
#' validation for time series predictor evaluation." Information Sciences 191 
#' (2012): 192-213.

simplified_block <- function(data, n_splits, gap_before, gap_after){
  # Get full sequence of indices (all_indices)
  max_index <- nrow(data)
  all_indices <- as.integer(seq(1,max_index,1))
  # Split sequence all_indices in n_splits equal parts and save in list -> 
  # indices of validation sets
  chunk_func <- function(x,n) split(x, cut(seq_along(x), n, labels = FALSE)) 
  list_validation <- chunk_func(all_indices, n_splits)
  # Attach gaps to validation indices 
  extend_func <- function(i,test=list_validation ,gap_b=gap_before, 
                          gap_a=gap_after){
    as.integer(seq(min(test[[i]])-gap_b, max(test[[i]])+gap_a,1))
  }
  list_extend <- lapply(1:n_splits, extend_func)
  # Drop extended indices from sequence of all indices to obtain validation sets
  dropping_func <- function(i, list_ext = list_extend){
    as.integer(all_indices[!all_indices %in% list_ext[[i]]])
  }
  list_train <- lapply(1:n_splits, dropping_func)
  # Generate List containing validation and training indices
  final_list <- list("validation" = list_validation, "training" = list_train)
  return(final_list)
}
