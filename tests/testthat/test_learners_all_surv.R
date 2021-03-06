context("learners_all_surv")

test_that("learners work: surv ", {

  # settings to make learners faster and deal with small sample size
  hyperpars = list(
    surv.cforest = list(mtry = 1L)
  )

  # normal survival analysis
  sub.task = subsetTask(surv.task, subset = c(1:70),
    features = getTaskFeatureNames(surv.task)[c(1, 2)])
  lrns = mylist("surv", create = TRUE)
  lapply(lrns, testThatLearnerParamDefaultsAreInParamSet)
  lapply(lrns, testBasicLearnerProperties, task = sub.task, hyperpars = hyperpars)

  # survival analysis with factors
  lrns = mylist("surv", properties = "factors", create = TRUE)
  lapply(lrns, testThatLearnerHandlesFactors, task = sub.task, hyperpars = hyperpars)

  # survival analysis with ordered factors
  lrns = mylist("surv", properties = "ordered", create = TRUE)
  lapply(lrns, testThatLearnerHandlesFactors, task = sub.task, hyperpars = hyperpars)

  # surv with weights
  # normal size of surv.task necessary otherwise cvglmnet does not converge
  lrns = mylist("surv", properties = "weights", create = TRUE)
  lapply(lrns, testThatLearnerRespectsWeights, hyperpars = hyperpars,
    task = surv.task, train.inds = surv.train.inds,
    test.inds = surv.test.inds,
    weights = rep(c(1L, 5L), length.out = length(surv.train.inds)),
    pred.type = "response", get.pred.fun = getPredictionResponse)

  # survival with missings
  lrns = mylist("surv", properties = "missings", create = TRUE)
  lapply(lrns, testThatLearnerHandlesMissings, task = sub.task, hyperpars = hyperpars)

  # surv with oobpreds
  lrns = mylist("surv", properties = "oobpreds", create = TRUE)
  lapply(lrns, testThatGetOOBPredsWorks, task = sub.task)

  # survival variable importance
  lrns = mylist("surv", properties = "featimp", create = TRUE)
  lapply(lrns, testThatLearnerHandlesMissings, task = surv.task, hyperpars = hyperpars)
  lapply(lrns, testThatLearnerCanCalculateImportance, task = surv.task, hyperpars = hyperpars)
})
