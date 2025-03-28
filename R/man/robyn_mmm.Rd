% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/model.R
\name{robyn_mmm}
\alias{robyn_mmm}
\alias{model_decomp}
\title{Core MMM Function}
\usage{
robyn_mmm(
  InputCollect,
  hyper_collect,
  iterations,
  cores,
  nevergrad_algo,
  intercept = TRUE,
  intercept_sign,
  ts_validation = TRUE,
  add_penalty_factor = FALSE,
  objective_weights = NULL,
  dt_hyper_fixed = NULL,
  rssd_zero_penalty = TRUE,
  refresh = FALSE,
  trial = 1L,
  seed = 123L,
  quiet = FALSE,
  ...
)

model_decomp(inputs = list())
}
\arguments{
\item{InputCollect}{List. Contains all input parameters for the model.
Required when \code{robyn_object} is not provided.}

\item{hyper_collect}{List. Containing hyperparameter bounds. Defaults to
\code{InputCollect$hyperparameters}.}

\item{iterations}{Integer. Number of iterations to run.}

\item{cores}{Integer. Default to \code{parallel::detectCores() - 1} (all cores
except one). Set to 1 if you want to turn parallel computing off.}

\item{nevergrad_algo}{Character. Default to "TwoPointsDE". Options are
\code{c("DE","TwoPointsDE", "OnePlusOne", "DoubleFastGADiscreteOnePlusOne",
"DiscreteOnePlusOne", "PortfolioDiscreteOnePlusOne", "NaiveTBPSA",
"cGA", "RandomSearch")}.}

\item{intercept}{Boolean. Should intercept(s) be fitted (default=TRUE) or
set to zero (FALSE).}

\item{intercept_sign}{Character. Choose one of "non_negative" (default) or
"unconstrained". By default, if intercept is negative, Robyn will drop intercept
and refit the model. Consider changing intercept_sign to "unconstrained" when
there are \code{context_vars} with large positive values.}

\item{ts_validation}{Boolean. When set to \code{TRUE}, Robyn will split data
by test, train, and validation partitions to validate the time series. By
default the "train_size" range is set to \code{c(0.5, 0.8)}, but it can be
customized or set to a fixed value using the hyperparameters input. For example,
if \code{train_size = 0.7}, validation size and test size will both be 0.15
and 0.15. When \code{ts_validation = FALSE}, nrmse_train is the
objective function; when \code{ts_validation = TRUE}, nrmse_val is the objective
function.}

\item{add_penalty_factor}{Boolean. Add penalty factor hyperparameters to
glmnet's penalty.factor to be optimized by nevergrad. Use with caution, because
this feature might add too much hyperparameter space and probably requires
more iterations to converge.}

\item{objective_weights}{Numeric vector. Default to NULL to give equal weights
to all objective functions. Order: NRMSE, DECOMP.RSSD, MAPE (when calibration
data is provided). When you are not calibrating, only the first 2 values for
\code{objective_weights} must be defined, i.e. set c(2, 1) to give double weight
to the 1st (NRMSE). This is an experimental feature. There's no research on
optimal weight setting. Subjective weights might strongly bias modeling results.}

\item{dt_hyper_fixed}{data.frame or named list. Only provide when loading
old model results. It consumes hyperparameters from saved csv
\code{pareto_hyperparameters.csv} or JSON file to replicate a model.}

\item{rssd_zero_penalty}{Boolean. When TRUE, the objective function
DECOMP.RSSD will penalize models with more 0 media effects additionally.
In other words, given the same DECOMP.RSSD score, a model with 50\% 0-coef
variables will get penalized by DECOMP.RSSD * 1.5 (larger error), while
another model with no 0-coef variables gets un-penalized with DECOMP.RSSD * 1.}

\item{refresh}{Boolean. Set to \code{TRUE} when used in \code{robyn_refresh()}.}

\item{trial}{Integer. Which trial are we running? Used to ID each model.}

\item{seed}{Integer. For reproducible results when running nevergrad and
clustering. Each trial will increase the seed by 1 unit (i.e. 10 trials with
seed 1 will share 9 results with 10 trials with seed 2).}

\item{quiet}{Boolean. Keep messages off?}

\item{...}{Additional parameters passed to \code{robyn_outputs()}.}

\item{inputs}{List. Elements to pass sub-functions}
}
\value{
List. MMM results with hyperparameters values.
}
\description{
\code{robyn_mmm()} function activates Nevergrad to generate samples of
hyperparameters, conducts media transformation within each loop, fits the
Ridge regression, calibrates the model optionally, decomposes responses
and collects the result. It's an inner function within \code{robyn_run()}.
}
